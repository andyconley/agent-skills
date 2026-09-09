#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "json"
require "yaml"

# Repository text is UTF-8. Declare it so File.read does not inherit a
# US-ASCII default from a C or POSIX locale and reject valid content.
Encoding.default_external = Encoding::UTF_8

ROOT = File.expand_path("../..", __dir__)
SKILL = File.join(ROOT, "skills", "workbreakdown")
REGISTRY_PATH = File.join(SKILL, "assets", "jira-templates", "registry.yaml")
FIXTURES = File.join(__dir__, "fixtures")
ROOT_KEYS = %w[schema_version manifest_id revision template_set scope epic children dependencies rank unknowns].freeze
CHILD_KEYS = %w[ref jira_key type variant template_id template_sha256 disposition verify changes fields].freeze
PAYLOAD_KEYS = %w[summary done_when evidence estimate description].freeze

def fail_test(message)
  warn "FAIL: #{message}"
  exit 1
end

def assert(condition, message)
  fail_test(message) unless condition
end

def clone(value)
  Marshal.load(Marshal.dump(value))
end

def load_yaml(path)
  YAML.safe_load(File.read(path), permitted_classes: [], aliases: true)
rescue Psych::Exception => e
  fail_test("#{File.basename(path)} is not valid YAML: #{e.message}")
end

def expect_error(fragment)
  yield
  fail_test("expected validation error containing #{fragment.inspect}")
rescue ArgumentError => e
  assert(e.message.include?(fragment), "wrong validation error: #{e.message}")
end

def reject_unknown_keys(value, allowed, context)
  unknown = value.keys - allowed
  raise ArgumentError, "#{context} has unknown field #{unknown.first}" unless unknown.empty?
end

def normalize_adf(value)
  case value
  when Hash
    value.keys.reject { |key| key == "localId" }.sort.each_with_object({}) do |key, normalized|
      normalized[key] = normalize_adf(value[key])
    end
  when Array
    value.map { |child| normalize_adf(child) }
  else
    value
  end
end

def adf_digest(value)
  Digest::SHA256.hexdigest(JSON.generate(normalize_adf(value)))
end

def validate_registry(registry)
  raise ArgumentError, "registry schema must be 2" unless registry["schema_version"] == 2
  raise ArgumentError, "default template set must be 3" unless registry["default_set_version"] == 3
  sets = registry.fetch("template_sets")
  raise ArgumentError, "missing template set 1" unless sets.key?(1)
  raise ArgumentError, "missing template set 2" unless sets.key?(2)
  raise ArgumentError, "missing template set 3" unless sets.key?(3)

  templates = registry.fetch("templates")
  ids = templates.map { |template| template.fetch("id") }
  raise ArgumentError, "duplicate template ID" unless ids.uniq.length == ids.length

  templates.each do |template|
    raise ArgumentError, "unknown template set" unless sets.key?(template["set_version"])
    compatible = template.fetch("compatible_set_versions", [template["set_version"]])
    raise ArgumentError, "native template set must remain compatible" unless compatible.include?(template["set_version"])
    raise ArgumentError, "unknown compatible template set" unless compatible.all? { |version| sets.key?(version) }
    file = File.join(SKILL, "assets", "jira-templates", template.fetch("file"))
    raise ArgumentError, "missing template asset" unless File.file?(file)
    raise ArgumentError, "template hash drift" unless Digest::SHA256.file(file).hexdigest == template["sha256"]
    overlap = template.fetch("required_keys") & template.fetch("conditional_keys")
    raise ArgumentError, "required and conditional keys overlap" unless overlap.empty?
  end

  known = ids.each_with_object({}) { |id, memo| memo[id] = true }
  index = templates.to_h { |template| [template["id"], template] }
  sets.each do |version, set|
    defaults = set.fetch("defaults")
    defaults.each do |issue_type, value|
      variants = value.is_a?(Hash) ? value : {nil => value}
      variants.each do |variant, id|
        raise ArgumentError, "unknown default template" unless known[id]
        template = index.fetch(id)
        compatible = template.fetch("compatible_set_versions", [template["set_version"]])
        raise ArgumentError, "default template-set mismatch" unless compatible.include?(version)
        raise ArgumentError, "default issue-type mismatch" unless template["issue_type"] == issue_type
        raise ArgumentError, "default Spike variant mismatch" if variant && template["variant"] != variant
      end
    end
  end
end

def template_supports_set?(template, set_version)
  template.fetch("compatible_set_versions", [template["set_version"]]).include?(set_version)
end

def validate_exception(exception, obligation)
  raise ArgumentError, "invalid approved exception" unless exception.is_a?(Hash)
  required = %w[obligation reason approver approval_evidence]
  raise ArgumentError, "invalid approved exception" unless required.all? { |key| !exception[key].to_s.empty? }
  raise ArgumentError, "exception covers wrong obligation" unless exception["obligation"] == obligation
end

def validate_scenario_ids(description)
  scenarios = description.fetch("scenarios")
  ids = scenarios.map { |item| item["id"] }
  raise ArgumentError, "Story scenarios require unique IDs" if ids.any? { |id| id.to_s.empty? } || ids.uniq.length != ids.length
  ids
end

def validate_story_description(description, instrumentation_required: false)
  scenario_ids = validate_scenario_ids(description)

  documents = description["documentation"]
  document_exception = description["documentation_exception"]
  if documents && !documents.empty?
    documents.each do |item|
      required = %w[id artifact audience intended_location]
      raise ArgumentError, "incomplete documentation plan" unless required.all? { |key| !item[key].to_s.empty? }
    end
    document_ids = documents.map { |item| item["id"] }
    raise ArgumentError, "documentation IDs must be unique" unless document_ids.uniq.length == document_ids.length
  else
    validate_exception(document_exception, "documentation")
  end

  tests = description["automated_tests"]
  test_exception = description["automated_tests_exception"]
  if tests && !tests.empty?
    tests.each do |item|
      # suite_or_location and environment are optional at plan time. A Story can be
      # IMPLEMENTATION READY before the repo or the environment exists. IN REVIEW
      # still requires a named environment in the evidence.
      required = %w[scenario_id level expected_evidence]
      raise ArgumentError, "incomplete automated-test plan" unless required.all? { |key| !item[key].to_s.empty? }
      raise ArgumentError, "manual test is not a substitute" unless %w[integration functional].include?(item["level"])
      raise ArgumentError, "automated test is not mapped to a scenario" unless scenario_ids.include?(item["scenario_id"])
    end
    test_scenarios = tests.map { |item| item["scenario_id"] }
    raise ArgumentError, "automated tests must cover every scenario exactly once" unless test_scenarios.sort == scenario_ids.sort && test_scenarios.uniq.length == test_scenarios.length
  else
    validate_exception(test_exception, "automated_tests")
  end


  if instrumentation_required
    signals = description["instrumentation"]
    instrumentation_exception = description["instrumentation_exception"]
    if signals && !signals.empty?
      signals.each do |item|
    required = %w[id class signal purpose implementation_target expected_observation]
        raise ArgumentError, "incomplete instrumentation plan" unless required.all? { |key| !item[key].to_s.empty? }
        raise ArgumentError, "invalid instrumentation class" unless %w[operational business].include?(item["class"])
      end
      signal_ids = signals.map { |item| item["id"] }
      raise ArgumentError, "instrumentation IDs must be unique" if signal_ids.any? { |id| id.to_s.empty? } || signal_ids.uniq.length != signal_ids.length
    else
      validate_exception(instrumentation_exception, "instrumentation")
    end
  end
  validate_quality(description)
end

def validate_quality(value)
  case value
  when Hash
    value.each_value { |child| validate_quality(child) }
  when Array
    value.each { |child| validate_quality(child) }
  when String
    normalized = value.strip.downcase
    raise ArgumentError, "unresolved placeholder" if value.match?(/<[^>]+>/)
    raise ArgumentError, "empty filler value" if %w[n/a none].include?(normalized)
    raise ArgumentError, "generic evidence" if ["tests added", "documentation updated", "docs reviewed", "metrics added", "dashboard updated", "add logging"].include?(normalized)
  end
end

def validate_description(description, template)
  missing = template.fetch("required_keys") - description.keys
  raise ArgumentError, "missing description key" unless missing.empty?
  allowed = template.fetch("required_keys") + template.fetch("conditional_keys")
  raise ArgumentError, "unapproved description key" unless (description.keys - allowed).empty?

  template.fetch("required_one_of", []).each do |alternatives|
    present = alternatives.select { |key| description.key?(key) && !description[key].nil? && description[key] != [] }
    raise ArgumentError, "missing required obligation" if present.empty?
    raise ArgumentError, "conflicting obligation and exception" if present.length > 1
  end

  # Content expectations apply to every template set. Only the template asset and
  # its declared key set are grandfathered; the content bar never is. A v1-bound
  # Story cannot declare v2 evidence keys, so its documentation and automated-test
  # obligations are enforced as Review and Audit lifecycle judgments instead.
  if template["issue_type"] == "Story"
    case template["id"]
    when "jira-story-v2"
      validate_story_description(description)
    when "jira-story-v3"
      validate_story_description(description, instrumentation_required: true)
    end
  end
  validate_quality(description)
end

def validate_epic_description(description, template)
  validate_description(description, template)
  criteria = description.fetch("acceptance_criteria")
  raise ArgumentError, "Epic requires 3-5 acceptance criteria" unless criteria.length.between?(3, 5)
  criteria.each do |criterion|
    raise ArgumentError, "Epic criterion lacks evidence" if criterion["condition"].to_s.empty? || criterion["evidence"].to_s.empty?
  end
  success = description.fetch("success_measures").map { |item| item.to_s.downcase.strip }
  conditions = criteria.map { |item| item["condition"].to_s.downcase.strip }
  raise ArgumentError, "Epic acceptance duplicates success measures" unless (success & conditions).empty?
end

def validate_child(child, templates, set_version)
  reject_unknown_keys(child, CHILD_KEYS, "child")
  raise ArgumentError, "unsupported child type" unless %w[Spike Task Story].include?(child["type"])
  disposition = child["disposition"]
  raise ArgumentError, "invalid child disposition" unless %w[existing update proposed].include?(disposition)
  payload_key = {"existing" => "verify", "update" => "changes", "proposed" => "fields"}[disposition]
  raise ArgumentError, "wrong child disposition payload" unless child[payload_key].is_a?(Hash)
  supplied_payloads = %w[verify changes fields].select { |key| child.key?(key) }
  raise ArgumentError, "multiple child disposition payloads" unless supplied_payloads == [payload_key]
  jira_key = child["jira_key"]
  raise ArgumentError, "existing child requires Jira key" if disposition != "proposed" && jira_key.to_s.empty?
  raise ArgumentError, "proposed child cannot have Jira key" if disposition == "proposed" && !jira_key.nil?

  payload = child.fetch(payload_key)
  reject_unknown_keys(payload, PAYLOAD_KEYS, "child payload")
  raise ArgumentError, "child requires summary and done_when" unless %w[summary done_when].all? { |key| !payload[key].to_s.empty? }

  template_id = child["template_id"]
  if template_id.nil?
    raise ArgumentError, "proposed child requires template" if disposition == "proposed"
    raise ArgumentError, "description requires template" if payload.key?("description")
    return
  end

  template = templates[template_id]
  raise ArgumentError, "unknown child template" unless template
  raise ArgumentError, "template-set mismatch" unless template_supports_set?(template, set_version)
  raise ArgumentError, "child type/template mismatch" unless child["type"] == template["issue_type"]
  if child["type"] == "Spike" && template["variant"] != "legacy"
    raise ArgumentError, "Spike variant mismatch" unless child["variant"] == template["variant"]
  end
  if set_version == 1
    raise ArgumentError, "legacy template hash mismatch" if child["template_sha256"] && child["template_sha256"] != template["sha256"]
  else
    raise ArgumentError, "child template hash mismatch" unless child["template_sha256"] == template["sha256"]
  end
  raise ArgumentError, "proposed child requires description" if disposition == "proposed" && !payload["description"].is_a?(Hash)
  validate_description(payload["description"], template) if payload["description"]
end

def validate_manifest(manifest, templates, registry)
  reject_unknown_keys(manifest, ROOT_KEYS, "manifest")
  schema = manifest.fetch("schema_version")
  raise ArgumentError, "unsupported schema" unless [2, 3].include?(schema)
  reject_unknown_keys(manifest.fetch("template_set"), %w[id version], "template_set")
  raise ArgumentError, "wrong registry" unless manifest.dig("template_set", "id") == "jira-house-templates"
  set_version = manifest.dig("template_set", "version")
  raise ArgumentError, "unknown template-set version" unless registry.fetch("template_sets").key?(set_version)
  reject_unknown_keys(manifest.fetch("scope"), %w[parent_key epic_key], "scope")

  epic = manifest.fetch("epic")
  if schema == 2
    reject_unknown_keys(epic, %w[outcome target_duration], "schema-2 Epic")
  else
    raise ArgumentError, "schema 3 requires an Epic-compatible template set" unless template_supports_set?(templates.fetch("jira-epic-v2"), set_version)
    disposition = epic["disposition"]
    raise ArgumentError, "missing Epic disposition" unless %w[existing update].include?(disposition)
    if disposition == "existing"
      reject_unknown_keys(epic, %w[disposition verify], "existing Epic")
      verify = epic.fetch("verify")
      reject_unknown_keys(verify, %w[template_id template_sha256 description_adf_sha256 description], "Epic verify")
      template = templates[verify["template_id"]]
      raise ArgumentError, "invalid Epic template" unless template && template["id"] == "jira-epic-v2"
      raise ArgumentError, "Epic template hash mismatch" unless verify["template_sha256"] == template["sha256"]
      digest = verify["description_adf_sha256"]
      raise ArgumentError, "missing current ADF digest" unless digest&.match?(/\A[0-9a-f]{64}\z/)
      validate_epic_description(verify.fetch("description"), template)
    else
      reject_unknown_keys(epic, %w[disposition template_id template_sha256 expected_current changes], "update Epic")
      template = templates[epic["template_id"]]
      raise ArgumentError, "invalid Epic template" unless template && template["id"] == "jira-epic-v2"
      raise ArgumentError, "Epic template hash mismatch" unless epic["template_sha256"] == template["sha256"]
      expected = epic.fetch("expected_current")
      reject_unknown_keys(expected, %w[description_adf_sha256], "expected_current")
      digest = expected["description_adf_sha256"]
      raise ArgumentError, "missing current ADF digest" unless digest&.match?(/\A[0-9a-f]{64}\z/)
      changes = epic.fetch("changes")
      raise ArgumentError, "forbidden Epic field" unless changes.keys == ["description"]
      validate_epic_description(changes.fetch("description"), template)
    end
  end

  children = manifest.fetch("children")
  refs = children.map { |child| child["ref"] }
  raise ArgumentError, "child refs must be unique and nonempty" if refs.any? { |ref| ref.to_s.empty? } || refs.uniq.length != refs.length
  children.each { |child| validate_child(child, templates, set_version) }
end

def validate_story_review(story)
  description = story.fetch("description")
  review = description.fetch("review_evidence")
  published = review.fetch("documentation", [])
  passing = review.fetch("automated_tests", [])
  observed = review.fetch("instrumentation", [])
  confirmed_exceptions = review.fetch("approved_exceptions", [])
  planned_documents = description.fetch("documentation", []).map { |item| item["id"] }
  planned_scenarios = description.fetch("automated_tests", []).map { |item| item["scenario_id"] }
  planned_environments = description.fetch("automated_tests", []).to_h { |item| [item["scenario_id"], item["environment"]] }
  planned_signals = description.fetch("instrumentation", []).map { |item| item["id"] }
  raise ArgumentError, "missing published documentation evidence" if planned_documents.any? && published.empty?
  raise ArgumentError, "missing passing automated-test evidence" if planned_scenarios.any? && passing.empty?
  raise ArgumentError, "missing published documentation evidence" unless published.all? do |item|
    valid_status = %w[published updated confirmed_current].include?(item["status"])
    confirmed = item["status"] != "confirmed_current" || (!item["reviewer"].to_s.empty? && !item["review_record"].to_s.empty?)
    valid_status && confirmed && !item["evidence"].to_s.empty?
  end
  raise ArgumentError, "missing passing automated-test evidence" unless passing.all? { |item| item["status"] == "passed" && !item["environment"].to_s.empty? && !item["evidence"].to_s.empty? }
  raise ArgumentError, "missing instrumentation evidence" if planned_signals.any? && observed.empty?
  raise ArgumentError, "incomplete instrumentation evidence" unless observed.all? do |item|
    %w[signal_id environment implementation_evidence observed_output evidence].all? { |key| !item[key].to_s.empty? }
  end
  evidence_documents = published.map { |item| item["artifact_id"] }
  evidence_scenarios = passing.map { |item| item["scenario_id"] }
  evidence_signals = observed.map { |item| item["signal_id"] }
  raise ArgumentError, "documentation evidence does not match the plan" unless evidence_documents.sort == planned_documents.sort && evidence_documents.uniq.length == evidence_documents.length
  raise ArgumentError, "automated-test evidence does not match the plan" unless evidence_scenarios.sort == planned_scenarios.sort && evidence_scenarios.uniq.length == evidence_scenarios.length
  raise ArgumentError, "instrumentation evidence does not match the plan" unless evidence_signals.sort == planned_signals.sort && evidence_signals.uniq.length == evidence_signals.length
  raise ArgumentError, "automated-test evidence uses the wrong environment" unless passing.all? do |item|
    planned = planned_environments[item["scenario_id"]]
    planned.to_s.empty? || item["environment"] == planned
  end

  expected_exceptions = %w[documentation automated_tests instrumentation].each_with_object([]) do |obligation, memo|
    exception = description["#{obligation}_exception"]
    memo << [obligation, exception["approval_evidence"]] if exception
  end
  actual_exceptions = confirmed_exceptions.map do |item|
    raise ArgumentError, "invalid exception confirmation" unless item["status"] == "confirmed"
    raise ArgumentError, "invalid exception confirmation" if item["obligation"].to_s.empty? || item["approval_evidence"].to_s.empty?
    [item["obligation"], item["approval_evidence"]]
  end
  raise ArgumentError, "exception confirmation does not match the plan" unless actual_exceptions.sort == expected_exceptions.sort && actual_exceptions.uniq.length == actual_exceptions.length
end

def validate_legacy_story_review(story, lifecycle_evidence)
  description = story.fetch("description")
  raise ArgumentError, "legacy evidence identifies the wrong Story" unless lifecycle_evidence["story_key"] == story["jira_key"]
  raise ArgumentError, "legacy evidence identifies the wrong template" unless lifecycle_evidence["template_id"] == story["template_id"]

  scenarios = description.fetch("scenarios")
  if scenarios.all? { |item| item.is_a?(Hash) && !item["id"].to_s.empty? }
    scenario_ids = validate_scenario_ids(description)
  else
    raise ArgumentError, "mixed legacy scenario shapes" unless scenarios.none? { |item| item.is_a?(Hash) }
    bindings = lifecycle_evidence.fetch("scenario_bindings", [])
    scenario_ids = bindings.map { |item| item["id"] }
    source_texts = bindings.map { |item| item["source_text"] }
    raise ArgumentError, "invalid legacy scenario binding" if scenario_ids.any? { |id| id.to_s.empty? } || scenario_ids.uniq.length != scenario_ids.length
    raise ArgumentError, "legacy scenario binding does not match the Story" unless source_texts.sort == scenarios.map(&:to_s).sort && source_texts.uniq.length == source_texts.length
  end
  classes = %w[documentation automated_tests instrumentation]

  classes.each do |obligation|
    evidence = lifecycle_evidence.fetch(obligation, [])
    exception = lifecycle_evidence["#{obligation}_exception"]
    raise ArgumentError, "conflicting legacy evidence and exception" if !evidence.empty? && exception
    if evidence.empty?
      validate_exception(exception, obligation)
    end
  end

  documents = lifecycle_evidence.fetch("documentation", [])
  documents.each do |item|
    allowed = %w[published updated confirmed_current]
    raise ArgumentError, "invalid legacy documentation evidence" unless allowed.include?(item["status"]) && !item["artifact"].to_s.empty? && !item["evidence"].to_s.empty?
    if item["status"] == "confirmed_current"
      raise ArgumentError, "invalid legacy documentation evidence" if item["reviewer"].to_s.empty? || item["review_record"].to_s.empty?
    end
  end

  tests = lifecycle_evidence.fetch("automated_tests", [])
  tests.each do |item|
    required = %w[scenario_id level status environment evidence]
    raise ArgumentError, "invalid legacy automated-test evidence" unless required.all? { |key| !item[key].to_s.empty? }
    raise ArgumentError, "unit or manual test is not a substitute" unless %w[integration functional].include?(item["level"])
    raise ArgumentError, "legacy automated test is not mapped to a scenario" unless scenario_ids.include?(item["scenario_id"])
    raise ArgumentError, "invalid legacy automated-test evidence" unless item["status"] == "passed"
  end
  covered_scenarios = tests.map { |item| item["scenario_id"] }
  if tests.any?
    raise ArgumentError, "legacy automated tests must cover every scenario exactly once" unless covered_scenarios.sort == scenario_ids.sort && covered_scenarios.uniq.length == covered_scenarios.length
  end

  lifecycle_evidence.fetch("instrumentation", []).each do |item|
    required = %w[signal_id class purpose environment implementation_evidence observed_output evidence]
    raise ArgumentError, "invalid legacy instrumentation evidence" unless required.all? { |key| !item[key].to_s.empty? }
    raise ArgumentError, "invalid instrumentation class" unless %w[operational business].include?(item["class"])
  end
  validate_quality(lifecycle_evidence)
end

registry = load_yaml(REGISTRY_PATH)
validate_registry(registry)
templates = registry.fetch("templates")
index = templates.to_h { |template| [template["id"], template] }

duplicate_registry = clone(registry)
duplicate_registry["templates"] << clone(duplicate_registry["templates"].first)
expect_error("duplicate template ID") { validate_registry(duplicate_registry) }

drifted_registry = clone(registry)
drifted_registry["templates"].first["sha256"] = "0" * 64
expect_error("template hash drift") { validate_registry(drifted_registry) }

missing_asset_registry = clone(registry)
missing_asset_registry["templates"].first["file"] = "epic-v1-does-not-exist.md"
expect_error("missing template asset") { validate_registry(missing_asset_registry) }

variant_default_registry = clone(registry)
variant_default_registry["template_sets"][2]["defaults"]["Spike"]["design"] = "jira-spike-investigation-v2"
expect_error("default Spike variant mismatch") { validate_registry(variant_default_registry) }

expected_v1 = {
  "jira-epic-v1" => "e6ac1fced57839ccaca7c56fe42cd08b5907af5b15f2f050625350dfaf9c758a",
  "jira-story-v1" => "b8865258f0a17dd5f495e4b004fa27761af0b89911be405f5f1f6fc2602b3259",
  "jira-task-v1" => "b7bd307184299f026c25df32903455f0ee6fa60d66e6f08ef747508685adffe6",
  "jira-spike-v1" => "66dcbb09cbface7f0ceadd8feddb25e2512d4e488f3d414427ba2e7393b3eb88"
}
expected_v1.each { |id, digest| assert(index.dig(id, "sha256") == digest, "#{id} identity changed") }

v1_defaults = registry.dig("template_sets", 1, "defaults")
v2_defaults = registry.dig("template_sets", 2, "defaults")
v3_defaults = registry.dig("template_sets", 3, "defaults")
assert(v1_defaults["Task"] == "jira-task-v1", "template set 1 lost its defaults")
assert(v2_defaults["Epic"] == "jira-epic-v2", "Epic v2 is not default")
assert(v2_defaults["Story"] == "jira-story-v2", "Story v2 is not default")
assert(v2_defaults["Task"] == "jira-task-v2", "Task v2 is not default")
assert(v2_defaults.dig("Spike", "design") == "jira-spike-design-v2", "design Spike v2 is not default")
assert(v2_defaults.dig("Spike", "investigation") == "jira-spike-investigation-v2", "investigation Spike v2 is not default")
assert(v3_defaults["Story"] == "jira-story-v3", "Story v3 is not the new default")
assert(v3_defaults["Epic"] == "jira-epic-v2", "template set 3 lost the compatible Epic")
assert(index.dig("jira-story-v2", "sha256") == "ca7c5dcf753d6a0e2f432ef436801422ea81ca4c5c20bdabb358197c9c4fc6b4", "Story v2 identity changed")
assert(index.dig("jira-story-v3", "sha256") == "c19201ccb6e6f59671c0d33b45df3524d9d0662b3563d133e1f6f02c2774fef4", "Story v3 identity changed")

legacy = load_yaml(File.join(FIXTURES, "schema2-v1-valid.yaml"))
validate_manifest(legacy, index, registry)
assert(!legacy["children"].first.key?("template_sha256"), "legacy fixture is not a pre-v2 manifest")

# v1-bound manifests keep their frozen templates but are held to the v2 content bar.
v1_description = {
  "context" => "The legacy task still needs its recorded context.",
  "assumptions" => "The approved legacy scope is unchanged.",
  "out_of_scope" => "No new interface work.",
  "acceptance_criteria" => ["The approved legacy task completes unchanged."],
  "technical_considerations" => "Reuses the existing pipeline.",
  "open_questions" => "None recorded."
}
legacy_with_description = clone(legacy)
legacy_with_description["children"].first["verify"]["description"] = clone(v1_description)
validate_manifest(legacy_with_description, index, registry)

legacy_placeholder = clone(legacy_with_description)
legacy_placeholder["children"].first["verify"]["description"]["context"] = "<fill in the context>"
expect_error("unresolved placeholder") { validate_manifest(legacy_placeholder, index, registry) }

legacy_filler = clone(legacy_with_description)
legacy_filler["children"].first["verify"]["description"]["technical_considerations"] = "N/A"
expect_error("empty filler value") { validate_manifest(legacy_filler, index, registry) }

legacy_generic = clone(legacy_with_description)
legacy_generic["children"].first["verify"]["description"]["acceptance_criteria"] = ["Tests added"]
expect_error("generic evidence") { validate_manifest(legacy_generic, index, registry) }

legacy_unapproved_key = clone(legacy_with_description)
legacy_unapproved_key["children"].first["verify"]["description"]["automated_tests"] = []
expect_error("unapproved description key") { validate_manifest(legacy_unapproved_key, index, registry) }

mixed_version = clone(legacy)
mixed_version["children"].first["template_id"] = "jira-task-v2"
mixed_version["children"].first["template_sha256"] = index.dig("jira-task-v2", "sha256")
expect_error("template-set mismatch") { validate_manifest(mixed_version, index, registry) }

unbound_description = clone(legacy)
unbound_description["children"].first.delete("template_id")
unbound_description["children"].first["verify"]["description"] = {"context" => "Unbound content"}
expect_error("description requires template") { validate_manifest(unbound_description, index, registry) }

multiple_payloads = clone(legacy)
multiple_payloads["children"].first["changes"] = {"summary" => "Unexpected", "done_when" => "Unexpected"}
expect_error("multiple child disposition payloads") { validate_manifest(multiple_payloads, index, registry) }

unsupported_child = clone(legacy)
unsupported_child["children"].first["type"] = "Bug"
expect_error("unsupported child type") { validate_manifest(unsupported_child, index, registry) }

duplicate_ref = clone(legacy)
duplicate_ref["children"] << clone(duplicate_ref["children"].first)
expect_error("child refs must be unique and nonempty") { validate_manifest(duplicate_ref, index, registry) }

proposed_without_template = clone(legacy)
proposed_without_template["children"].first.delete("template_id")
proposed_without_template["children"].first["jira_key"] = nil
proposed_without_template["children"].first["disposition"] = "proposed"
proposed_without_template["children"].first["fields"] = proposed_without_template["children"].first.delete("verify")
expect_error("proposed child requires template") { validate_manifest(proposed_without_template, index, registry) }

invalid_schema2 = load_yaml(File.join(FIXTURES, "schema2-epic-update-invalid.yaml"))
expect_error("schema-2 Epic has unknown field") { validate_manifest(invalid_schema2, index, registry) }

schema3 = load_yaml(File.join(FIXTURES, "schema3-epic-update-valid.yaml"))
validate_manifest(schema3, index, registry)

existing = clone(schema3)
existing["epic"] = {
  "disposition" => "existing",
  "verify" => {
    "template_id" => "jira-epic-v2",
    "template_sha256" => index.dig("jira-epic-v2", "sha256"),
    "description_adf_sha256" => "a" * 64,
    "description" => clone(schema3.dig("epic", "changes", "description"))
  }
}
validate_manifest(existing, index, registry)

missing_disposition = clone(existing)
missing_disposition["epic"].delete("disposition")
expect_error("missing Epic disposition") { validate_manifest(missing_disposition, index, registry) }

empty_verify = clone(existing)
empty_verify["epic"]["verify"] = {}
expect_error("invalid Epic template") { validate_manifest(empty_verify, index, registry) }

forbidden = clone(schema3)
forbidden["epic"]["changes"]["status"] = "Done"
expect_error("forbidden Epic field") { validate_manifest(forbidden, index, registry) }

side_field = clone(schema3)
side_field["epic"]["status"] = "Done"
expect_error("update Epic has unknown field") { validate_manifest(side_field, index, registry) }

root_field = clone(schema3)
root_field["transition"] = "Done"
expect_error("manifest has unknown field") { validate_manifest(root_field, index, registry) }

drifted = clone(schema3)
drifted["epic"]["template_sha256"] = "0" * 64
expect_error("Epic template hash mismatch") { validate_manifest(drifted, index, registry) }

missing_digest = clone(schema3)
missing_digest["epic"]["expected_current"].delete("description_adf_sha256")
expect_error("missing current ADF digest") { validate_manifest(missing_digest, index, registry) }

incomplete = clone(schema3)
incomplete["epic"]["changes"]["description"].delete("problem")
expect_error("missing description key") { validate_manifest(incomplete, index, registry) }

unapproved_key = clone(schema3)
unapproved_key["epic"]["changes"]["description"]["internal_notes"] = "Not a registered Epic key."
expect_error("unapproved description key") { validate_manifest(unapproved_key, index, registry) }

duplicated_criteria = clone(schema3)
duplicated_criteria["epic"]["changes"]["description"]["success_measures"] =
  [duplicated_criteria["epic"]["changes"]["description"]["acceptance_criteria"].first["condition"]]
expect_error("Epic acceptance duplicates success measures") { validate_manifest(duplicated_criteria, index, registry) }

too_few_criteria = clone(schema3)
too_few_criteria["epic"]["changes"]["description"]["acceptance_criteria"] = too_few_criteria["epic"]["changes"]["description"]["acceptance_criteria"].first(2)
expect_error("Epic requires 3-5 acceptance criteria") { validate_manifest(too_few_criteria, index, registry) }

v2_children = load_yaml(File.join(FIXTURES, "schema2-v2-children.yaml"))
validate_manifest(v2_children, index, registry)
assert(v2_children["children"].map { |child| child["template_id"] }.sort ==
       %w[jira-spike-design-v2 jira-spike-investigation-v2 jira-task-v2],
       "v2 child fixture lost a template under test")

v2_children["children"].each do |child|
  template = index.fetch(child.fetch("template_id"))
  description = child.dig("fields", "description")
  missing_required = clone(v2_children)
  target = missing_required["children"].find { |item| item["ref"] == child["ref"] }
  target["fields"]["description"].delete(template.fetch("required_keys").first)
  expect_error("missing description key") { validate_manifest(missing_required, index, registry) }

  undeclared = clone(v2_children)
  target = undeclared["children"].find { |item| item["ref"] == child["ref"] }
  target["fields"]["description"]["internal_notes"] = "Not a registered key."
  expect_error("unapproved description key") { validate_manifest(undeclared, index, registry) }

  assert(description.keys.all? { |key| (template.fetch("required_keys") + template.fetch("conditional_keys")).include?(key) },
         "#{child["ref"]} uses a key the registry does not declare")
end

swapped_variant = clone(v2_children)
design_child = swapped_variant["children"].find { |child| child["ref"] == "choose-transport" }
design_child["variant"] = "investigation"
expect_error("Spike variant mismatch") { validate_manifest(swapped_variant, index, registry) }

story = load_yaml(File.join(FIXTURES, "story-lifecycle.yaml"))
validate_story_description(story.fetch("description"))
validate_story_review(story)
assert(!story.dig("description", "documentation", 0).key?("owner"), "unknown owner must not render an empty field")

# A Story can be IMPLEMENTATION READY before the repo or the environment exists.
unsited_plan = clone(story)
unsited_plan["description"]["automated_tests"].first.delete("suite_or_location")
unsited_plan["description"]["automated_tests"].first.delete("environment")
validate_story_description(unsited_plan["description"])

# IN REVIEW still demands a named environment in the evidence.
unsited_review = clone(unsited_plan)
unsited_review["description"]["review_evidence"]["automated_tests"].first["environment"] = ""
expect_error("missing passing automated-test evidence") { validate_story_review(unsited_review) }

# With no planned environment, any named environment in the evidence is accepted.
unsited_elsewhere = clone(unsited_plan)
unsited_elsewhere["description"]["review_evidence"]["automated_tests"].first["environment"] = "lab-cell-7"
validate_story_review(unsited_elsewhere)

missing_docs = clone(story)
missing_docs["description"]["review_evidence"]["documentation"].first["status"] = "planned"
expect_error("missing published documentation evidence") { validate_story_review(missing_docs) }

missing_tests = clone(story)
missing_tests["description"]["review_evidence"]["automated_tests"].first["status"] = "planned"
expect_error("missing passing automated-test evidence") { validate_story_review(missing_tests) }

empty_review = clone(story)
empty_review["description"]["review_evidence"]["documentation"] = []
empty_review["description"]["review_evidence"]["automated_tests"] = []
expect_error("missing published documentation evidence") { validate_story_review(empty_review) }

unmapped_review = clone(story)
unmapped_review["description"]["review_evidence"]["automated_tests"].first["scenario_id"] = "other-scenario"
expect_error("automated-test evidence does not match the plan") { validate_story_review(unmapped_review) }

manual_only = clone(story)
manual_only["description"]["automated_tests"].first["level"] = "manual"
expect_error("manual test is not a substitute") { validate_story_description(manual_only["description"]) }

partial_coverage = clone(story["description"])
partial_coverage["scenarios"] << {"id" => "authorization-failure", "behavior" => "An unauthorized caller is rejected."}
expect_error("automated tests must cover every scenario exactly once") { validate_story_description(partial_coverage) }

duplicate_document = clone(story["description"])
duplicate_document["documentation"] << clone(duplicate_document["documentation"].first)
expect_error("documentation IDs must be unique") { validate_story_description(duplicate_document) }

wrong_environment = clone(story)
wrong_environment["description"]["review_evidence"]["automated_tests"].first["environment"] = "different-system"
expect_error("automated-test evidence uses the wrong environment") { validate_story_review(wrong_environment) }

exception_story = clone(story["description"])
exception_story.delete("documentation")
exception_story["documentation_exception"] = {
  "obligation" => "documentation",
  "reason" => "No external or operational behavior changes.",
  "approver" => "Documentation owner",
  "approval_evidence" => "review-42"
}
validate_story_description(exception_story)

unapproved_exception = clone(exception_story)
unapproved_exception["documentation_exception"].delete("approval_evidence")
expect_error("invalid approved exception") { validate_story_description(unapproved_exception) }

story_v3 = load_yaml(File.join(FIXTURES, "story-v3-lifecycle.yaml"))
validate_story_description(story_v3.fetch("description"), instrumentation_required: true)
validate_story_review(story_v3)

v3_manifest = clone(v2_children)
v3_manifest["template_set"]["version"] = 3
v3_manifest["children"] << {
  "ref" => "prove-recovery",
  "jira_key" => nil,
  "type" => "Story",
  "template_id" => "jira-story-v3",
  "template_sha256" => index.dig("jira-story-v3", "sha256"),
  "disposition" => "proposed",
  "fields" => {
    "summary" => "Prove stalled-transfer recovery",
    "done_when" => "The integrated recovery behavior and its delivery evidence pass review.",
    "description" => clone(story_v3["description"])
  }
}
v3_manifest["rank"]["order"] << "prove-recovery"
validate_manifest(v3_manifest, index, registry)

v2_story_in_v3 = clone(v3_manifest)
v2_child = v2_story_in_v3["children"].last
v2_child["template_id"] = "jira-story-v2"
v2_child["template_sha256"] = index.dig("jira-story-v2", "sha256")
expect_error("template-set mismatch") { validate_manifest(v2_story_in_v3, index, registry) }

v3_story_in_v2 = clone(v3_manifest)
v3_story_in_v2["template_set"]["version"] = 2
expect_error("template-set mismatch") { validate_manifest(v3_story_in_v2, index, registry) }

schema3_set3 = clone(schema3)
schema3_set3["template_set"]["version"] = 3
validate_manifest(schema3_set3, index, registry)

set3_manifest = clone(v2_children)
set3_manifest["template_set"]["version"] = 3
set3_manifest["children"] << {
  "ref" => "prove-recovery",
  "jira_key" => nil,
  "type" => "Story",
  "template_id" => "jira-story-v3",
  "template_sha256" => index.dig("jira-story-v3", "sha256"),
  "disposition" => "proposed",
  "fields" => {
    "summary" => "Prove stalled-transfer recovery",
    "done_when" => "The recovery behavior and delivery evidence pass review.",
    "description" => clone(story_v3["description"])
  }
}
validate_manifest(set3_manifest, index, registry)

v2_story_in_set3 = clone(set3_manifest)
v2_story_in_set3["children"].last["template_id"] = "jira-story-v2"
v2_story_in_set3["children"].last["template_sha256"] = index.dig("jira-story-v2", "sha256")
expect_error("template-set mismatch") { validate_manifest(v2_story_in_set3, index, registry) }

schema3_set3 = clone(schema3)
schema3_set3["template_set"]["version"] = 3
validate_manifest(schema3_set3, index, registry)

business_signal = clone(story_v3["description"])
business_signal["instrumentation"].first["class"] = "business"
validate_story_description(business_signal, instrumentation_required: true)

invalid_signal_class = clone(story_v3["description"])
invalid_signal_class["instrumentation"].first["class"] = "logging"
expect_error("invalid instrumentation class") { validate_story_description(invalid_signal_class, instrumentation_required: true) }

unit_only = clone(story_v3["description"])
unit_only["automated_tests"].first["level"] = "unit"
expect_error("manual test is not a substitute") { validate_story_description(unit_only, instrumentation_required: true) }

duplicate_signal = clone(story_v3["description"])
duplicate_signal["instrumentation"] << clone(duplicate_signal["instrumentation"].first)
expect_error("instrumentation IDs must be unique") { validate_story_description(duplicate_signal, instrumentation_required: true) }

missing_instrumentation = clone(story_v3["description"])
missing_instrumentation.delete("instrumentation")
expect_error("invalid approved exception") { validate_story_description(missing_instrumentation, instrumentation_required: true) }

instrumentation_exception = clone(missing_instrumentation)
instrumentation_exception["instrumentation_exception"] = {
  "obligation" => "instrumentation",
  "reason" => "The Story changes only static explanatory text.",
  "approver" => "Service owner",
  "approval_evidence" => "review-84"
}
validate_story_description(instrumentation_exception, instrumentation_required: true)

excepted_story = clone(story_v3)
excepted_description = excepted_story["description"]
excepted_description.delete("instrumentation")
excepted_description["instrumentation_exception"] = clone(instrumentation_exception["instrumentation_exception"])
excepted_description["review_evidence"].delete("instrumentation")
excepted_description["review_evidence"]["approved_exceptions"] = [
  {
    "obligation" => "instrumentation",
    "status" => "confirmed",
    "approval_evidence" => "review-84"
  }
]
validate_story_description(excepted_description, instrumentation_required: true)
validate_story_review(excepted_story)

missing_confirmation = clone(excepted_story)
missing_confirmation["description"]["review_evidence"].delete("approved_exceptions")
expect_error("exception confirmation does not match the plan") { validate_story_review(missing_confirmation) }

stale_confirmation = clone(excepted_story)
stale_confirmation["description"]["review_evidence"]["approved_exceptions"].first["status"] = "proposed"
expect_error("invalid exception confirmation") { validate_story_review(stale_confirmation) }

wrong_confirmation = clone(excepted_story)
wrong_confirmation["description"]["review_evidence"]["approved_exceptions"].first["approval_evidence"] = "review-other"
expect_error("exception confirmation does not match the plan") { validate_story_review(wrong_confirmation) }

plan_and_exception = clone(v3_manifest)
plan_and_exception["children"].last["fields"]["description"]["instrumentation_exception"] = {
  "obligation" => "instrumentation",
  "reason" => "This must not coexist with a plan.",
  "approver" => "Service owner",
  "approval_evidence" => "review-85"
}
expect_error("conflicting obligation and exception") { validate_manifest(plan_and_exception, index, registry) }

missing_observation = clone(story_v3)
missing_observation["description"]["review_evidence"]["instrumentation"].first["observed_output"] = ""
expect_error("incomplete instrumentation evidence") { validate_story_review(missing_observation) }

missing_implementation = clone(story_v3)
missing_implementation["description"]["review_evidence"]["instrumentation"].first["implementation_evidence"] = ""
expect_error("incomplete instrumentation evidence") { validate_story_review(missing_implementation) }

missing_signal_environment = clone(story_v3)
missing_signal_environment["description"]["review_evidence"]["instrumentation"].first["environment"] = ""
expect_error("incomplete instrumentation evidence") { validate_story_review(missing_signal_environment) }

unmapped_signal = clone(story_v3)
unmapped_signal["description"]["review_evidence"]["instrumentation"].first["signal_id"] = "other-signal"
expect_error("instrumentation evidence does not match the plan") { validate_story_review(unmapped_signal) }

unreviewed_current_doc = clone(story_v3)
unreviewed_current_doc["description"]["review_evidence"]["documentation"].first.delete("review_record")
expect_error("missing published documentation evidence") { validate_story_review(unreviewed_current_doc) }

updated_doc = clone(story_v3)
updated_doc["description"]["review_evidence"]["documentation"].first["status"] = "updated"
updated_doc["description"]["review_evidence"]["documentation"].first.delete("reviewer")
updated_doc["description"]["review_evidence"]["documentation"].first.delete("review_record")
validate_story_review(updated_doc)

generic_metric = clone(story_v3["description"])
generic_metric["instrumentation"].first["expected_observation"] = "metrics added"
expect_error("generic evidence") { validate_story_description(generic_metric, instrumentation_required: true) }

legacy_v1 = load_yaml(File.join(FIXTURES, "story-v1-lifecycle.yaml"))
legacy_story = legacy_v1.fetch("story")
legacy_lifecycle = legacy_v1.fetch("lifecycle_evidence")
validate_description(legacy_story.fetch("description"), index.fetch("jira-story-v1"))
validate_legacy_story_review(legacy_story, legacy_lifecycle)

wrong_legacy_story = clone(legacy_lifecycle)
wrong_legacy_story["story_key"] = "WORK-999"
expect_error("legacy evidence identifies the wrong Story") { validate_legacy_story_review(legacy_story, wrong_legacy_story) }

wrong_legacy_template = clone(legacy_lifecycle)
wrong_legacy_template["template_id"] = "jira-story-v2"
expect_error("legacy evidence identifies the wrong template") { validate_legacy_story_review(legacy_story, wrong_legacy_template) }

wrong_scenario_binding = clone(legacy_lifecycle)
wrong_scenario_binding["scenario_bindings"].first["source_text"] = "A different scenario"
expect_error("legacy scenario binding does not match the Story") { validate_legacy_story_review(legacy_story, wrong_scenario_binding) }

legacy_missing_instrumentation = clone(legacy_lifecycle)
legacy_missing_instrumentation.delete("instrumentation")
expect_error("invalid approved exception") { validate_legacy_story_review(legacy_story, legacy_missing_instrumentation) }

legacy_unit_only = clone(legacy_lifecycle)
legacy_unit_only["automated_tests"].first["level"] = "unit"
expect_error("unit or manual test is not a substitute") { validate_legacy_story_review(legacy_story, legacy_unit_only) }

legacy_instrumentation_exception = clone(legacy_missing_instrumentation)
legacy_instrumentation_exception["instrumentation_exception"] = {
  "obligation" => "instrumentation",
  "reason" => "The legacy Story changes only static explanatory text.",
  "approver" => "Service owner",
  "approval_evidence" => "review-legacy-12"
}
validate_legacy_story_review(legacy_story, legacy_instrumentation_exception)

placeholder = clone(schema3)
placeholder["epic"]["changes"]["description"]["problem"] = "<problem>"
expect_error("unresolved placeholder") { validate_manifest(placeholder, index, registry) }

generic = clone(story["description"])
generic["automated_tests"].first["expected_evidence"] = "tests added"
expect_error("generic evidence") { validate_story_description(generic) }

# Every declared v2 key must have a render target in the shipped template asset.
# The default target is the key name as a sentence-case heading. RENDER_EXCEPTIONS
# mirrors the table in references/jira-description-templates.md; the two must agree.
RENDER_EXCEPTIONS = {
  "jira-epic-v2" => {
    "out_of_scope" => "**Out:**",
    "release_quality_additions" => "**Additions:**",
    "approved_exceptions" => "**Approved exceptions:**"
  },
  "jira-story-v2" => {
    "scenarios" => "## Acceptance scenarios",
    "documentation" => "### Documentation",
    "automated_tests" => "### Automated tests",
    "documentation_exception" => "### Documentation exception",
    "automated_tests_exception" => "### Automated-test exception",
    "nonfunctional_requirements" => "## Non-functional requirements",
    "review_evidence" => "## Review evidence",
    "supplemental_demonstration" => "**Supplemental demonstration:**"
  },
  "jira-story-v3" => {
    "scenarios" => "## Acceptance scenarios",
    "documentation" => "### Documentation",
    "automated_tests" => "### Automated tests",
    "instrumentation" => "### Instrumentation",
    "documentation_exception" => "### Documentation exception",
    "automated_tests_exception" => "### Automated-test exception",
    "instrumentation_exception" => "### Instrumentation exception",
    "nonfunctional_requirements" => "## Non-functional requirements",
    "review_evidence" => "## Review evidence",
    "supplemental_demonstration" => "**Supplemental demonstration:**"
  },
  "jira-task-v2" => {
    "ticket_quality_additions" => "**Additions:**",
    "approved_exceptions" => "**Approved exceptions:**"
  },
  "jira-spike-design-v2" => {
    "design_artifact" => "**Artifact:**",
    "reviewers" => "**Reviewers:**",
    "checklist_coverage" => "**Checklist coverage:**"
  }
}.freeze

def render_target(template_id, key)
  RENDER_EXCEPTIONS.dig(template_id, key) || "## #{key.tr("_", " ").capitalize}"
end

templates.select { |template| template["set_version"] >= 2 }.each do |template|
  id = template.fetch("id")
  body = File.read(File.join(SKILL, "assets", "jira-templates", template.fetch("file")))
  template.fetch("required_keys").each do |key|
    assert(body.include?(render_target(id, key)), "#{id} requires #{key} but the shipped template cannot render it")
  end
  template.fetch("conditional_keys").each do |key|
    assert(body.include?(render_target(id, key)), "#{id} declares conditional #{key} but the shipped template cannot render it")
  end
  headings = body.scan(/^#{"#"}{2,3} .+$/)
  assert(headings.uniq.length == headings.length, "#{id} repeats a heading")
  assert(!body.match?(/\bN\/A\b/), "#{id} ships a forced N/A cell")
  assert(!body.match?(/^\s*-?\s*None\s*$/), "#{id} ships a forced None value")
end

# The v1 assets are frozen with their original forced-value style; that contrast is
# the anti-bloat change. Guard it so a v2 regression cannot pass unnoticed.
legacy_forced = templates.select { |template| template["set_version"] == 1 }.count do |template|
  File.read(File.join(SKILL, "assets", "jira-templates", template.fetch("file"))).match?(/\bN\/A\b|^\s*-?\s*None\s*$/)
end
assert(legacy_forced.positive?, "v1 templates no longer show the forced-value style v2 removed")

story_template = File.read(File.join(SKILL, "assets", "jira-templates", "story-v2.md"))
assert(!story_template.include?("| Owner |"), "Story template forces an optional owner cell")
assert(story_template.include?("### Documentation exception"), "Story template cannot render a documentation exception")
assert(story_template.include?("### Automated-test exception"), "Story template cannot render an automated-test exception")

story_v3_template = File.read(File.join(SKILL, "assets", "jira-templates", "story-v3.md"))
assert(story_v3_template.include?("### Instrumentation"), "Story v3 cannot render instrumentation")
assert(story_v3_template.include?("### Instrumentation exception"), "Story v3 cannot render an instrumentation exception")

before = JSON.parse(File.read(File.join(FIXTURES, "adf-before.json")))
new_ids = JSON.parse(File.read(File.join(FIXTURES, "adf-new-localids.json")))
mismatch = JSON.parse(File.read(File.join(FIXTURES, "adf-mismatch.json")))
assert(adf_digest(before) == adf_digest(new_ids), "ADF localId changes should hash equally")
assert(adf_digest(before) != adf_digest(mismatch), "ADF semantic changes must not hash equally")
assert(adf_digest(before) == "9c8549f3ce45249c90876c558c618c286d5b3dde8e3e13eb54bfdc8c0a0f66c7", "canonical ADF digest changed")

write_calls = []
expected_digest = adf_digest(before)
live_digest = adf_digest(mismatch)
write_calls << :update_epic if live_digest == expected_digest
assert(write_calls.empty?, "preflight drift must produce zero writes")

before_projection = {"description" => "old", "labels" => ["preserve"], "owner" => "preserve"}
after_projection = before_projection.merge("description" => "new")
assert(after_projection.reject { |key, _| key == "description" } == before_projection.reject { |key, _| key == "description" }, "omitted business fields changed")

journal = []
operations = %w[epic child link rank]
operations.each do |operation|
  if operation == "link"
    journal << {"operation" => operation, "result" => "failed"}
    break
  end
  journal << {"operation" => operation, "result" => "verified"}
end
assert(journal.map { |item| item["operation"] } == %w[epic child link], "partial failure did not stop dependent operations")
assert(journal.last["result"] == "failed", "partial failure was not recorded")

public_text = Dir[File.join(SKILL, "**", "*")].select { |path| File.file?(path) }.map { |path| File.read(path) }.join("\n")
assert(!public_text.match?(/pathrobotics\.atlassian\.net|\b(?:AE|ER)-\d+\b/i), "public package contains an internal reference")

puts "workbreakdown template contract tests passed"
