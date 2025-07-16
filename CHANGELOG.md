# Changelog

## 0.0.3

* **Optimized Code Structure**: Major refactor for code maintainability and performance.
* **Category-Based Asset Classes Only**: Removed centralized unified asset file generation.

  * Now, only separate asset category classes (e.g., `Images`, `Fonts`) are generated.
  * Each category is self-contained for easier imports and code clarity.
* **Cleaner Generation Flow**: Improved modularity and readability in the generation logic.
* **Ready for Large Projects**: Structure is now better suited for scalable and production use.

## 0.0.2

* **Enhanced File Name Handling**: Added intelligent extension-based prefixing system to handle reserved keywords and files starting with numbers.

  * Files like `default.svg` now generate as `svgDefault` (safe from Dart reserved keywords)
  * Files like `3d.png` now generate as `img3d` (valid Dart identifiers)
  * Image files get `img` prefix: `logo.png` → `imgLogo`
  * SVG files get `svg` prefix: `icon.svg` → `svgIcon`
  * Font files get `font` prefix: `roboto.ttf` → `fontRoboto`
  * Audio files get `audio` prefix: `click.mp3` → `audioClick`
  * Video files get `video` prefix: `intro.mp4` → `videoIntro`
  * Data files get `data` prefix: `config.json` → `dataConfig`
* **Semantic Asset Naming**: Extension-based prefixes provide clear asset type identification.
* **Zero Conflicts Guaranteed**: No reserved keyword checking needed - prefixes prevent all conflicts.
* **Unified Access Pattern**: Single import point with `Assets.category.fieldName` syntax.
* **Updated Documentation**: Refreshed README with new naming conventions and usage examples.
* **Improved Error Handling**: Better validation and user-friendly error messages.
* **Clean File Headers**: All generated files include "Easy Asset Generator" attribution and modification warnings.

## 0.0.1

* Initial release.
* Added support to scan assets and generate Dart classes per folder.
