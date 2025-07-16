import 'dart:io';
import '../models/asset_info.dart';
import '../utils/string_utils.dart';

class AssetGenerator {
  final String assetDirPath;
  final String resourcesDirPath;

  AssetGenerator({
    required this.assetDirPath,
    required this.resourcesDirPath,
  });

  void generate() {
    final assetDir = Directory(assetDirPath);
    final resourcesDir = Directory(resourcesDirPath);

    _validateAssetsFolder(assetDir);
    _cleanResourcesFolder(resourcesDir);
    _createResourcesFolder(resourcesDir);

    final assetMap = _scanAssets(assetDir);

    if (assetMap.isEmpty) {
      print('⚠️  Warning: No valid asset files found in subfolders.');
      print('💡 Assets must be organized in subfolders (e.g., assets/images/, assets/fonts/)');
      exit(0);
    }

    print('\n🏗️  Generating asset classes...');
    assetMap.forEach((category, assets) {
      _generateAssetClass(category, assets);
    });

    print('\n✅ Asset generation completed successfully!');
    print('📂 Generated ${assetMap.length} asset classes in lib/resources/');
    print('\n💡 Import: import \'package:your_app/resources/images.dart\'; // etc');
  }

  void _validateAssetsFolder(Directory assetDir) {
    if (!assetDir.existsSync()) {
      print('❌ Error: assets/ folder not found.');
      print('💡 Please create an assets/ folder with your asset files.');
      exit(1);
    }
  }

  void _cleanResourcesFolder(Directory resourcesDir) {
    if (resourcesDir.existsSync()) {
      print('🧹 Cleaning existing lib/resources folder...');
      resourcesDir.deleteSync(recursive: true);
    }
  }

  void _createResourcesFolder(Directory resourcesDir) {
    print('📁 Creating lib/resources directory...');
    resourcesDir.createSync(recursive: true);
  }

  Map<String, List<AssetInfo>> _scanAssets(Directory assetDir) {
    final Map<String, List<AssetInfo>> assetMap = {};
    final files = assetDir.listSync(recursive: true).whereType<File>();

    if (files.isEmpty) {
      print('⚠️  Warning: No files found in assets folder.');
      exit(0);
    }

    print('🔍 Scanning assets...');
    for (final file in files) {
      final assetInfo = _analyzeAssetFile(file);
      if (assetInfo != null) {
        print('📝 Found: ${assetInfo.path} → ${assetInfo.fieldName}');
        assetMap.putIfAbsent(assetInfo.category, () => []).add(assetInfo);
      }
    }
    return assetMap;
  }

  AssetInfo? _analyzeAssetFile(File file) {
    final relativePath = file.path.replaceFirst('${assetDirPath}/', '');
    final pathParts = relativePath.split('/');

    // Only process files in subfolders
    if (pathParts.length <= 1) {
      print('⏭️  Skipping root file: ${file.path}');
      return null;
    }

    final category = pathParts[0];
    final fileName = pathParts.last;
    final extension = fileName.split('.').last.toLowerCase();

    // Skip hidden files and system files
    if (fileName.startsWith('.') || fileName.startsWith('_')) {
      print('⏭️  Skipping hidden file: ${file.path}');
      return null;
    }

    final fieldName = _generateSafeFieldName(fileName, extension);

    return AssetInfo(
      path: file.path,
      category: category,
      fileName: fileName,
      extension: extension,
      fieldName: fieldName,
    );
  }

  String _generateSafeFieldName(String fileName, String extension) {
    final baseName = fileName.split('.').first;
    final cleanName = baseName
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .split('_')
        .where((word) => word.isNotEmpty)
        .map((word) => capitalizeWord(word))
        .join('');

    return _applyExtensionPrefix(cleanName, extension);
  }

  String _applyExtensionPrefix(String baseName, String extension) {
    final formattedName = baseName.isEmpty ? 'Unknown' : baseName;

    switch (extension.toLowerCase()) {
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'webp':
      case 'bmp':
      case 'tiff':
        return 'img$formattedName';
      case 'svg':
        return 'svg$formattedName';
      case 'ttf':
      case 'otf':
      case 'woff':
      case 'woff2':
      case 'eot':
        return 'font$formattedName';
      case 'json':
      case 'xml':
      case 'yaml':
      case 'yml':
        return 'data$formattedName';
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
      case 'webm':
        return 'video$formattedName';
      case 'mp3':
      case 'wav':
      case 'ogg':
      case 'aac':
      case 'm4a':
        return 'audio$formattedName';
      case 'flr':
      case 'riv':
        return 'anim$formattedName';
      default:
        return 'asset$formattedName';
    }
  }

  void _generateAssetClass(String category, List<AssetInfo> assets) {
    final fileName = '${category.toLowerCase()}.dart';
    final file = File('$resourcesDirPath/$fileName');

    final buffer = StringBuffer();
    _writeFileHeader(buffer);

    final className = capitalize(category);
    buffer.writeln('class $className {');
    buffer.writeln('  const $className._();');
    buffer.writeln();
    buffer.writeln('  static const $className instance = $className._();');
    buffer.writeln();

    final groupedAssets = <String, List<AssetInfo>>{};
    for (final asset in assets) {
      final key = asset.extension.toUpperCase();
      groupedAssets.putIfAbsent(key, () => []).add(asset);
    }

    for (final extension in groupedAssets.keys.toList()..sort()) {
      buffer.writeln('  // $extension assets');
      for (final asset in groupedAssets[extension]!) {
        buffer.writeln('  static const String ${asset.fieldName} = \'${asset.path}\';');
      }
      buffer.writeln();
    }

    buffer.writeln('}');

    file.writeAsStringSync(buffer.toString());
    print('📄 Generated: $resourcesDirPath/$fileName (${assets.length} assets)');
  }

  void _writeFileHeader(StringBuffer buffer) {
    buffer.writeln('// Auto-generated by EASY ASSET GENERATOR');
    buffer.writeln('// Do NOT modify this file manually!');
    buffer.writeln('// Generated on: ${DateTime.now().toIso8601String()}');
    buffer.writeln();
  }
}
