# nimbling Documentation

Nim to WebAssembly / JavaScript bindings — like `wasm-bindgen` for Nim.

---

## Getting Started

New to nimbling? Start here:

- [Getting Started](getting-started.md) — Install, build, and run your first WASM module
- [Examples](examples.md) — Code examples for common use cases
- [Architecture](architecture.md) — How nimbling works internally

---

## API Reference

Complete documentation for all public APIs:

- [API Reference](api.md) — `{.wasmBindgen.}`, `JsValue`, `webidlBind`, and more
- [CLI Reference](cli-reference.md) — Command-line tool options and usage
- [Type System](types.md) — Deep dive into type conversions

---

## Guides

In-depth guides for specific features:

- [WebIDL Guide](webidl-guide.md) — Using `webidlBind` for Web API bindings
- [Troubleshooting](troubleshooting.md) — Common issues and solutions

---

## Project Documentation

- [Contributing](contributing.md) — How to contribute to nimbling
- [README](../README.md) — Project overview
- [Design](../DESIGN.md) — Architecture and design decisions
- [Roadmap](../ROADMAP.md) — Project status and future plans

---

## Quick Links

| Resource | Description |
|----------|-------------|
| [GitHub](https://github.com/katehonz/nimbling) | Main repository |
| [Issues](https://github.com/katehonz/nimbling/issues) | Bug reports and feature requests |
| [Nim website](https://nim-lang.org) | Nim programming language |
| [wasm-bindgen](https://github.com/rustwasm/wasm-bindgen) | Rust inspiration for this project |

---

## Documentation Map

```
nimbling/
├── README.md              # Project overview
├── DESIGN.md              # Architecture (Bulgarian)
├── ROADMAP.md             # Project roadmap
├── docs/
│   ├── index.md           # You are here
│   ├── getting-started.md  # Quick start guide
│   ├── examples.md        # Code examples
│   ├── architecture.md    # System design
│   ├── api.md            # API reference
│   ├── cli-reference.md  # CLI tool docs
│   ├── types.md          # Type system
│   ├── webidl-guide.md   # WebIDL bindings
│   ├── troubleshooting.md # Common issues
│   └── contributing.md   # Contribution guide
└── src/
    └── nimbling/          # Source code
```

---

## Version

This documentation reflects **nimbling v0.1.0** (Schema v0.2.0).