import 'package:easy_asset_generator/easy_asset_generator.dart';

void main(List<String> args) {
  const assetDirPath = 'assets';
  const resourcesDirPath = 'lib/resources';

  final generator = AssetGenerator(
    assetDirPath: assetDirPath,
    resourcesDirPath: resourcesDirPath,
  );

  generator.generate();
}
