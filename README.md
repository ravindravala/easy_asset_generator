# Easy Asset Generator

🚀 **Stop writing asset paths manually!**
This package **automatically generates type-safe asset classes for each asset category** in your Flutter project.

---

## ⚡ Quick Start

### 1. Add as Dev Dependency (Recommended)

```yaml
dev_dependencies:
  easy_asset_generator: <latest_version>
```

or use local path during development:

```yaml
dev_dependencies:
  easy_asset_generator:
    path: ../
```

### **OR: Activate Globally**

You can also use the package as a global tool:

```bash
dart pub global activate easy_asset_generator
```

---

### 2. Organize Your Assets

```
your_project/
├── assets/
│   ├── images/      # .png, .jpg, etc.
│   └── icons/       # .svg, etc.
├── lib/
└── pubspec.yaml
```

---

### 3. Run the Generator

If used as a dev dependency:

```bash
dart run easy_asset_generator
```

If used globally:

```bash
easy_asset_generator
```

---

### 4. Import & Use

Import the generated category file(s) you need:

```dart
import 'package:your_app/resources/images.dart';
import 'package:your_app/resources/icons.dart';
```

---

## 🎯 What You Get

**Before** (manual, error-prone):

```dart
Image.asset('assets/images/logo.png')      // ❌ Typos possible
Image.asset('assets/images/3d.png')        // ❌ Hard to maintain  
Image.asset('assets/images/default.png')   // ❌ Reserved word risk
```

**After** (type-safe, auto-generated):

```dart
Image.asset(Images.imgLogo)                // ✅ Autocomplete
Image.asset(Images.img3d)                  // ✅ Valid identifier
Image.asset(Images.imgDefault)             // ✅ No reserved word risk
```

---

## 📁 Generated Files

After running the script, you’ll get:

```
lib/resources/
├── images.dart     # All image asset constants
├── icons.dart      # All icon asset constants
# ...one file per asset category
```

---

## 🔧 Smart Naming

Handles problematic file names:

| File Name     | Generated Name | Why                   |
| ------------- | -------------- | --------------------- |
| `logo.png`    | `imgLogo`      | Images → `img` prefix |
| `home.svg`    | `svgHome`      | SVGs → `svg` prefix   |
| `3d.png`      | `img3d`        | Handles numbers       |
| `default.svg` | `svgDefault`   | Avoids reserved words |

---

## 🎨 Usage Example

```dart
import 'package:your_app/resources/images.dart';
import 'package:your_app/resources/icons.dart';

// Images
Image.asset(Images.imgLogo);

// SVG icons (if using flutter_svg)
SvgPicture.asset(Icons.svgHome);
```

---

## ⚠️ Notes

1. **Add assets to pubspec.yaml:**

   ```yaml
   flutter:
     assets:
       - assets/images/
       - assets/icons/
   ```

2. **Re-run after changes:**

   ```bash
   dart run easy_asset_generator
   ```

   or, if activated globally:

   ```bash
   easy_asset_generator
   ```

3. **Put assets in subfolders** (not directly in `assets/`).

---

## 🚨 Troubleshooting

| Problem                    | Solution                                      |
| -------------------------- | --------------------------------------------- |
| `assets/ folder not found` | Create an `assets/` folder in project root    |
| `No files found`           | Add files to subfolders like `assets/images/` |
| `Import errors`            | Run `flutter pub get` after generation        |
| `Assets not loading`       | Check your `pubspec.yaml` asset section       |

---

## 🎉 Benefits

* ✅ No more typos in asset paths
* ✅ Autocomplete for all assets
* ✅ Compile-time safety
* ✅ Handles tricky names (numbers, reserved words)
* ✅ Organized by category (images, icons, etc.)
* ✅ **Just import the category file you need**

---

**Made with ❤️ by [Ravindra Vala](https://www.linkedin.com/in/ravindra-vala-3b469315a/)**

*Turn asset management from a chore into a breeze!* 🚀