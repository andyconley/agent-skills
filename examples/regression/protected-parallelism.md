# Regression: Protected Parallelism

## Source

DO NOT store bearer tokens in `chrome.storage.local`. Store bearer tokens in `chrome.storage.session`.

DO store observability session IDs in `chrome.storage.local`. They need to survive a browser restart for trace correlation.

Driven with a payload carrying no id and a foreign name, the worker relabelled the part. Driven with a token missing `exp`, the expiry guard never fired.

## Why it is protected

The repeated structure compares two storage rules and two executed evidence markers. Plain prose can improve the surrounding explanation, but it must not remove the comparison or change the technical terms.

## Pass checks

- Keeps `chrome.storage.local` and `chrome.storage.session` exactly
- Keeps the storage distinction
- Keeps the two `Driven with...` evidence markers or an equally explicit executed-evidence form
- Does not flatten the `DO NOT` / `DO` rule pair into a vague recommendation
