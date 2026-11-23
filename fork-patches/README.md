# fork-patches

Changes to the projects this game is built from, applied to their submodules by `apply.sh` before every build
(`sh fork-patches/apply.sh`; add `--check` to only test them). A patch that does not apply fails the build.

| Patch | Fixes | Upstream | Delete it when |
|---|---|---|---|
| `plume/0001-metal-query-results-bytes.patch` | The game aborts in its first frames on Macs whose GPU returns an immutable `NSData` for timestamp queries (seen on an Intel UHD 630, macOS 15): `MetalQueryPool::queryResults()` called `-mutableBytes`, which only exists on `NSMutableData`. It reads `-bytes` instead, and tolerates a missing sample buffer. | a fix is proposed to renderbag/plume; its maintainers prefer updating Plume's bundled metal-cpp | Plume's own history has the fix and the game builds with that Plume |

A patch is a plain `git diff` against the submodule's root (no author header), so it can be applied with
`git -C <submodule> apply`.
