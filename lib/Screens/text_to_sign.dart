import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Provider/cookie_provider.dart';
import '../Provider/tokenProvider.dart';

class TextToSign extends ConsumerStatefulWidget {
  const TextToSign({Key? key}) : super(key: key);

  @override
  _TextToSignState createState() => _TextToSignState();
}



class _TextToSignState extends ConsumerState<TextToSign> {
  List<Map<String,String>> signData = [];
  String? selectedSign;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchSignData();
  }

  Future<void> fetchSignData() async {
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);

    final response = await http.get(
      headers: {
        'Authorization': '$token',
        'Content-Type' : 'application/json',
        'Cookie' : '$cookie',
      },
        Uri.parse('http://$ipAddress:5000/conversion'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> fetchedData = json.decode(response.body);
      setState(() {
        signData = fetchedData.map((item) {
          return {
            "sign_name": item['sign_name'].toString(),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load sign data');
    }
  }


  String? selectedValue;
  final TextEditingController _textController = TextEditingController();
  String? _gifUrl;
  String? _errorMessage;

  Future<void> _fetchSign() async {
    final ipAddress = ref.watch(ipAddressProvider);
    final token = ref.watch(tokenProvider);
    final cookie = ref.watch(cookieProvider);
    print('Fetching starts');
    final String word = _textController.text.trim();
    if (word.isEmpty) {
       print('word empty');
      setState(() {
        _errorMessage = "Please enter a word.";
        _gifUrl = null;
      });
      return;
    }
    print('Word not empty');
    try {
       print('request sending');
      final response = await http.post(
        headers: {
          'Authorization': '$token',
          'Content-Type' : 'application/json',
          'Cookie' : '$cookie',
        },
        Uri.parse('http://$ipAddress:5000/conversion'),
        body: jsonEncode({'word': word}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _gifUrl = data['cloud_location'];
          _errorMessage = null;
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _errorMessage = data['error']['message'];
          _gifUrl = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch the sign. Please try again.";
        _gifUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredSignData = signData
        .where((item) => item['sign_name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    final FocusNode _focusNode = FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Text to Sign Convertor',
          style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
  padding: const EdgeInsets.all(16), // Add padding for overall layout spacing
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start, // Align content at the top
    crossAxisAlignment: CrossAxisAlignment.stretch, // Make widgets fill width
    children: [
      Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage('assets/Conversion/texttosign.gif'),
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(height: 32,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButton<String>(
                value: selectedSign,
                isExpanded: true,
                hint: const Text('Dictionary'),
                items: filteredSignData.map((data) {
                  return DropdownMenuItem<String>(
                    value: data['sign_name'],
                    child: Text(data['sign_name']!),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedSign = newValue;
                  });
                },
                underline: const SizedBox(), // Remove default underline
              ),
            ),
              const SizedBox(height: 16),
              Text(
                'Enter Word:',
                style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                focusNode: _focusNode,
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your Word here...',
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed:() {
                   _fetchSign();
                   _focusNode.unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Get the sign",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sign Language Output:',
                style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[ _gifUrl != null
                      ? Image.network(_gifUrl!, height: 250, width: 200,)
                      : Text(
                    _errorMessage ?? 'Sign will be shown here',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
            ],
      ),
        ),
      ),
    );
  }
}




//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
//
// class TextToSign extends StatelessWidget {
//   const TextToSign({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           title: Text('Text to Sign Convertor',style:GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),),
//           backgroundColor: Colors.orange
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 40),
//               Container(
//                 height: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   image: DecorationImage(
//                     image: AssetImage('assets/Conversion/texttosign.gif'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 48),
//               Text(
//                 'Enter Word:',
//                 style:GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//
//               const SizedBox(height: 10),
//               const TextField(
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Type your Word here...',
//                 ),
//               ),
//               SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orangeAccent,
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: Text(
//                   "Get the sign",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 20,),
//               Text(
//                 'Sign Language Output:',
//                 style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Container(
//                 padding: EdgeInsets.all(16.0),
//                 width: double.infinity,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Sign will be shown here',
//                     style: GoogleFonts.openSans(
//                       fontSize: 16,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
