// import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
//
// import 'package:tflite_flutter/tflite_flutter.dart';
//
// class PredictionService {
//   late Interpreter _interpreter;
//   bool _isModelLoaded = false;
//   late Future<void> _modelLoadFuture;
//
//   PredictionService() {
//     _modelLoadFuture = _loadModel();
//   }
//
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/model_english.tflite');
//       _isModelLoaded = true;
//     } catch (e) {
//       print('Failed to load model: $e');
//       _isModelLoaded = false;
//     }
//   }
//
//   Future<void> waitForModelLoad() async {
//     await _modelLoadFuture;
//   // }
//
//   // Float32List _normalizeInput(List<int> pixels) {
//   //   // Normalize the pixels to a float32 list with values between 0 and 1
//   //   return Float32List.fromList(
//   //     pixels.map((e) => e / 255.0).toList(),
//   //   );
//   // }
//   Float32List _prepareInput(List<int> pixels) {
//     // Normalize the pixel values to the range [0, 1] and reshape to [1, 50, 50, 1]
//     List<double> normalizedPixels = pixels.map((e) => e / 255.0).toList();
//
//     // Convert the normalized pixels to Float32List and return
//     return Float32List.fromList(normalizedPixels);
//   }
//
//   Future<String> predict(List<double> inputPixels) async {
//     if (!_isModelLoaded) {
//       throw Exception('Model not loaded. Please wait for initialization.');
//     }
//
//     var input = _prepareInput(inputPixels.cast<int>());
//
//     // Prepare the output buffer
//     var output = Float32List(47); // Assuming 26 letters
//
//     try {
//       _interpreter.run(input.buffer.asUint8List(), output.buffer.asUint8List());
//
//
//       int predictedIndex = output.indexWhere((val) => val == output.reduce((a, b) => a > b ? a : b));
//
//       // Return the predicted alphabet based on the index
//       return ENCODER.inverse[predictedIndex];
//     } catch (e) {
//       print('Prediction failed: $e');
//       return 'Error';
//     }
//   }
// }
