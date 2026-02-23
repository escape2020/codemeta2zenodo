# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-02-23

### Added
- Initial release of CodeMeta to Zenodo converter GitHub Action
- Support for converting `codemeta.json` to `.zenodo.json` using EOSSR library
- Configurable input file path with default to `codemeta.json`
- Overwrite protection with optional override flag
- Comprehensive test suite with unit and integration tests
- Research software metadata files (`codemeta.json`, `CITATION.cff`)
- Documentation with usage examples and development guide
- CI/CD workflow for automated testing

### Dependencies
- EOSSR container v2.1.1 from GitLab registry
- Docker runtime environment
- GitHub Actions infrastructure

### Documentation
- Complete README with usage examples
- CITATION.cff for proper attribution
- Test fixtures and examples
- Development setup instructions

[Unreleased]: https://github.com/escape2020/codemeta2zenodo/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/escape2020/codemeta2zenodo/releases/tag/v1.0.0
