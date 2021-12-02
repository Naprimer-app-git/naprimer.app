import 'dart:io';
import 'dart:math';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_ffmpeg/stream_information.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:path_provider/path_provider.dart';

class EncodingService extends GetxService {
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
  final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

  Future<String> encode(String videoName, String videoPath, bool deleteOriginal,
      bool rectangleMode) async {
    Directory tempDir = await getTemporaryDirectory();
    String path = tempDir.path;
    String fullPath = "$path/ENC_$videoName";

    MediaInformation info =
        await _flutterFFprobe.getMediaInformation(videoPath);
    List<StreamInformation>? streams = info.getStreams();

    int width = 0;
    int height = 0;

    streams!.forEach((StreamInformation element) {
      if (element.getAllProperties()["codec_type"] == "video") {
        width = element.getAllProperties()["width"] ?? 0;
        height = element.getAllProperties()["height"] ?? 0;
      }
    });

    int minSize = min(width, height);
    String cropCommand =
        minSize > 0 && rectangleMode ? "-filter:v crop=$minSize:$minSize" : "";

    var command = "-i $videoPath -c:v mpeg4 -b:v 512k $cropCommand $fullPath";

    int result = await _flutterFFmpeg.execute(command);

    if (result == 0 && deleteOriginal) {
      File original = File(videoPath);
      await original.delete();
    }

    return fullPath;
  }

  Future<String> videoPreview(String path) async {
    final String outPath = path.replaceAll(".mp4", ".jpg");
    final arguments = '-i $path -vframes 1 -an -ss 1 $outPath';

    await _flutterFFmpeg.execute(arguments);
    return outPath;
  }
}
