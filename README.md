# MyAT – Local Anime Tracker

A self-contained application for maintaining a personal anime list without relying on external services.

---

## Overview

MyAT is built to be *download → run → own your data*. There is no assumption of remote servers or vendor lock-in. The goal is to provide an offline-first Anime list tracker similar in purpose to MyAnimeList, but without surrendering user information to third-party services. All state lives locally, and the executable bundles its own static assets.

The design favors flat, predictable control flow and minimal dependencies. Everything is written from scratch and only uses language standard libraries and the POSIX API. The main target is Linux. If it happens to compile and work on macOS, that’s a bonus, but there is no ongoing effort to support it.

---

## Build & Run

| Action                     | Command        |
| -------------------------- | -------------- |
| Development build          | `make dev`     |
| Production / release build | `make release` |

Release builds produce a single binary under `bin/` that already contains assets and requires no additional files at runtime.

---

## Architecture

### High-Level Layout

```
Project
├── Assets/        // Static files embedded into the binary
├── lib/           // Generated static library for embed subsystem
├── Sources/       // Core implementation
└── bin/           // Final build output (self-contained executable)
```

### Binary Embedding System

The `utils.go` and `libutils.a` pairing handles bundling static assets into the final executable.
The steps during build:

1. `utils.go` reads raw data under `Assets/`.
2. The embed tool converts them into raw blobs.
3. `libutils.a` exposes a C interface (`libutils.h`) to access that data.
4. Swift code calls into that C API through `Utils/module.modulemap`.

This flow ensures all static files (JSON, HTML, MP4, text files) are packaged inside the executable with no filesystem lookups at runtime.

---

## Core Execution Flow

```
main.swift
   ↓
HTTP subsystem (HTTP.swift)
   ↓
Router.swift
   ↓
Handler/*
   ↓
Processor.swift / Parser.swift
```

### HTTP & Routing

The project ships its own tiny HTTP subsystem. No third-party HTTP library of any kind.

* `HTTP.swift`
  Handles accepting TCP connections, reading raw HTTP requests, and writing HTTP responses.

* `Router.swift`
  Dispatches requests based on HTTP method and path.

* `Handler/`
  Contains the actual endpoints:

  * `API.swift`       → JSON-style responses
  * `Dynamic.swift`   → Pages requiring request-dependent processing
  * `HTML.swift`      → Raw HTML routes (served from embedded files)
  * `Basic.swift`     → Simple plain-text handlers
  * `Method.swift`    → Internal utilities for checking request method

The router calls a handler, which emits a low-level response structure (status, headers, body) with no reflection or abstractions.

## Assets & User Data

* Static assets: bundled in the executable via the embedding system.
* User data: will eventually be stored in a simple local format (e.g., JSON/flatfile) under the user’s own directory.
* No networking by default; syncing might be optional in the distant future but will always be opt-in.

---

## Guiding Principles

* Self-contained single-binary deployment
* No hidden dependencies
* Transparent data storage that a user can inspect directly
* Straightforward build system driven by `make`
* Uses only standard library + POSIX functionality

---

## Planned Next Steps

These are expected features after the architecture is finished:

* Anime list CRUD
* Tagging and sorting
* Embedded database / local file persistence
* Profile export / import
* Static HTML UI served locally
* Basic media preview (offline)

None of these are implemented yet, but the architecture already allocates the modules and flow for them.

---

## Status

Still at the foundation stage—HTTP, routing, and embedding are the primary working parts. The rest of the application logic will be built on top of this base.

---

## LICENSE

MIT — See [LICENSE](./LICENSE)

---

## ✨ Author

[Jelius Basumatary](https://jelius.dev) — Systems & App Developer in Practice
