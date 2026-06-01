import 'package:flutter/material.dart';
import 'camera_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraListScreen extends StatefulWidget {
  const CameraListScreen({super.key});

  @override
  State<CameraListScreen> createState() => _CameraListScreenState();
}

class _CameraListScreenState extends State<CameraListScreen> {
  List<dynamic> cameras = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCameras();
  }

  Future<void> fetchCameras() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/cameras')); // Use your server IP
      if (response.statusCode == 200) {
        setState(() {
          cameras = json.decode(response.body);
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cameras')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cameras.length,
              itemBuilder: (context, index) {
                final cam = cameras[index];
                return ListTile(
                  leading: const Icon(Icons.videocam),
                  title: Text(cam['name'] ?? 'Camera'),
                  subtitle: Text('Live'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HikvisionCameraView(
                          streamUrl: 'http://your-server:8888/${cam['pathName']}/index.m3u8',
                          cameraName: cam['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCameraDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCameraDialog() {
    // Simple dialog to add camera (expand this)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Hikvision Camera"),
        content: const Text("Full form coming soon..."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }
}
