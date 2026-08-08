# Implementation Plan

1. Normalize the two skills as portable source packages and declare them in a validated manifest.
2. Add a curl-compatible bootstrap that clones or safely fast-forwards the stable checkout.
3. Add a manifest-driven manager with transactional preflight, additive symlink installation, and narrow uninstall.
4. Test selection, idempotency, conflict handling, non-pruning, and uninstall in temporary runtime directories on macOS and Linux.
5. Review and validate the repository, commit on `main`, and publish the public GitHub repository.
6. Back up the current local skill copies, install the managed links, and verify discovery inputs.
