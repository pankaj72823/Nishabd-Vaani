import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:google_fonts/google_fonts.dart';

class SignToText extends StatefulWidget {
  const SignToText({super.key});

  @override
  _SignToTextState createState() => _SignToTextState();
}

class _SignToTextState extends State<SignToText> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  late CameraDescription selectedCamera;
  bool isCameraInitialized = false;
  bool isSendingFrames = false;
  Timer? _timer;
  String? _outputWord;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    cameras = await availableCameras();
    selectedCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _initializeCamera(selectedCamera);
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController?.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startSendingFrames() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Error: Camera not initialized.');
      return;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await _captureAndSendFrame();
    });
  }

  Future<void> _captureAndSendFrame() async {
    try {
      final XFile file = await _cameraController!.takePicture();
      final Uint8List imageBytes = await file.readAsBytes();

      final String filename = file.name;
      final mimeType = lookupMimeType(filename);
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.43.188:8080/predict'), // Replace with your actual IP or URL
      );
      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = jsonDecode(responseBody);
        final outputWord = responseData['gesture_name']; // Adjust according to your server response
        setState(() {
          _outputWord = outputWord; // Update the state with the output word
        });
        print('Output Word: $_outputWord');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error capturing and sending frame: $e');
    }
  }

  void _swapCamera() {
    if (cameras.length > 1) {
      final currentLensDirection = _cameraController?.description.lensDirection;
      final newCamera = cameras.firstWhere(
            (camera) => camera.lensDirection != currentLensDirection,
        orElse: () => cameras.first,
      );

      _initializeCamera(newCamera);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sign to Text Conversion',
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: _swapCamera,
          ),
        ],
      ),
      body: isCameraInitialized
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CameraPreview(_cameraController!),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isSendingFrames
                  ? null
                  : () {
                setState(() {
                  isSendingFrames = true;
                });
                _startSendingFrames();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Start Sending Frames',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: isSendingFrames
                  ? () {
                setState(() {
                  isSendingFrames = false;
                });
                _timer?.cancel();
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Stop Sending Frames',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 32),
            Container(
              height: 150,
              width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: _outputWord != null
                  ? Text(
                'Output Word: $_outputWord',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : Center(
                child: Text(
                  'No output yet',
                  style: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/services.dart';
//
//
//
//
// class SignToText extends StatelessWidget {
//   const SignToText({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Sign to Text Conversion', style: GoogleFonts.openSans(
//         color: Colors.black,
//         fontSize: 24,
//         fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.orange
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//
//           children: [
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 image: DecorationImage(
//                   image: AssetImage('assets/Conversion/signtotext.gif'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent,
//                 padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Open Camera',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             SizedBox(height: 32),
//             Container(
//               height: 300,
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
//               child: Text(
//                 'Converted text will appear here...',
//                 style: GoogleFonts.openSans(
//                   color: Colors.black,
//                   fontSize: 16,
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
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';
//
// class ContinuousCameraScreen extends StatefulWidget {
//   const ContinuousCameraScreen({super.key});
//
//   @override
//   _ContinuousCameraScreenState createState() => _ContinuousCameraScreenState();
// }
//
// class _ContinuousCameraScreenState extends State<ContinuousCameraScreen> {
//   CameraController? _cameraController;
//   late List<CameraDescription> cameras;
//   late CameraDescription selectedCamera;
//   bool isCameraInitialized = false;
//   bool isSendingFrames = false;
//   Timer? _timer;
//   String? _outputWord; // Renamed to 'outputWord' for clarity
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
//       imageFormatGroup: ImageFormatGroup.yuv420,
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
//       appBar: AppBar(
//         title: Text('Continuous Camera'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.switch_camera),
//             onPressed: _swapCamera,
//           ),
//         ],
//       ),
//       body: isCameraInitialized
//           ? Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: AspectRatio(
//               aspectRatio: _cameraController!.value.aspectRatio,
//               child: CameraPreview(_cameraController!),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: isSendingFrames
//                   ? null
//                   : () {
//                 setState(() {
//                   isSendingFrames = true;
//                 });
//                 _startSendingFrames();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 16.0),
//               ),
//               child: Text('Start Sending Frames'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: ElevatedButton(
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
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 16.0),
//               ),
//               child: Text('Stop Sending Frames'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: _outputWord != null
//                 ? Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Text(
//                 'Output Word: $_outputWord',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             )
//                 : Center(
//               child: Text(
//                 'No output yet',
//                 style: TextStyle(fontSize: 24, color: Colors.grey),
//               ),
//             ),
//           ),
//         ],
//       )
//           : Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
