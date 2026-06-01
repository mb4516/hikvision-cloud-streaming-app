import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HikvisionCameraView extends StatefulWidget {
  final String streamUrl;
  final String cameraName;

  const HikvisionCameraView({
    super.key,
    required this.streamUrl,
    required this.cameraName,
  });

  @override
  State<HikvisionCameraView> createState() => _HikvisionCameraViewState();
}

class _HikvisionCameraViewState extends State<HikvisionCameraView> {
  late VideoPlayerController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.streamUrl))
      ..initialize().then((_) {
        setState(() {
          isLoading = false;
          _controller.play();
        });
      }).catchError((e) {
        print("Stream error: $e");
        setState(() => isLoading = false);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cameraName)),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Text("Failed to load stream"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.value.isPlaying
            ? _controller.pause()
            : _controller.play(),
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
