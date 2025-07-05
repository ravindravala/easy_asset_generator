import 'dart:io';

void main(List<String> args) {
  final assetDir = Directory('assets');
  final resourcesDir = Directory('lib/resources');
  
  // Validate assets folder exists
  if (!assetDir.existsSync()) {
    print('❌ Error: assets/ folder not found.');
    print('💡 Please create an assets/ folder with your asset files.');
    exit(1);
  }
  
  // Clean up existing resources
  if (resourcesDir.existsSync()) {
    print('🧹 Cleaning existing lib/resources folder...');
    resourcesDir.deleteSync(recursive: true);
  }
  
  // Create fresh resources directory
  print('📁 Creating lib/resources directory...');
  resourcesDir.createSync(recursive: true);
  
  // Scan and organize assets
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
      
      if (!assetMap.containsKey(assetInfo.category)) {
        assetMap[assetInfo.category] = [];
      }
      assetMap[assetInfo.category]!.add(assetInfo);
    }
  }
  
  if (assetMap.isEmpty) {
    print('⚠️  Warning: No valid asset files found in subfolders.');
    print('💡 Assets must be organized in subfolders (e.g., assets/images/, assets/fonts/)');
    exit(0);
  }
  
  // Generate asset classes
  print('\n🏗️  Generating asset classes...');
  for (final category in assetMap.keys) {
    _generateAssetClass(category, assetMap[category]!);
  }
  
  // Generate unified main assets file
  _generateUnifiedAssetsFile(assetMap.keys.toList());
  
  print('\n✅ Asset generation completed successfully!');
  print('📂 Generated ${assetMap.length} asset classes in lib/resources/');
  print('🎯 Usage: Assets.images.imgLogo, Assets.fonts.fontRoboto, etc.');
  print('\n💡 Import: import \'package:your_app/resources/assets.dart\';');
}

/// Analyzes an asset file and creates AssetInfo
AssetInfo? _analyzeAssetFile(File file) {
  final relativePath = file.path.replaceFirst('assets/', '');
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

/// Generates a production-ready safe field name using extension-based prefixing
String _generateSafeFieldName(String fileName, String extension) {
  // Extract base name without extension
  final baseName = fileName.split('.').first;
  
  // Clean and convert to camelCase
  final cleanName = baseName
      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
      .split('_')
      .where((word) => word.isNotEmpty)
      .map((word) => _capitalizeWord(word))
      .join('');
  
  // Apply extension-based prefix for semantic naming and conflict avoidance
  return _applyExtensionPrefix(cleanName, extension);
}

/// Applies semantic prefixes based on file extension
String _applyExtensionPrefix(String baseName, String extension) {
  // Ensure baseName is properly formatted
  final formattedName = baseName.isEmpty ? 'Unknown' : baseName;
  
  switch (extension.toLowerCase()) {
    // Image formats
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
    case 'webp':
    case 'bmp':
    case 'tiff':
      return 'img$formattedName';
    
    // Vector graphics
    case 'svg':
      return 'svg$formattedName';
    
    // Font formats
    case 'ttf':
    case 'otf':
    case 'woff':
    case 'woff2':
    case 'eot':
      return 'font$formattedName';
    
    // Data formats
    case 'json':
    case 'xml':
    case 'yaml':
    case 'yml':
      return 'data$formattedName';
    
    // Video formats
    case 'mp4':
    case 'mov':
    case 'avi':
    case 'mkv':
    case 'webm':
      return 'video$formattedName';
    
    // Audio formats
    case 'mp3':
    case 'wav':
    case 'ogg':
    case 'aac':
    case 'm4a':
      return 'audio$formattedName';
    
    // Animation formats
    case 'flr':
    case 'riv':
      return 'anim$formattedName';
    
    // Default fallback
    default:
      return 'asset$formattedName';
  }
}

/// Capitalizes first letter of a word
String _capitalizeWord(String word) {
  if (word.isEmpty) return word;
  return word[0].toUpperCase() + word.substring(1).toLowerCase();
}

/// Capitalizes first letter of a string
String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

/// Generates individual asset class file
void _generateAssetClass(String category, List<AssetInfo> assets) {
  final fileName = '${category.toLowerCase()}.dart';
  final file = File('lib/resources/$fileName');
  
  final buffer = StringBuffer();
  _writeFileHeader(buffer);
  
  final className = _capitalize(category);
  buffer.writeln('class $className {');
  buffer.writeln('  const $className._();');
  buffer.writeln();
  buffer.writeln('  static const $className instance = $className._();');
  buffer.writeln();
  
  // Group assets by extension for better organization
  final groupedAssets = <String, List<AssetInfo>>{};
  for (final asset in assets) {
    final key = asset.extension.toUpperCase();
    groupedAssets.putIfAbsent(key, () => []).add(asset);
  }
  
  // Generate constants grouped by type
  for (final extension in groupedAssets.keys.toList()..sort()) {
    buffer.writeln('  // $extension assets');
    for (final asset in groupedAssets[extension]!) {
      buffer.writeln('  static const String ${asset.fieldName} = \'${asset.path}\';');
    }
    buffer.writeln();
  }
  
  buffer.writeln('}');
  
  file.writeAsStringSync(buffer.toString());
  print('📄 Generated: lib/resources/$fileName (${assets.length} assets)');
}

/// Generates the unified main assets.dart file
void _generateUnifiedAssetsFile(List<String> categories) {
  final file = File('lib/resources/assets.dart');
  
  final buffer = StringBuffer();
  _writeFileHeader(buffer);
  
  // Import all category files
  for (final category in categories..sort()) {
    buffer.writeln('import \'${category.toLowerCase()}.dart\';');
  }
  buffer.writeln();
  
  // Generate main unified class
  buffer.writeln('/// Unified assets class providing type-safe access to all asset categories');
  buffer.writeln('/// Generated by Easy Asset Generator');
  buffer.writeln('/// ');
  buffer.writeln('/// Usage: Assets.images.imgLogo, Assets.fonts.fontRoboto');
  buffer.writeln('class Assets {');
  buffer.writeln('  const Assets._();');
  buffer.writeln();
  buffer.writeln('  static const Assets instance = Assets._();');
  buffer.writeln();
  
  // Add getters for each category
  for (final category in categories..sort()) {
    final className = _capitalize(category);
    buffer.writeln('  static $className get $category => $className.instance;');
  }
  
  buffer.writeln('}');
  
  file.writeAsStringSync(buffer.toString());
  print('📄 Generated: lib/resources/assets.dart (unified main file)');
}

/// Writes standard file header with Easy Asset Generator warning
void _writeFileHeader(StringBuffer buffer) {
  buffer.writeln('// Auto-generated by EASY ASSET GENERATOR');
  buffer.writeln('// Do NOT modify this file manually!');
  buffer.writeln('// Generated on: ${DateTime.now().toIso8601String()}');
  buffer.writeln();
}

/// Asset information model
class AssetInfo {
  final String path;
  final String category;
  final String fileName;
  final String extension;
  final String fieldName;
  
  const AssetInfo({
    required this.path,
    required this.category,
    required this.fileName,
    required this.extension,
    required this.fieldName,
  });
  
  @override
  String toString() => 'AssetInfo(path: $path, fieldName: $fieldName)';
}