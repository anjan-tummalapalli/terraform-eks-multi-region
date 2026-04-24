# Terraform Documentation Best Practices

This guide defines how to keep infrastructure code understandable, reviewable,
and upgrade-safe over time.

## Goals

- Make module intent obvious without reading every resource block.
- Keep inputs/outputs self-documenting and stable for consumers.
- Explain security and cost implications near the code that implements them.
- Reduce upgrade risk by documenting compatibility assumptions and version
  constraints.

## Repository Conventions

- Keep module contracts explicit:
  Every module must include `variables.tf` and `outputs.tf` with meaningful
  descriptions.
- Keep implementation separate from interface:
  Place resources and data sources in `main.tf`, and avoid mixing
  output/variable declarations into resource files.
- Keep examples runnable:
  Each example should include `main.tf`, `variables.tf`, `outputs.tf`, and
  `versions.tf`.
- Keep comments informative:
  Comments should explain intent, trade-offs, defaults, and security/cost
  rationale, not restate obvious syntax.

## Variable Documentation Rules

- Describe business intent, not only resource mapping.
  Prefer “CIDRs allowed to access notebook HTTPS endpoint” over “List of
  CIDR blocks.”
- Always document default behavior impact.
  If a default saves cost or improves security, mention it in the description.
- Add validations for risky inputs.
  Validate enum-like strings, non-empty names, positive sizes, and cross-field
  relationships.
- Mark sensitive values.
  Use `sensitive = true` for secrets and credentials.

## Output Documentation Rules

- Treat outputs as a public API.
  Output names and meanings should remain stable across compatible module
  versions.
- Explain nullability.
  When an output can be null (feature flag disabled), document that explicitly.
- Prefer actionable outputs.
  Surface values operators actually use (ARNs, endpoint names, URLs, IDs).

## README and Module Docs Rules

- Keep root README authoritative for architecture and operational guidance.
- Update README in the same change whenever:
  - module interfaces change
  - new examples are added
  - security/cost defaults change
- Document region constraints for service availability (for example Bedrock).
- Include “destroy after testing” guidance for all cost-incurring examples.

## Security Documentation Rules

- Call out identity boundaries:
  document which roles/services can assume or use keys/policies.
- Call out network boundaries:
  document public vs private access modes and recommended CIDR restrictions.
- Call out encryption boundaries:
  document where SSE-S3 vs KMS is used and why.
- Document logging/audit posture:
  include what is logged, where logs are stored, and retention defaults.

## Cost Documentation Rules

- Document baseline cost posture in each example:
  smallest viable instance type, retention windows, query scan limits, and
  disabled optional features.
- Explain “how to scale up safely”:
  identify variables to increase for production (multi-AZ, larger instance
  classes, longer retention).
- Keep cleanup steps explicit:
  include `terraform destroy` reminders and temporary-environment guidance.

## Upgrade and Change Management Rules

- Pin provider versions with compatible ranges (for example `~> 5.0`) and
  update intentionally.
- Keep backwards-compatible defaults when possible.
- Document breaking changes in module inputs/outputs before releasing.
- Add migration notes when renaming variables or outputs.

## Review Checklist

- [ ] Are variable descriptions accurate and user-focused?
- [ ] Do validations guard against unsafe/invalid values?
- [ ] Are output semantics clear (including nullable outputs)?
- [ ] Are security defaults and rationale documented?
- [ ] Are cost defaults and cleanup guidance documented?
- [ ] Is README updated for new modules/examples?
- [ ] Do examples still validate after changes?

