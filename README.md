# hikvision-cloud-streaming-app
This is an app for streaming video
# Hikvision Cloud Streaming App

A cross-platform mobile app (Flutter) + backend to stream Hikvision cameras securely over the cloud using HLS/WebRTC.

## Features
- Live streaming from Hikvision cameras
- Cloud architecture (MediaMTX)
- User authentication (JWT)
- PTZ Control (basic)
- Low latency & reliable HLS fallback

## Tech Stack
- **Frontend**: Flutter
- **Backend**: Node.js + Express
- **Media Server**: MediaMTX (rtsp-simple-server)
- **Streaming**: HLS (primary) + WebRTC support

## Quick Start

```bash
git clone https://github.com/yourusername/hikvision-cloud-streaming-app.git
cd hikvision-cloud-streaming-app

# Start backend + MediaMTX
docker-compose up -d
