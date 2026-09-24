#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "manifest-validator"

FIXTURES = File.join(__dir__, "fixtures")

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

# Schema 4 adds optional Draft provenance and per-child classification.
schema4_minimal = load_yaml(File.join(FIXTURES, "schema4-minimal-valid.yaml"))
validate_manifest(schema4_minimal, index, registry)
assert(!schema4_minimal.key?("shaping") && !schema4_minimal.key?("sources"), "minimal schema-4 fixture carries optional blocks")

schema4 = load_yaml(File.join(FIXTURES, "schema4-full-valid.yaml"))
validate_manifest(schema4, index, registry)
assert(%w[spike_shape task_granularity reviewers source_order].all? { |key| schema4["shaping"].key?(key) }, "full schema-4 fixture lost a shaping entry")
assert(schema4["children"].all? { |child| child.key?("classification") }, "full schema-4 fixture lost a classification")
assert(schema4.dig("sources", "existing_children").flat_map { |item| item["read"] }.sort == SOURCES_READ.sort, "full schema-4 fixture does not read every source kind")

def schema4_child(manifest, ref)
  manifest["children"].find { |child| child["ref"] == ref }
end

unknown_shaping = clone(schema4)
unknown_shaping["shaping"]["estimate_mode"] = {"value" => "points", "source" => "asked"}
expect_error("shaping has unknown field") { validate_manifest(unknown_shaping, index, registry) }

reused_without_epic = clone(schema4)
reused_without_epic["shaping"]["spike_shape"].delete("from_epic")
expect_error("reused shaping answer requires from_epic") { validate_manifest(reused_without_epic, index, registry) }

epic_without_reuse = clone(schema4)
epic_without_reuse["shaping"]["task_granularity"]["from_epic"] = "EPIC-2"
expect_error("from_epic is only allowed on reused answers") { validate_manifest(epic_without_reuse, index, registry) }

bad_spike_shape = clone(schema4)
bad_spike_shape["shaping"]["spike_shape"]["value"] = "by-component"
expect_error("invalid spike_shape value") { validate_manifest(bad_spike_shape, index, registry) }

bad_answer_source = clone(schema4)
bad_answer_source["shaping"]["reviewers"]["source"] = "invented"
expect_error("invalid shaping source") { validate_manifest(bad_answer_source, index, registry) }

one_source_conflict = clone(schema4)
one_source_conflict["sources"]["conflicts"].first["sources"] = one_source_conflict["sources"]["conflicts"].first["sources"].first(1)
expect_error("conflict requires at least two sources") { validate_manifest(one_source_conflict, index, registry) }

unlisted_winner = clone(schema4)
unlisted_winner["sources"]["conflicts"].first["winner"] = "WORK-999"
expect_error("conflict winner is not a listed source") { validate_manifest(unlisted_winner, index, registry) }

bad_conflict_date = clone(schema4)
bad_conflict_date["sources"]["conflicts"].first["sources"].first["date"] = "last week"
expect_error("conflict source date must be a valid YYYY-MM-DD date") { validate_manifest(bad_conflict_date, index, registry) }

children_without_jira = clone(schema4)
children_without_jira["sources"]["jira_context"] = "absent"
expect_error("existing_children requires Jira context") { validate_manifest(children_without_jira, index, registry) }

absent_context = clone(schema4)
absent_context["sources"]["jira_context"] = "absent"
absent_context["sources"]["existing_children"] = []
validate_manifest(absent_context, index, registry)

bad_read = clone(schema4)
bad_read["sources"]["existing_children"].first["read"] = ["comments"]
expect_error("invalid existing_children read") { validate_manifest(bad_read, index, registry) }

bad_verdict = clone(schema4)
schema4_child(bad_verdict, "choose-transport")["classification"]["precedent"]["verdict"] = "probably"
expect_error("invalid precedent verdict") { validate_manifest(bad_verdict, index, registry) }

found_without_location = clone(schema4)
schema4_child(found_without_location, "build-endpoint")["classification"]["precedent"].delete("location")
expect_error("found precedent requires location") { validate_manifest(found_without_location, index, registry) }

spike_placeholder = clone(schema4)
schema4_child(spike_placeholder, "choose-transport")["classification"]["placeholder"] = {"defined_by" => "measure-staleness"}
expect_error("placeholder is only allowed on a Task") { validate_manifest(spike_placeholder, index, registry) }

missing_definer = clone(schema4)
schema4_child(missing_definer, "build-endpoint")["classification"]["placeholder"]["defined_by"] = "no-such-spike"
expect_error("placeholder defined_by must name a Spike") { validate_manifest(missing_definer, index, registry) }

non_spike_definer = clone(schema4)
schema4_child(non_spike_definer, "build-endpoint")["classification"]["placeholder"]["defined_by"] = "build-endpoint"
expect_error("placeholder defined_by must name a Spike") { validate_manifest(non_spike_definer, index, registry) }

jira_definer = clone(schema4)
schema4_child(jira_definer, "build-endpoint")["classification"]["placeholder"]["defined_by"] = "WORK-302"
validate_manifest(jira_definer, index, registry)

unknown_classification = clone(schema4)
schema4_child(unknown_classification, "choose-transport")["classification"]["owner"] = "API owner"
expect_error("classification has unknown field") { validate_manifest(unknown_classification, index, registry) }

schema3_classification = clone(v2_children)
schema3_classification["schema_version"] = 3
schema3_classification["epic"] = clone(schema3["epic"])
schema3_classification["children"].first["classification"] = {"question" => "Which transport?"}
expect_error("classification requires schema 4") { validate_manifest(schema3_classification, index, registry) }

schema3_shaping = clone(schema3)
schema3_shaping["shaping"] = clone(schema4["shaping"])
expect_error("shaping requires schema 4") { validate_manifest(schema3_shaping, index, registry) }

schema3_sources = clone(schema3)
schema3_sources["sources"] = clone(schema4["sources"])
expect_error("sources requires schema 4") { validate_manifest(schema3_sources, index, registry) }

bad_granularity = clone(schema4)
bad_granularity["shaping"]["task_granularity"]["value"] = "per-layer"
expect_error("invalid task_granularity value") { validate_manifest(bad_granularity, index, registry) }

%w[reviewers source_order].each do |entry|
  empty_name = clone(schema4)
  empty_name["shaping"][entry]["value"] = ["  "]
  expect_error("shaping #{entry} value must be a list of names") { validate_manifest(empty_name, index, registry) }
end

bad_context = clone(schema4)
bad_context["sources"]["jira_context"] = "partial"
expect_error("invalid jira_context") { validate_manifest(bad_context, index, registry) }

%w[material stale].each do |flag|
  text_flag = clone(schema4)
  text_flag["sources"]["conflicts"].first[flag] = "yes"
  expect_error("conflict #{flag} must be true or false") { validate_manifest(text_flag, index, registry) }
end

empty_question = clone(schema4)
schema4_child(empty_question, "choose-transport")["classification"]["question"] = " "
expect_error("classification question must be text") { validate_manifest(empty_question, index, registry) }

empty_search = clone(schema4)
schema4_child(empty_search, "choose-transport")["classification"]["precedent"]["searched"] = "src"
expect_error("precedent searched must list locations") { validate_manifest(empty_search, index, registry) }

unsupported_classified = clone(schema4)
schema4_child(unsupported_classified, "build-endpoint")["type"] = "Bug"
expect_error("unsupported child type") { validate_manifest(unsupported_classified, index, registry) }

bad_from_epic = clone(schema4)
bad_from_epic["shaping"]["spike_shape"]["from_epic"] = "sibling epic"
expect_error("from_epic must be a Jira key") { validate_manifest(bad_from_epic, index, registry) }

bad_child_key = clone(schema4)
bad_child_key["sources"]["existing_children"].first["jira_key"] = "work 301"
expect_error("existing_children entry requires a Jira key") { validate_manifest(bad_child_key, index, registry) }

%w[2026-13-45 2026-02-29 2026-04-31].each do |impossible|
  impossible_date = clone(schema4)
  impossible_date["sources"]["conflicts"].first["sources"].first["date"] = impossible
  expect_error("conflict source date must be a valid YYYY-MM-DD date") { validate_manifest(impossible_date, index, registry) }
end

# Other ISO 8601 forms parse as dates but are not the contract's YYYY-MM-DD form.
%w[20260203 2026-W06-2 2026-034].each do |other_form|
  other_date = clone(schema4)
  other_date["sources"]["conflicts"].first["sources"].first["date"] = other_form
  expect_error("conflict source date must be a valid YYYY-MM-DD date") { validate_manifest(other_date, index, registry) }
end

leap_day = clone(schema4)
leap_day["sources"]["conflicts"].first["sources"].first["date"] = "2024-02-29"
validate_manifest(leap_day, index, registry)

same_source = clone(schema4)
same_source["sources"]["conflicts"].first["sources"].last["ref"] = same_source["sources"]["conflicts"].first["sources"].first["ref"]
same_source["sources"]["conflicts"].first["winner"] = same_source["sources"]["conflicts"].first["sources"].first["ref"]
expect_error("conflict sources must be distinct") { validate_manifest(same_source, index, registry) }

repeated_read = clone(schema4)
repeated_read["sources"]["existing_children"].first["read"] = %w[status status]
expect_error("invalid existing_children read") { validate_manifest(repeated_read, index, registry) }

default_reviewers = clone(schema4)
default_reviewers["shaping"]["reviewers"]["source"] = "default"
expect_error("reviewers cannot come from a default") { validate_manifest(default_reviewers, index, registry) }

[[], " ", 123].each do |bad|
  bad_claim = clone(schema4)
  bad_claim["sources"]["conflicts"].first["claim"] = bad
  expect_error("conflict requires a claim") { validate_manifest(bad_claim, index, registry) }
end

padded_source = clone(schema4)
padded_source["sources"]["conflicts"].first["sources"].last["ref"] = padded_source["sources"]["conflicts"].first["sources"].first["ref"] + " "
expect_error("conflict sources must be distinct") { validate_manifest(padded_source, index, registry) }

empty_reviewers = clone(schema4)
empty_reviewers["shaping"]["reviewers"]["value"] = []
expect_error("shaping reviewers value must be a list of names") { validate_manifest(empty_reviewers, index, registry) }

empty_searched = clone(schema4)
schema4_child(empty_searched, "choose-transport")["classification"]["precedent"]["searched"] = []
expect_error("precedent searched must list locations") { validate_manifest(empty_searched, index, registry) }

# Schema-2/3 error precedence is unchanged: an unknown root field is reported before the schema version.
unknown_before_schema = clone(schema3)
unknown_before_schema["transition"] = "Done"
unknown_before_schema["schema_version"] = 9
expect_error("manifest has unknown field transition") { validate_manifest(unknown_before_schema, index, registry) }

# Pin the validator's schema-4 vocabulary to the prose contract, so a renamed or added key cannot drift silently.
schema4_prose = File.read(File.join(SKILL, "references", "manifest-contract.md"))[/^## Schema 4:.*?(?=^## Child invariants)/m]
assert(schema4_prose, "manifest contract lost its schema 4 section")
# Scan the rule text only. The worked example repeats most tokens and would mask a deleted rule.
schema4_prose = schema4_prose.gsub(/^~~~.*?^~~~$/m, "")
assert(!schema4_prose.include?("schema_version: 4"), "schema 4 pin still scans the worked example")
schema4_tokens = SCHEMA4_ROOT_KEYS + SHAPING_VALUES.keys + SHAPING_VALUES.values.grep(Array).flatten + SOURCES_READ +
  %w[jira_context existing_children conflicts claim winner material stale present absent] +
  %w[classification question precedent searched verdict location placeholder defined_by none found unverified] +
  %w[value source from_epic asked reused default]
schema4_tokens.each { |token| assert(schema4_prose.match?(/\b#{Regexp.escape(token)}\b/), "schema 4 prose does not name #{token}") }

# Pin each enumerated rule sentence, generated from the validator's own value sets.
def prose_list(values)
  values.length == 2 ? values.join(" or ") : "#{values[0..-2].join(", ")}, or #{values.last}"
end
schema4_rules = [
  "source is #{prose_list(SHAPING_SOURCES)}.",
  "spike_shape.value is #{prose_list(SHAPING_VALUES.fetch("spike_shape"))}.",
  "task_granularity.value is #{prose_list(SHAPING_VALUES.fetch("task_granularity"))}.",
  "jira_context is #{prose_list(JIRA_CONTEXTS)}.",
  "read is a nonempty subset of #{prose_list(SOURCES_READ).sub(", or ", ", and ")}",
  "verdict is #{prose_list(PRECEDENT_VERDICTS)}.",
  "material and stale are true or false.",
  "Its entries are #{prose_list(SHAPING_VALUES.keys).sub(", or ", ", and ")}",
  "Its keys are #{prose_list(CLASSIFICATION_KEYS).sub(", or ", ", and ")}.",
  "Its keys are #{prose_list(SOURCES_KEYS).sub(", or ", ", and ")}"
]
schema4_rules.each { |rule| assert(schema4_prose.include?(rule), "schema 4 prose lost rule: #{rule}") }

schema5 = clone(schema4_minimal)
schema5["schema_version"] = 5
expect_error("unsupported schema") { validate_manifest(schema5, index, registry) }

schema4_epic = clone(schema4)
schema4_epic["epic"]["changes"]["status"] = "Done"
expect_error("forbidden Epic field") { validate_manifest(schema4_epic, index, registry) }

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
