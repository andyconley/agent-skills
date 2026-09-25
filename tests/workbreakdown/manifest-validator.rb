# frozen_string_literal: true

# Reference validator for the workbreakdown manifest contract. The contract test
# and the private release check both load it, so there is one implementation.

require "date"
require "digest"
require "json"
require "yaml"

# Repository text is UTF-8. Declare it so File.read does not inherit a
# US-ASCII default from a C or POSIX locale and reject valid content.
Encoding.default_external = Encoding::UTF_8

ROOT = File.expand_path("../..", __dir__)
SKILL = File.join(ROOT, "skills", "workbreakdown")
REGISTRY_PATH = File.join(SKILL, "assets", "jira-templates", "registry.yaml")

ROOT_KEYS = %w[schema_version manifest_id revision template_set scope epic children dependencies rank unknowns].freeze
CHILD_KEYS = %w[ref jira_key type variant template_id template_sha256 disposition verify changes fields].freeze
PAYLOAD_KEYS = %w[summary done_when evidence estimate description].freeze
SCHEMA4_ROOT_KEYS = %w[shaping sources consolidation].freeze
SHAPING_VALUES = {
  "spike_shape" => %w[vertical-slice by-layer],
  "task_granularity" => %w[per-flow finer],
  "reviewers" => :list,
  "source_order" => :list
}.freeze
SOURCES_READ = %w[description amendments status links link_history].freeze
SHAPING_SOURCES = %w[asked reused default].freeze
JIRA_CONTEXTS = %w[present absent].freeze
SOURCES_KEYS = %w[jira_context existing_children conflicts].freeze
CLASSIFICATION_KEYS = %w[question precedent placeholder].freeze
CONSOLIDATION_KEYS = %w[status claims order exceptions].freeze
# Audit's semantic link findings. Link checks name an edge; the others name one ticket.
EDGE_CHECKS = %w[contradicts-text into-closed later-to-earlier].freeze
REF_CHECKS = %w[text-only-blocker status-vs-blockers].freeze
AUDIT_CHECKS = (EDGE_CHECKS + REF_CHECKS).freeze
CONSOLIDATION_STATUSES = %w[run skipped no-siblings].freeze
ORDER_SOURCES = %w[declared rank unknown].freeze
CONFIRMATION_STATES = %w[proposed confirmed].freeze
PRECEDENT_VERDICTS = %w[none found unverified].freeze
JIRA_KEY = /\A[A-Z][A-Z0-9]+-\d+\z/.freeze
CLASSIFIED_SPIKE_TEMPLATES = %w[jira-spike-design-v3 jira-spike-investigation-v3].freeze
PLACEHOLDER_TEMPLATE = "jira-task-placeholder-v3"
PLACEHOLDER_PREFIX = "[PLACEHOLDER] "
# Review output categories. Review and Audit never flag a team's own Spike shape or Task granularity,
# so no category exists for either.
FINDING_CATEGORIES = %w[
  wrong-type misclassified-spike component-story unverifiable-completion missing-implementation
  missing-story-evidence missing-review-evidence content-quality too-broad unsupported-assumption
  stale-source invalid-manifest dependency
].freeze

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
  raise ArgumentError, "default template set must be 4" unless registry["default_set_version"] == 4
  sets = registry.fetch("template_sets")
  raise ArgumentError, "missing template set 1" unless sets.key?(1)
  raise ArgumentError, "missing template set 2" unless sets.key?(2)
  raise ArgumentError, "missing template set 3" unless sets.key?(3)
  raise ArgumentError, "missing template set 4" unless sets.key?(4)

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
        raise ArgumentError, "default variant mismatch" if variant && template["variant"] != variant
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
    raise ArgumentError, "unresolved template token" if value.match?(/<[^>]+>/)
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
  # A precedent verdict is an enumerated value checked by validate_precedent. Its `none`
  # is a finding, not filler, so only that one field skips the free-text quality check.
  if description["precedent"].is_a?(Hash)
    description = description.merge("precedent" => description["precedent"].reject { |key, _| key == "verdict" })
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

def nonempty_string_list?(value)
  value.is_a?(Array) && !value.empty? && value.all? { |item| item.is_a?(String) && !item.strip.empty? }
end

def iso_date?(value)
  value.is_a?(String) && value.match?(/\A\d{4}-\d{2}-\d{2}\z/) && Date.iso8601(value)
rescue ArgumentError
  false
end

def validate_shaping(shaping)
  raise ArgumentError, "shaping must be a map" unless shaping.is_a?(Hash)
  reject_unknown_keys(shaping, SHAPING_VALUES.keys, "shaping")
  shaping.each do |name, answer|
    raise ArgumentError, "shaping #{name} must be a map" unless answer.is_a?(Hash)
    reject_unknown_keys(answer, %w[value source from_epic], "shaping #{name}")
    raise ArgumentError, "invalid shaping source" unless SHAPING_SOURCES.include?(answer["source"])
    raise ArgumentError, "reviewers cannot come from a default" if name == "reviewers" && answer["source"] == "default"
    if answer["source"] == "reused"
      raise ArgumentError, "reused shaping answer requires from_epic" if answer["from_epic"].to_s.strip.empty?
      raise ArgumentError, "from_epic must be a Jira key" unless answer["from_epic"].to_s.match?(JIRA_KEY)
    elsif answer.key?("from_epic")
      raise ArgumentError, "from_epic is only allowed on reused answers"
    end
    allowed = SHAPING_VALUES.fetch(name)
    if allowed == :list
      raise ArgumentError, "shaping #{name} value must be a list of names" unless nonempty_string_list?(answer["value"])
    else
      raise ArgumentError, "invalid #{name} value" unless allowed.include?(answer["value"])
    end
  end
end

def validate_sources(sources)
  raise ArgumentError, "sources must be a map" unless sources.is_a?(Hash)
  reject_unknown_keys(sources, SOURCES_KEYS, "sources")
  context = sources["jira_context"]
  raise ArgumentError, "invalid jira_context" unless context.nil? || JIRA_CONTEXTS.include?(context)

  existing = sources.fetch("existing_children", [])
  raise ArgumentError, "existing_children must be a list" unless existing.is_a?(Array)
  raise ArgumentError, "existing_children requires Jira context" if context == "absent" && !existing.empty?
  existing.each do |item|
    raise ArgumentError, "existing_children entry must be a map" unless item.is_a?(Hash)
    reject_unknown_keys(item, %w[jira_key read], "existing_children entry")
    raise ArgumentError, "existing_children entry requires a Jira key" unless item["jira_key"].to_s.match?(JIRA_KEY)
    read = item["read"]
    raise ArgumentError, "invalid existing_children read" unless read.is_a?(Array) && !read.empty? && (read - SOURCES_READ).empty? && read.uniq.length == read.length
  end

  conflicts = sources.fetch("conflicts", [])
  raise ArgumentError, "conflicts must be a list" unless conflicts.is_a?(Array)
  conflicts.each do |conflict|
    raise ArgumentError, "conflict must be a map" unless conflict.is_a?(Hash)
    reject_unknown_keys(conflict, %w[claim sources winner material stale], "conflict")
    raise ArgumentError, "conflict requires a claim" unless conflict["claim"].is_a?(String) && !conflict["claim"].strip.empty?
    listed = conflict["sources"]
    raise ArgumentError, "conflict requires at least two sources" unless listed.is_a?(Array) && listed.length >= 2
    listed.each do |source|
      raise ArgumentError, "conflict source must be a map" unless source.is_a?(Hash)
      reject_unknown_keys(source, %w[ref date], "conflict source")
      raise ArgumentError, "conflict source requires a ref" if source["ref"].to_s.strip.empty?
      raise ArgumentError, "conflict source date must be a valid YYYY-MM-DD date" unless iso_date?(source["date"])
    end
    raise ArgumentError, "conflict sources must be distinct" unless listed.map { |source| source["ref"].to_s.strip }.uniq.length == listed.length
    raise ArgumentError, "conflict winner is not a listed source" unless listed.map { |source| source["ref"] }.include?(conflict["winner"])
    %w[material stale].each do |flag|
      raise ArgumentError, "conflict #{flag} must be true or false" unless [true, false].include?(conflict[flag])
    end
  end
end

def nonempty_text?(value)
  value.is_a?(String) && !value.strip.empty?
end

def validate_claim(claim)
  raise ArgumentError, "consolidation claim must be a map" unless claim.is_a?(Hash)
  reject_unknown_keys(claim, %w[claim claimed_by owner rationale confirmation], "consolidation claim")
  raise ArgumentError, "claim requires a claim" unless nonempty_text?(claim["claim"])
  raise ArgumentError, "claim requires a rationale" unless nonempty_text?(claim["rationale"])
  claimants = claim["claimed_by"]
  unless claimants.is_a?(Array) && claimants.length >= 2 && claimants.all? { |key| key.to_s.match?(JIRA_KEY) } && claimants.uniq.length == claimants.length
    raise ArgumentError, "claimed_by must list at least two distinct Jira keys"
  end
  raise ArgumentError, "claim owner is not a claimant" unless claimants.include?(claim["owner"])
  confirmation = claim["confirmation"]
  raise ArgumentError, "claim confirmation must be a map" unless confirmation.is_a?(Hash)
  reject_unknown_keys(confirmation, %w[state confirmed_by evidence], "claim confirmation")
  raise ArgumentError, "invalid confirmation state" unless CONFIRMATION_STATES.include?(confirmation["state"])
  if confirmation["state"] == "confirmed"
    raise ArgumentError, "confirmed owner requires confirmed_by and evidence" unless nonempty_text?(confirmation["confirmed_by"]) && nonempty_text?(confirmation["evidence"])
  elsif confirmation.key?("confirmed_by") || confirmation.key?("evidence")
    raise ArgumentError, "proposed owner forbids confirmed_by and evidence"
  end
end

def validate_order(order, epic_key)
  raise ArgumentError, "consolidation order must be a map" unless order.is_a?(Hash)
  reject_unknown_keys(order, %w[source value], "consolidation order")
  raise ArgumentError, "invalid order source" unless ORDER_SOURCES.include?(order["source"])
  value = order.fetch("value", [])
  raise ArgumentError, "order value must be a list of Jira keys" unless value.is_a?(Array) && value.all? { |key| key.to_s.match?(JIRA_KEY) }
  raise ArgumentError, "order keys must be unique" unless value.uniq.length == value.length
  raise ArgumentError, "order value must be empty exactly when source is unknown" unless value.empty? == (order["source"] == "unknown")
  return if value.empty?

  raise ArgumentError, "known order must include the scoped Epic" unless value.include?(epic_key)
end

# An order exception excuses exactly one later-to-earlier edge between two milestone Epics.
# It annotates the edge and never adds, removes or reverses a Blocks link.
def dependency_end(value)
  value.is_a?(Hash) ? (value["ref"] || value["jira_key"]).to_s : ""
end

def validate_order_exception(exception, order_value, epic_key, children, dependencies)
  refs = children.map { |child| child["ref"] }
  raise ArgumentError, "order exception must be a map" unless exception.is_a?(Hash)
  reject_unknown_keys(exception, %w[blocker blocked blocker_epic blocked_epic reason approver approval_evidence], "order exception")
  %w[blocker blocked].each do |end_name|
    endpoint = exception[end_name].to_s
    raise ArgumentError, "order exception #{end_name} must be a Jira key or a child ref" unless endpoint.match?(JIRA_KEY) || refs.include?(endpoint)
  end
  raise ArgumentError, "order exception blocker and blocked must differ" if exception["blocker"] == exception["blocked"]
  raise ArgumentError, "order exception requires a known order" if order_value.empty?
  positions = %w[blocker_epic blocked_epic].map do |end_name|
    order_value.index(exception[end_name]) or raise ArgumentError, "order exception endpoint is not in the order"
  end
  raise ArgumentError, "order exception edge is not later-to-earlier" unless positions[0] > positions[1]
  # A child ref names a child of the scoped Epic, and a proposed child has no live links:
  # its edge exists only when dependencies ensures it.
  %w[blocker blocked].each do |end_name|
    next unless refs.include?(exception[end_name])

    raise ArgumentError, "order exception #{end_name} is a child of the scoped Epic" unless exception["#{end_name}_epic"] == epic_key
  end
  proposed = children.select { |child| child["disposition"] == "proposed" }.map { |child| child["ref"] }
  if (proposed & [exception["blocker"], exception["blocked"]]).any?
    ensured = Array(dependencies).any? do |entry|
      entry.is_a?(Hash) && entry["action"] == "ensure" &&
        dependency_end(entry["blocker"]) == exception["blocker"] && dependency_end(entry["blocked"]) == exception["blocked"]
    end
    raise ArgumentError, "order exception on a proposed child needs an ensure dependency" unless ensured
  end
  unless %w[reason approver approval_evidence].all? { |field| nonempty_text?(exception[field]) }
    raise ArgumentError, "order exception requires reason, approver, and approval_evidence"
  end
end

def validate_consolidation(consolidation, epic_key, children, dependencies)
  raise ArgumentError, "consolidation must be a map" unless consolidation.is_a?(Hash)
  reject_unknown_keys(consolidation, CONSOLIDATION_KEYS, "consolidation")
  raise ArgumentError, "consolidation requires a status" unless consolidation.key?("status")
  status = consolidation["status"]
  raise ArgumentError, "invalid consolidation status" unless CONSOLIDATION_STATUSES.include?(status)
  claims = consolidation.fetch("claims", [])
  exceptions = consolidation.fetch("exceptions", [])
  raise ArgumentError, "consolidation claims must be a list" unless claims.is_a?(Array)
  raise ArgumentError, "consolidation exceptions must be a list" unless exceptions.is_a?(Array)
  order = consolidation["order"]
  validate_order(order, epic_key) unless order.nil?
  if status != "run"
    raise ArgumentError, "consolidation #{status} forbids claims" unless claims.empty?
    raise ArgumentError, "consolidation #{status} forbids exceptions" unless exceptions.empty?
    raise ArgumentError, "#{status} consolidation order must be unknown" unless order.nil? || (order.is_a?(Hash) && order["source"] == "unknown")
  end
  claims.each { |claim| validate_claim(claim) }
  raise ArgumentError, "consolidation claims must be distinct" unless claims.map { |claim| claim["claim"].strip }.uniq.length == claims.length
  order_value = order.nil? ? [] : order.fetch("value", [])
  exceptions.each { |exception| validate_order_exception(exception, order_value, epic_key, children, dependencies) }
  edges = exceptions.map { |exception| [exception["blocker"], exception["blocked"]] }
  raise ArgumentError, "order exceptions must be distinct" unless edges.uniq.length == edges.length
end

def validate_precedent(precedent)
  raise ArgumentError, "precedent must be a map" unless precedent.is_a?(Hash)
  reject_unknown_keys(precedent, %w[searched verdict location], "precedent")
  raise ArgumentError, "precedent searched must list locations" unless nonempty_string_list?(precedent["searched"])
  raise ArgumentError, "invalid precedent verdict" unless PRECEDENT_VERDICTS.include?(precedent["verdict"])
  if precedent["verdict"] == "found"
    raise ArgumentError, "found precedent requires location" if precedent["location"].to_s.strip.empty?
  end
end

# A v3 Spike states its question and precedent in the description in every schema.
# Schema 4 also records them as classification, and the two must agree.
def validate_classified_spike(child, payload, schema)
  description = payload["description"]
  if description
    raise ArgumentError, "Spike question must be text" unless description["question"].is_a?(String) && !description["question"].strip.empty?
    validate_precedent(description["precedent"])
    if description.key?("reviewers")
      raise ArgumentError, "Spike reviewers must name people" unless nonempty_string_list?(description["reviewers"])
    end
  end
  return unless schema == 4

  # validate_child already requires classification question and precedent on every schema-4 Spike.
  classification = child["classification"]
  return unless description

  raise ArgumentError, "Spike description question must match classification" unless description["question"] == classification["question"]
  raise ArgumentError, "Spike description precedent must match classification" unless description["precedent"] == classification["precedent"]
end

def validate_review_findings(findings)
  raise ArgumentError, "findings must be a list" unless findings.is_a?(Array)
  findings.each do |finding|
    raise ArgumentError, "finding must be a map" unless finding.is_a?(Hash)
    reject_unknown_keys(finding, %w[category ref correction], "finding")
    raise ArgumentError, "invalid finding category" unless FINDING_CATEGORIES.include?(finding["category"])
    raise ArgumentError, "finding requires a ref" unless finding["ref"].is_a?(String) && !finding["ref"].strip.empty?
    raise ArgumentError, "finding requires a correction" unless finding["correction"].is_a?(String) && !finding["correction"].strip.empty?
  end
end

def validate_audit_findings(findings)
  raise ArgumentError, "audit findings must be a list" unless findings.is_a?(Array)
  findings.each do |finding|
    raise ArgumentError, "audit finding must be a map" unless finding.is_a?(Hash)
    reject_unknown_keys(finding, %w[check edge ref evidence], "audit finding")
    check = finding["check"]
    raise ArgumentError, "invalid audit check" unless AUDIT_CHECKS.include?(check)
    raise ArgumentError, "audit finding takes an edge or a ref, not both" if finding.key?("edge") && finding.key?("ref")
    if EDGE_CHECKS.include?(check)
      edge = finding["edge"]
      raise ArgumentError, "#{check} finding requires an edge" unless edge.is_a?(Hash)
      reject_unknown_keys(edge, %w[blocker blocked], "audit finding edge")
      raise ArgumentError, "edge requires blocker and blocked Jira keys" unless %w[blocker blocked].all? { |end_name| edge[end_name].to_s.match?(JIRA_KEY) }
      raise ArgumentError, "edge blocker and blocked must differ" if edge["blocker"] == edge["blocked"]
    else
      raise ArgumentError, "#{check} finding requires a ref" unless finding["ref"].to_s.match?(JIRA_KEY)
    end
    raise ArgumentError, "audit finding requires evidence" unless nonempty_text?(finding["evidence"])
  end
end

def validate_classification(classification, child)
  raise ArgumentError, "classification must be a map" unless classification.is_a?(Hash)
  reject_unknown_keys(classification, CLASSIFICATION_KEYS, "classification")
  if classification.key?("question")
    raise ArgumentError, "classification question must be text" unless classification["question"].is_a?(String) && !classification["question"].strip.empty?
  end
  validate_precedent(classification["precedent"]) if classification.key?("precedent")
  if classification.key?("placeholder")
    raise ArgumentError, "placeholder is only allowed on a Task" unless child["type"] == "Task"
    placeholder = classification["placeholder"]
    raise ArgumentError, "placeholder must be a map" unless placeholder.is_a?(Hash)
    reject_unknown_keys(placeholder, %w[defined_by], "placeholder")
  end
end

def placeholder_definers(child)
  definers = []
  definers << child.dig("classification", "placeholder", "defined_by") unless child.dig("classification", "placeholder").nil?
  if child["template_id"] == PLACEHOLDER_TEMPLATE
    description = %w[verify changes fields].map { |key| child.dig(key, "description") }.compact.first
    definers << description["defined_by"] if description
  end
  definers
end

def validate_placeholder_definers(children)
  spikes = children.select { |child| child["type"] == "Spike" }.map { |child| child["ref"] }
  children.each do |child|
    placeholder_definers(child).each do |defined_by|
      next if spikes.include?(defined_by) || defined_by.to_s.match?(JIRA_KEY)
      raise ArgumentError, "placeholder defined_by must name a Spike ref or a Jira key"
    end
  end
end

# A placeholder Task holds undesigned work. Only jira-task-placeholder-v3 may carry the
# prefix or classification.placeholder, and that template requires both.
def validate_placeholder_task(child, payload, template_id, schema)
  placeholder_template = template_id == PLACEHOLDER_TEMPLATE
  prefixed = payload["summary"].to_s.start_with?(PLACEHOLDER_PREFIX)
  classified = !child.dig("classification", "placeholder").nil?
  # A verified card keeps its live summary, which may already carry the prefix.
  sets_summary = %w[update proposed].include?(child["disposition"])
  raise ArgumentError, "placeholder prefix requires jira-task-placeholder-v3" if prefixed && !placeholder_template && sets_summary
  raise ArgumentError, "classification placeholder requires jira-task-placeholder-v3" if classified && !placeholder_template
  return unless placeholder_template

  raise ArgumentError, "placeholder Task summary requires the [PLACEHOLDER] prefix" unless prefixed
  raise ArgumentError, "placeholder Task carries no estimate" if payload.key?("estimate")
  return unless schema == 4

  raise ArgumentError, "placeholder Task requires classification placeholder" unless classified
  description = payload["description"]
  return unless description

  raise ArgumentError, "placeholder description defined_by must match classification" unless description["defined_by"] == child.dig("classification", "placeholder", "defined_by")
end

def validate_child(child, templates, set_version, schema)
  if schema == 4 && child["type"] == "Spike"
    classification = child["classification"].is_a?(Hash) ? child["classification"] : {}
    raise ArgumentError, "schema-4 Spike requires classification question and precedent" unless classification.key?("question") && classification.key?("precedent")
  end
  if child.key?("classification")
    raise ArgumentError, "classification requires schema 4" unless schema == 4
    raise ArgumentError, "unsupported child type" unless %w[Spike Task Story].include?(child["type"])
    validate_classification(child["classification"], child)
  end
  reject_unknown_keys(child, schema == 4 ? CHILD_KEYS + %w[classification] : CHILD_KEYS, "child")
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
  validate_placeholder_task(child, payload, template_id, schema)
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
  validate_classified_spike(child, payload, schema) if CLASSIFIED_SPIKE_TEMPLATES.include?(template_id)
end

def validate_manifest(manifest, templates, registry)
  # Keep the schema-2/3 check order: unknown root fields first, then the schema version.
  declared = manifest["schema_version"]
  if [2, 3].include?(declared)
    SCHEMA4_ROOT_KEYS.each { |key| raise ArgumentError, "#{key} requires schema 4" if manifest.key?(key) }
  end
  reject_unknown_keys(manifest, declared == 4 ? ROOT_KEYS + SCHEMA4_ROOT_KEYS : ROOT_KEYS, "manifest")
  schema = manifest.fetch("schema_version")
  raise ArgumentError, "unsupported schema" unless [2, 3, 4].include?(schema)
  reject_unknown_keys(manifest.fetch("template_set"), %w[id version], "template_set")
  raise ArgumentError, "wrong registry" unless manifest.dig("template_set", "id") == "jira-house-templates"
  set_version = manifest.dig("template_set", "version")
  raise ArgumentError, "unknown template-set version" unless registry.fetch("template_sets").key?(set_version)
  reject_unknown_keys(manifest.fetch("scope"), %w[parent_key epic_key], "scope")

  epic = manifest.fetch("epic")
  if schema == 2
    reject_unknown_keys(epic, %w[outcome target_duration], "schema-2 Epic")
  else
    # Schema 4 keeps the schema-3 Epic rules. Either schema binds any non-legacy Epic template
    # the selected set supports; for sets 2 and 3 that is exactly jira-epic-v2.
    epic_templates = templates.values.select do |candidate|
      candidate["issue_type"] == "Epic" && candidate["variant"] != "legacy" && template_supports_set?(candidate, set_version)
    end
    raise ArgumentError, "schema #{schema} requires an Epic-compatible template set" if epic_templates.empty?
    disposition = epic["disposition"]
    raise ArgumentError, "missing Epic disposition" unless %w[existing update unbound].include?(disposition)
    if disposition == "unbound"
      # A live Epic whose description fits no template: schema 4 binds only its digest and never writes it.
      raise ArgumentError, "unbound Epic requires schema 4" unless schema == 4
      reject_unknown_keys(epic, %w[disposition observed], "unbound Epic")
      observed = epic.fetch("observed")
      reject_unknown_keys(observed, %w[description_adf_sha256], "Epic observed")
      raise ArgumentError, "missing current ADF digest" unless observed["description_adf_sha256"]&.match?(/\A[0-9a-f]{64}\z/)
    elsif disposition == "existing"
      reject_unknown_keys(epic, %w[disposition verify], "existing Epic")
      verify = epic.fetch("verify")
      reject_unknown_keys(verify, %w[template_id template_sha256 description_adf_sha256 description], "Epic verify")
      template = templates[verify["template_id"]]
      raise ArgumentError, "invalid Epic template" unless epic_templates.include?(template)
      raise ArgumentError, "Epic template hash mismatch" unless verify["template_sha256"] == template["sha256"]
      digest = verify["description_adf_sha256"]
      raise ArgumentError, "missing current ADF digest" unless digest&.match?(/\A[0-9a-f]{64}\z/)
      validate_epic_description(verify.fetch("description"), template)
      validate_breakdown_conventions(verify.fetch("description"), manifest, schema, false)
    else
      reject_unknown_keys(epic, %w[disposition template_id template_sha256 expected_current changes], "update Epic")
      template = templates[epic["template_id"]]
      raise ArgumentError, "invalid Epic template" unless epic_templates.include?(template)
      raise ArgumentError, "Epic template hash mismatch" unless epic["template_sha256"] == template["sha256"]
      expected = epic.fetch("expected_current")
      reject_unknown_keys(expected, %w[description_adf_sha256], "expected_current")
      digest = expected["description_adf_sha256"]
      raise ArgumentError, "missing current ADF digest" unless digest&.match?(/\A[0-9a-f]{64}\z/)
      changes = epic.fetch("changes")
      raise ArgumentError, "forbidden Epic field" unless changes.keys == ["description"]
      validate_epic_description(changes.fetch("description"), template)
      validate_breakdown_conventions(changes.fetch("description"), manifest, schema, true)
    end
  end

  children = manifest.fetch("children")
  refs = children.map { |child| child["ref"] }
  raise ArgumentError, "child refs must be unique and nonempty" if refs.any? { |ref| ref.to_s.empty? } || refs.uniq.length != refs.length
  children.each { |child| validate_child(child, templates, set_version, schema) }
  validate_placeholder_definers(children)
  return unless schema == 4

  validate_shaping(manifest["shaping"]) if manifest.key?("shaping")
  if manifest.key?("sources")
    validate_sources(manifest["sources"])
    # Schema 4 always binds a live Epic digest. Without Jira context, Draft falls back to schema 2.
    raise ArgumentError, "schema 4 requires Jira context" if manifest.dig("sources", "jira_context") == "absent"
  end
  validate_consolidation(manifest["consolidation"], manifest.dig("scope", "epic_key"), children, manifest["dependencies"]) if manifest.key?("consolidation")
end

# The Epic's Breakdown conventions panel records the shaping answers. It exists only in
# schema 4, and an update writes exactly the manifest's shaping block.
def validate_breakdown_conventions(description, manifest, schema, update)
  return unless description.key?("breakdown_conventions")
  raise ArgumentError, "breakdown_conventions requires schema 4" unless schema == 4
  validate_shaping(description["breakdown_conventions"])
  return unless update

  raise ArgumentError, "breakdown_conventions must equal shaping" unless description["breakdown_conventions"] == manifest["shaping"]
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
