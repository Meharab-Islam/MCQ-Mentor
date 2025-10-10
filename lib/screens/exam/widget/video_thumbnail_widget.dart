import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  const VideoThumbnailWidget({required this.videoUrl, super.key});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  VideoPlayerController? _videoController;
  bool isInitialized = false;
  bool hasError = false;

  Future<void> _initializeAndPlay() async {
    try {
      _videoController = VideoPlayerController.network(widget.videoUrl);
      await _videoController!.initialize();
      await _videoController!.play();

      setState(() {
        isInitialized = true;
      });

      // Show video in dialog
      if (mounted) {
        Get.dialog(
          Dialog(
            insetPadding: const EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Video init error: $e');
      setState(() {
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.error, color: Colors.red, size: 50),
        ),
      );
    }

    return GestureDetector(
      onTap: _initializeAndPlay,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black12,
          image: const DecorationImage(
            image: NetworkImage(
                'https://www.wowmakers.com/static/Video-thumbnail-e743f3689ca0c0bac8faab39023da37f.jpeg'), // default thumbnail
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Icon(Icons.play_arrow, color: Colors.white, size: 50),
        ),
      ),
    );
  }
}
