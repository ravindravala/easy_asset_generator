# Flutter Asset Generator

A powerful Dart script that automatically scans your Flutter project's `assets` folder and generates type-safe, organized asset classes for easy access throughout your application.

## Features

✅ **Automatic Asset Scanning** - Recursively scans your `assets` folder  
✅ **Organized by Subfolders** - Groups assets by their folder structure (images, fonts, icons, etc.)  
✅ **Type-Safe Access** - Compile-time checking of asset paths  
✅ **Static Optimization** - Uses singleton pattern for memory efficiency  
✅ **Clean API** - Simple `Assets.images.logo` syntax  
✅ **Auto-Generated** - No manual maintenance required  

## Installation

1. Save the asset generator script as `generate_assets.dart` in your Flutter project root
2. Ensure you have the following folder structure:
   ```
   your_flutter_project/
   ├── assets/
   │   ├── images/
   │   ├── fonts/
   │   ├── icons/
   │   └── ...
   ├── lib/
   └── generate_assets.dart
   ```

## Usage

### Step 1: Run the Generator

```bash
dart run generate_assets.dart
```

### Step 2: Generated Structure

The script will create:
```
lib/resources/
├── assets.dart          # Main assets file
├── images.dart          # Image assets
├── fonts.dart           # Font assets
├── icons.dart           # Icon assets
└── ...                  # Other subfolder assets
```

### Step 3: Import in Your Flutter Code

```dart
import 'package:your_app/resources/assets.dart';
```

### Step 4: Use in Your Widgets

```dart
// Image assets
Image.asset(Assets.images.logo)
Image.asset(Assets.images.background)

// Font assets
Text(
  'Custom Font Text',
  style: TextStyle(fontFamily: Assets.fonts.roboto),
)

// Icon assets
Image.asset(Assets.icons.home)
```

## Example Generated Code

### For this asset structure:
```
assets/
├── images/
│   ├── logo.png
│   ├── background.jpg
│   └── profile_pic.png
├── fonts/
│   ├── roboto.ttf
│   └── open_sans.ttf
└── icons/
    ├── home.svg
    └── settings.svg
```

### Generated `images.dart`:
```dart
class Images {
  const Images._();
  
  static const Images instance = Images._();
  
  static const String logo = 'assets/images/logo.png';
  static const String background = 'assets/images/background.jpg';
  static const String profilePic = 'assets/images/profile_pic.png';
}
```

### Generated `assets.dart`:
```dart
import 'images.dart';
import 'fonts.dart';
import 'icons.dart';

class Assets {
  const Assets._();
  
  static const Assets instance = Assets._();
  
  static Images get images => Images.instance;
  static Fonts get fonts => Fonts.instance;
  static Icons get icons => Icons.instance;
}
```

## Asset Access Methods

### Method 1: Through Assets Class (Recommended)
```dart
Assets.images.logo
Assets.fonts.roboto
Assets.icons.home
```

### Method 2: Direct Class Access
```dart
Images.logo
Fonts.roboto
Icons.home
```

## Best Practices

### 1. Asset Organization
Organize your assets in meaningful subfolders:
```
assets/
├── images/
│   ├── logos/
│   ├── backgrounds/
│   └── icons/
├── fonts/
├── animations/
└── data/
```

### 2. Naming Conventions
- Use lowercase with underscores for file names: `profile_pic.png`
- The generator converts them to camelCase: `profilePic`

### 3. pubspec.yaml Configuration
Don't forget to declare your assets in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/fonts/
    - assets/icons/
    - assets/animations/
```

### 4. Re-run After Changes
Run the generator again whenever you:
- Add new asset files
- Remove asset files
- Reorganize asset folders

## Advanced Features

### Skipping Root Files
Files placed directly in the `assets/` folder (not in subfolders) are automatically skipped and won't be included in the generated classes.

### Automatic Cleanup
The script automatically:
- Deletes existing `lib/resources/` folder
- Recreates it with fresh generated code
- Prevents conflicts with previous generations

### Field Name Generation
The generator automatically converts file names to valid Dart identifiers:
- `my-icon.png` → `myIcon`
- `logo_2x.png` → `logo2x`
- `background_image.jpg` → `backgroundImage`

## Integration with Flutter

### With Image Widget
```dart
Image.asset(
  Assets.images.logo,
  width: 100,
  height: 100,
)
```

### With Container Decoration
```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage(Assets.images.background),
      fit: BoxFit.cover,
    ),
  ),
)
```

### With Text Style
```dart
Text(
  'Custom Font',
  style: TextStyle(
    fontFamily: Assets.fonts.roboto,
    fontSize: 16,
  ),
)
```

## Troubleshooting

### Assets Not Found
1. Ensure assets are declared in `pubspec.yaml`
2. Run `flutter pub get` after updating pubspec.yaml
3. Check file paths are correct

### Generator Errors
1. Verify `assets/` folder exists
2. Ensure Dart SDK is properly installed
3. Check folder permissions

### Import Errors
1. Make sure to import the generated assets file
2. Check that `lib/resources/` folder was created
3. Verify generated files have no syntax errors

## Contributing

Feel free to enhance this generator script with additional features like:
- Custom naming conventions
- Different organization patterns
- Additional asset types
- Configuration file support

## License

This asset generator script is open source and available under the MIT License.

---

**Happy Coding! 🚀**

*Generated assets make your Flutter development faster and more reliable.*