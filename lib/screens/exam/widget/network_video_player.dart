import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({required this.videoUrl, super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  bool isInitialized = false;
  bool isPlaying = false;
  bool hasError = false;
  bool isLoading = false;
  bool showControls = true;

  Future<void> _initializeAndPlay() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      _videoController = VideoPlayerController.network(widget.videoUrl)
        ..addListener(() {
          if (_videoController!.value.hasError) {
            debugPrint('Video error: ${_videoController!.value.errorDescription}');
            setState(() {
              hasError = true;
              isLoading = false;
            });
          }
        });

      await _videoController!.initialize();
      await _videoController!.play();

      setState(() {
        isInitialized = true;
        isPlaying = true;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Video init error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _togglePlayPause() {
    if (_videoController == null) return;

    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
      setState(() => isPlaying = false);
    } else {
      _videoController!.play();
      setState(() => isPlaying = true);
    }
  }

  void _closePlayer() {
    _videoController?.pause();
    _videoController?.dispose();
    Navigator.of(context).pop();
  }

  void _toggleControls() {
    setState(() {
      showControls = !showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video
            if (isInitialized && _videoController != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ),

            // Loading
            if (isLoading)
              const Center(child: CircularProgressIndicator(color: Colors.white)),

            // Error
            if (hasError)
              const Center(child: Icon(Icons.error, color: Colors.red, size: 60)),

            // Controls overlay
            if (showControls && isInitialized && !hasError)
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top bar with close button
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            iconSize: 30,
                            color: Colors.white,
                            icon: const Icon(Icons.close),
                            onPressed: _closePlayer,
                          ),
                        ),
                      ),

                      // Center play/pause button
                      Center(
                        child: IconButton(
                          iconSize: 60,
                          color: Colors.white,
                          icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ),

                      // Bottom progress bar
                      if (_videoController != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VideoProgressIndicator(
                                _videoController!,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  backgroundColor: Colors.white24,
                                  bufferedColor: Colors.white38,
                                  playedColor: Colors.redAccent,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_videoController!.value.position),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    _formatDuration(_videoController!.value.duration),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            // Initial play icon before video starts
            if (!isInitialized && !isLoading && !hasError)
              const Icon(Icons.play_arrow, color: Colors.white, size: 60),
          ],
        ),
      ),
    );
  }
}
