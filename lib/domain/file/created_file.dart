import 'package:naprimer_app_v2/services/encoding/encoding_service.dart';

class CreatedFile {
  String name;
  String videoPath;
  String? imagePath;

  final EncodingService? encodingService;

  CreatedFile(this.name, this.videoPath, this.imagePath, this.encodingService);

  Future<String> encode(bool deleteOriginal, bool rectangleMode) async {
    if(this.encodingService != null)
    this.videoPath = await encodingService!.encode(this.name, this.videoPath, deleteOriginal, rectangleMode);
    return this.videoPath;
  }

  Future<String?>generateThumbnail() async {
    if(this.encodingService != null)
      this.imagePath = await encodingService!.videoPreview(this.videoPath);
    return this.imagePath;
  }
}