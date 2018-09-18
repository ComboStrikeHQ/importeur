# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Add
- Allow transformer to skip entries by returning `nil` or `false`. 

## [0.1.1] - 2018-01-31
### Changed
- Better performance on fetching existing records for ActiveRecordPostgresLoader.

## [0.1.0] - 2017-10-26
### Added
- Generic extractor (Importeur::Extractor).
- Appnexus, Rocketfuel and Combined data sources.
- ActiveRecord PostgreSQL loader.
- Main ETL class (API).

[Unreleased]: https://github.com/ad2games/importeur/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/ad2games/importeur/compare/v0.1.0...v0.1.1
