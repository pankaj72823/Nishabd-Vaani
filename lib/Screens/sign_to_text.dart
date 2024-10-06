import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignToText extends ConsumerStatefulWidget {
  const SignToText({super.key});

  @override
  _SignToTextState createState() => _SignToTextState();
}

class _SignToTextState extends ConsumerState<SignToText> {
  bool _isCapturing = false;
  CameraController? _cameraController;
  IO.Socket? _socket;
  String? _gesture;
  bool _isWebSocketActive = false;
  List<CameraDescription>? _cameras;
  CameraDescription? _currentCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _socket?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _currentCamera = _cameras?.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras!.first,
    );
    _cameraController = CameraController(
        _currentCamera!, ResolutionPreset.medium, enableAudio: false);

    await _cameraController?.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _startWebSocket() async {
    final ipAddress = ref.watch(ipAddressProvider);
    try {
      final response =
      await http.get(Uri.parse('http://$ipAddress:5000/start-websocket'));
      final message = response.body;

      if (message.contains('WebSocket connection is now active.')) {
        _connectSocket();
        if (mounted) {
          setState(() {
            _isWebSocketActive = true;
          });
        }
      }
    } catch (error) {
      print('Failed to start WebSocket: $error');
    }
  }

  void _stopWebSocket() {
    _socket?.disconnect();
    if (mounted) {
      setState(() {
        _isWebSocketActive = false;
        _gesture = null; // Reset gesture when stopping detection
      });
    }
  }

  void _connectSocket() {
    final ipAddress = ref.watch(ipAddressProvider);
    _socket = IO.io(
      'http://$ipAddress:5000',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    // Start sending frames after the WebSocket is connected
    _socket?.onConnect((_) {
      print('WebSocket connected, starting to send frames.');
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        _captureFrames();
      }
    });

    _socket?.on('result', (data) {
      if (mounted) {
        setState(() {
          print('Received data: $data');
          _gesture = data['gesture_name'];
        });
      }
    });

    _socket?.on('error', (message) {
      print('Error: $message');
    });
  }


  void _captureFrames() {
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        _isWebSocketActive) {
      Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        if (!_isWebSocketActive || !mounted) {
          timer.cancel();
          return;
        }

        if (_isCapturing) return;

        setState(() {
          _isCapturing = true;
        });

        try {
          final image = await _cameraController!.takePicture();
          final bytes = await image.readAsBytes();
          final base64String = base64Encode(bytes);
          _socket?.emit('videoFrame', base64String);
        } catch (e) {
          print('Error capturing frame: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error capturing frame')),
            );
          }
        } finally {
          setState(() {
            _isCapturing = false;
          });
        }
      });
    }
  }

  void _switchCamera() {
    if (_cameras == null || _cameras!.isEmpty) return;

    setState(() {
      _currentCamera = _currentCamera == _cameras!.first
          ? _cameras!.last
          : _cameras!.first;
      _cameraController = CameraController(
          _currentCamera!, ResolutionPreset.medium, enableAudio: false);
      _cameraController?.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFrontCamera =
        _currentCamera?.lensDirection == CameraLensDirection.front;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Sign to Text', style: GoogleFonts.openSans()),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_cameraController != null && _cameraController!.value.isInitialized)
              SizedBox(
                height: 200, // Smaller size for the camera preview
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(isFrontCamera ? pi : 0),
                  child: AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isWebSocketActive ? null : _startWebSocket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isWebSocketActive
                        ? Colors.grey
                        : Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Start Detection',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Spacing between buttons
                ElevatedButton(
                  onPressed: !_isWebSocketActive ? null : _stopWebSocket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    !_isWebSocketActive ? Colors.grey : Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Stop Detection',
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              _gesture != null
                  ? 'Recognized Gesture: $_gesture'
                  : 'Waiting for gesture...',
              style: GoogleFonts.openSans(
                  fontSize: 24, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Additional space below the gesture text
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert'; // For base64 encoding and decoding
//
// class SignToText extends StatefulWidget {
//   const SignToText({super.key});
//
//   @override
//   _SignToTextState createState() => _SignToTextState();
// }
//
// class _SignToTextState extends State<SignToText> {
//     bool _isCapturing = false;
//   CameraController? _cameraController;
//   IO.Socket? _socket;
//   String? _gesture;
//   bool _isWebSocketActive = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _socket?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
//     _cameraController = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);
//
//     await _cameraController?.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   Future<void> _startWebSocket() async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.173.164:5000/start-websocket'));
//       final message = response.body;
//
//       if (message.contains('WebSocket connection is now active.')) {
//         _connectSocket();
//         if (mounted) { // Check if the widget is still mounted
//           setState(() {
//             _isWebSocketActive = true;
//           });
//         }
//       }
//     } catch (error) {
//       print('Failed to start WebSocket: $error');
//     }
//   }
//
//   void _connectSocket() {
//     _socket = IO.io('http://192.168.173.164:5000', IO.OptionBuilder().setTransports(['websocket']).build());
//
//     // Start sending frames after the WebSocket is connected
//     _socket?.onConnect((_) {
//       print('WebSocket connected, starting to send frames.');
//       if (_cameraController != null && _cameraController!.value.isInitialized) {
//         _captureFrames();
//       }
//     });
//
//     // Listen for results from the server
//     _socket?.on('result', (data) {
//       if (mounted) { // Check if the widget is still mounted
//         setState(() {
//           print('Received data: $data');
//           _gesture = data['gesture_name'];
//         });
//       }
//     });
//
//     _socket?.on('error', (message) {
//       print('Error: $message');
//     });
//   }
//
//   void _captureFrames() {
//     if (_cameraController != null && _cameraController!.value.isInitialized && _isWebSocketActive) {
//       Timer.periodic(Duration(milliseconds: 500), (timer) async {
//         if (!_isWebSocketActive || !mounted) {
//           timer.cancel();
//           return;
//         }
//
//         if (_isCapturing) return; // Skip if capturing is in progress
//
//         setState(() {
//           _isCapturing = true;
//         });
//
//         try {
//           // Capture the image
//           final image = await _cameraController!.takePicture();
//           final bytes = await image.readAsBytes();
//
//           // Convert bytes to Base64 encoded string
//           final base64String = base64Encode(bytes);
//
//           // Emit the Base64 string through the socket
//           _socket?.emit('videoFrame', base64String);
//         } catch (e) {
//           print('Error capturing frame: $e');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Error capturing frame')),
//             );
//           }
//         } finally {
//           setState(() {
//             _isCapturing = false; // Reset flag after capture is done
//           });
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign to Text')),
//       body: Column(
//         children: [
//           if (_cameraController != null && _cameraController!.value.isInitialized)
//             AspectRatio(
//               aspectRatio: _cameraController!.value.aspectRatio,
//               child: CameraPreview(_cameraController!),
//             ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _isWebSocketActive ? null : _startWebSocket,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orangeAccent,
//               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30.0),
//               ),
//               elevation: 5,
//             ),
//             child: Text('Start', style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
//           ),
//           SizedBox(height: 20),
//           Text(
//             _gesture != null ? 'Recognized Gesture: $_gesture' : 'Waiting for gesture...',
//             style: TextStyle(fontSize: 24),
//           ),
//         ],
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:http/http.dart' as http;

// class SignToText extends StatefulWidget {
//   const SignToText({super.key});

//   @override
//   _SignToTextState createState() => _SignToTextState();
// }

// class _SignToTextState extends State<SignToText> {
//   CameraController? _cameraController;
//   IO.Socket? _socket;
//   String? _gesture;
//   bool _isWebSocketActive = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _socket?.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
//     _cameraController = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);

//     await _cameraController?.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> _startWebSocket() async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.173.164:5000/start-websocket'));
//       final message = response.body;

//       if (message.contains('WebSocket connection is now active.')) {
//         _connectSocket();
//         setState(() {
//           _isWebSocketActive = true;
//         });
//       }
//     } catch (error) {
//       print('Failed to start WebSocket: $error');
//     }
//   }

//   void _connectSocket() {
//     _socket = IO.io('http://192.168.173.164:5000', IO.OptionBuilder().setTransports(['websocket']).build());

//     _socket?.on('result', (data) {
//       setState(() {
//          print('Received data: $data'); 
//         _gesture = data['gesture_name'];
//       });
//     });

//     _socket?.on('error', (message) {
//       print('Error: $message');
//     });

//     // Capture frames at regular intervals once WebSocket is active
//     _captureFrames();
//   }

//   void _captureFrames() {
//     if (_cameraController != null && _isWebSocketActive) {
//       _cameraController!.startImageStream((CameraImage image) async {
//         final bytes = image.planes[0].bytes;
//         _socket?.emit('videoFrame', bytes);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign to Text')),
//       body: Column(
//         children: [
//           if (_cameraController != null && _cameraController!.value.isInitialized)
//             AspectRatio(
//               aspectRatio: _cameraController!.value.aspectRatio,
//               child: CameraPreview(_cameraController!),
//             ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _isWebSocketActive ? null : _startWebSocket,
//             child: Text('Start WebSocket'),
//           ),
//           SizedBox(height: 20),
//           Text(
//             _gesture != null ? 'Recognized Gesture: $_gesture' : 'Waiting for gesture...',
//             style: TextStyle(fontSize: 24),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'dart:async';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image/image.dart' as img;
// import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'package:google_fonts/google_fonts.dart';
//
// class SignToText extends StatefulWidget {
//   @override
//   _SignToTextState createState() => _SignToTextState();
// }
//
// class _SignToTextState extends State<SignToText> {
//   CameraController? _cameraController;
//   io.Socket? _socket;
//   bool _isSocketActive = false;
//   bool _isSendingFrames = false;
//   String? _gesture;
//   bool _isFrontCamera = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );
//       final backCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.back,
//         orElse: () => cameras.first,
//       );
//
//       final camera = _isFrontCamera ? frontCamera : backCamera;
//       _cameraController = CameraController(camera, ResolutionPreset.low);
//       await _cameraController?.initialize();
//       if (mounted) {
//         setState(() {});
//       }
//     } catch (e) {
//       print('Error initializing camera: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to initialize camera')),
//       );
//     }
//   }
//
//   Future<void> _setupSocket() async {
//     try {
//       print('Attempting to connect to Socket.IO...');
//       _socket = io.io('http://192.168.173.164:5000',
//       io.OptionBuilder().setTransports(['polling', 'websocket']).disableAutoConnect().build()
//       );
//       _socket?.connect();
//       _socket?.onConnect((data) {
//         print('Socket.IO connection established.');
//         setState(() {
//           _isSocketActive = true;
//         });
//       });
//
//       _socket!.on('gesture', (data) {
//         print('Received data: $data');
//         setState(() {
//           _gesture = data;
//         });
//       });
//
//       _socket?.onError((error) {
//         print('Socket.IO error: $error');
//       });
//
//       _socket?.connect();
//     } catch (e) {
//       print('Error setting up Socket.IO: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to connect to Socket.IO: $e')),
//       );
//     }
//   }
//
//   Future<void> _startSendingFrames() async {
//     await _setupSocket();
//
//     if (_isSocketActive) {
//       try {
//         final response = await http.get(Uri.parse('http://192.168.173.164:5000/start-websocket'));
//         final message = response.body;
//
//         if (message.contains('Socket.IO connection is now active.')) {
//           setState(() {
//             _isSendingFrames = true;
//           });
//
//           _sendFrames();
//         } else {
//           throw Exception('Failed to start Socket.IO session');
//         }
//       } catch (error) {
//         print('Failed to start Socket.IO: $error');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to start sending frames')),
//         );
//       }
//     }
//   }
//
//   Future<void> _stopSendingFrames() async {
//     setState(() {
//       _isSendingFrames = false;
//     });
//   }
//
//   Future<void> _sendFrames() async {
//     Timer.periodic(Duration(milliseconds: 500), (timer) async {
//       if (!_isSendingFrames) {
//         timer.cancel();
//         return;
//       }
//
//       if (_cameraController != null && _cameraController!.value.isInitialized) {
//         try {
//           final image = await _cameraController!.takePicture();
//           final bytes = await image.readAsBytes();
//           final img.Image? frame = img.decodeImage(bytes);
//
//           if (frame != null) {
//             final resizedFrame = img.copyResize(frame, width: 320, height: 240);
//             final jpeg = img.encodeJpg(resizedFrame);
//             _socket?.emit('frame', jpeg);
//           }
//         } catch (e) {
//           print('Error capturing frame: $e');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error capturing frame')),
//           );
//         }
//       }
//     });
//   }
//
//   Future<void> _toggleCamera() async {
//     setState(() {
//       _isFrontCamera = !_isFrontCamera;
//       _initializeCamera();  // Reinitialize camera with the new selection
//     });
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _socket?.disconnect();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Sign to Text',
//           style: GoogleFonts.openSans(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.orange,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.switch_camera),
//             onPressed: _toggleCamera,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 250,
//               width: 350,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: CameraPreview(_cameraController!),
//               ),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _startSendingFrames,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Start detection',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _stopSendingFrames,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Stop detection',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//             Container(
//               height: 150,
//               width: 300,
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: _gesture != null
//                   ? Text(
//                 'Recognized Gesture: $_gesture',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//                   : Center(
//                 child: Text(
//                   'Waiting for gesture...',
//                   style: GoogleFonts.openSans(
//                     color: Colors.grey,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






// import 'dart:async';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image/image.dart' as img;
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SignToText extends StatefulWidget {
//   @override
//   _SignToTextState createState() => _SignToTextState();
// }

// class _SignToTextState extends State<SignToText> {
//   CameraController? _cameraController;
//   WebSocketChannel? _channel;
//   bool _isWebSocketActive = false;
//   bool _isSendingFrames = false;
//   String? _gesture;
//   bool _isFrontCamera = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _startWebSocketSetup();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first);
//     final backCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.back,
//         orElse: () => cameras.first);

//     final camera = _isFrontCamera ? frontCamera : backCamera;
//     _cameraController = CameraController(camera, ResolutionPreset.low);
//     await _cameraController?.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> _startWebSocketSetup() async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.173.164:5000/start-websocket'));
//       final message = response.body;

//       if (message.contains('WebSocket connection is now active.')) {
//         setState(() {
//           _isWebSocketActive = true;
//         });
//       }
//     } catch (error) {
//       print('Failed to start WebSocket: $error');
//     }
//   }

//   Future<void> _startWebSocket() async {
//     if (_isWebSocketActive) {
//       _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.173.164:5000'));

//       _channel?.stream.listen((data) {
//         setState(() {
//           _gesture = data;
//         });
//       });

//       setState(() {
//         _isSendingFrames = true;
//       });

//       _sendFrames();
//     }
//   }

//   Future<void> _stopWebSocket() async {
//     setState(() {
//       _isSendingFrames = false;
//     });
//   }

//   Future<void> _sendFrames() async {
//     Timer.periodic(Duration(milliseconds: 500), (timer) async {
//       if (!_isSendingFrames) {
//         timer.cancel();
//         return;
//       }

//       if (_cameraController != null && _cameraController!.value.isInitialized) {
//         try {
//           final image = await _cameraController!.takePicture();
//           final bytes = await image.readAsBytes();
//           final img.Image? frame = img.decodeImage(bytes);

//           if (frame != null) {
//             final resizedFrame = img.copyResize(frame, width: 320, height: 240);
//             final jpeg = img.encodeJpg(resizedFrame);
//             _channel?.sink.add(jpeg);
//           }
//         } catch (e) {
//           print('Error capturing frame: $e');
//         }
//       }
//     });
//   }

//   Future<void> _toggleCamera() async {
//     setState(() {
//       _isFrontCamera = !_isFrontCamera;
//       _initializeCamera();  // Reinitialize camera with the new selection
//     });
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _channel?.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Sign to Text',
//           style: GoogleFonts.openSans(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.orange,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.switch_camera),
//             onPressed: _toggleCamera,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 250,
//               width: 350,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: CameraPreview(_cameraController!),
//               ),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _isSendingFrames ? _stopWebSocket : _startWebSocket,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 _isSendingFrames ? 'Stop detection' : 'Start detection',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             SizedBox(height: 32),
//             Container(
//               height: 150,
//               width: 300,
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: _gesture != null
//                   ? Text(
//                 'Recognized Gesture: $_gesture',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//                   : Center(
//                 child: Text(
//                   'Waiting for gesture...',
//                   style: GoogleFonts.openSans(
//                     color: Colors.grey,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class SignToText extends StatefulWidget {
//   const SignToText({super.key});
//
//   @override
//   _SignToTextState createState() => _SignToTextState();
// }
//
// class _SignToTextState extends State<SignToText> {
//   CameraController? _cameraController;
//   late List<CameraDescription> cameras;
//   late CameraDescription selectedCamera;
//   bool isCameraInitialized = false;
//   bool isSendingFrames = false;
//   Timer? _timer;
//   String? _outputWord;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCameras();
//   }
//
//   Future<void> _initializeCameras() async {
//     cameras = await availableCameras();
//     selectedCamera = cameras.firstWhere(
//           (camera) => camera.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );
//     _initializeCamera(selectedCamera);
//   }
//
//   Future<void> _initializeCamera(CameraDescription camera) async {
//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//
//     await _cameraController?.initialize();
//     setState(() {
//       isCameraInitialized = true;
//     });
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   void _startSendingFrames() {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       print('Error: Camera not initialized.');
//       return;
//     }
//
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
//       await _captureAndSendFrame();
//     });
//   }
//
//   Future<void> _captureAndSendFrame() async {
//     try {
//       final XFile file = await _cameraController!.takePicture();
//       final Uint8List imageBytes = await file.readAsBytes();
//
//       final String filename = file.name;
//       final mimeType = lookupMimeType(filename);
//       final multipartFile = http.MultipartFile.fromBytes(
//         'file',
//         imageBytes,
//         filename: filename,
//         contentType: mimeType != null ? MediaType.parse(mimeType) : null,
//       );
//
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://192.168.43.188:8080/predict'), // Replace with your actual IP or URL
//       );
//       request.files.add(multipartFile);
//
//       final response = await request.send();
//
//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         final Map<String, dynamic> responseData = jsonDecode(responseBody);
//         final outputWord = responseData['gesture_name']; // Adjust according to your server response
//         setState(() {
//           _outputWord = outputWord; // Update the state with the output word
//         });
//         print('Output Word: $_outputWord');
//       } else {
//         print('Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error capturing and sending frame: $e');
//     }
//   }
//
//   void _swapCamera() {
//     if (cameras.length > 1) {
//       final currentLensDirection = _cameraController?.description.lensDirection;
//       final newCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection != currentLensDirection,
//         orElse: () => cameras.first,
//       );
//
//       _initializeCamera(newCamera);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           'Sign to Text Conversion',
//           style: GoogleFonts.openSans(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.orange,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.switch_camera),
//             onPressed: _swapCamera,
//           ),
//         ],
//       ),
//       body: isCameraInitialized
//           ? Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 250,
//               width: 350,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: CameraPreview(_cameraController!),
//               ),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: isSendingFrames
//                   ? null
//                   : () {
//                 setState(() {
//                   isSendingFrames = true;
//                 });
//                 _startSendingFrames();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 padding: EdgeInsets.symmetric(
//                     vertical: 16, horizontal: 32),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Start Sending Frames',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: isSendingFrames
//                   ? () {
//                 setState(() {
//                   isSendingFrames = false;
//                 });
//                 _timer?.cancel();
//               }
//                   : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: EdgeInsets.symmetric(
//                     vertical: 16, horizontal: 32),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Stop Sending Frames',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             SizedBox(height: 32),
//             Container(
//               height: 150,
//               width: 300,
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: _outputWord != null
//                   ? Text(
//                 'Output Word: $_outputWord',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )
//                   : Center(
//                 child: Text(
//                   'No output yet',
//                   style: GoogleFonts.openSans(
//                     color: Colors.grey,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }


