# Offline runtime (macOS Seatbelt)

Build and run the `screenpipe` CLI with **no external network**. Localhost is
allowed (local API / IPC). Profile: [`runtime.sb`](../runtime.sb). Wrapper:
[`scripts/run-offline.sh`](../scripts/run-offline.sh).

## Prerequisites

- macOS + Xcode
- Rust toolchain from [`rust-toolchain.toml`](../rust-toolchain.toml) (`rustup`)
- Homebrew deps: `pkg-config`, `ffmpeg`, `cmake`, `jq`, `wget`, `git-lfs`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# workbrew hosts: use /opt/workbrew/bin/brew
brew install pkg-config ffmpeg cmake jq wget git-lfs
```

## Build

From the repo root. Keep `CARGO_TARGET_DIR` local to this checkout (do not use a
shared Cursor sandbox cargo cache).

**Required:** disable release `strip`. Workspace `profile.release.strip = true`
produces broken `sqlx-macros` dylibs on current macOS (`mis-aligned LINKEDIT`).

```bash
export CARGO_TARGET_DIR="$PWD/target"
cargo build --release --features metal -p screenpipe-engine \
  --config 'profile.release.strip=false'
```

Binary: `target/release/screenpipe`

## Run without external network

```bash
./scripts/run-offline.sh ./target/release/screenpipe
# or with args:
./scripts/run-offline.sh ./target/release/screenpipe doctor
```

Equivalent:

```bash
sandbox-exec -f runtime.sb ./target/release/screenpipe
```

## Sync with upstream

This fork tracks `screenpipe/screenpipe` as `upstream` (HTTPS):

```bash
git fetch upstream
git merge upstream/main
```

Then rebuild with the command above.
