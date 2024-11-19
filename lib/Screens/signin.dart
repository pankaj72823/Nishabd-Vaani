import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nishabdvaani/Provider/cookie_provider.dart';
import 'package:nishabdvaani/Screens/signup.dart';
import 'package:nishabdvaani/Widgets/HomeScreen/welcome_widget.dart';
import 'package:nishabdvaani/Screens/tabs_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:nishabdvaani/Provider/tokenProvider.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignIn();
}

class _SignIn extends ConsumerState<SignIn> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController emailIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  Future<void>signin() async{
    if(_formSignInKey.currentState?.validate()?? false){
      final email = emailIDController.text;
      final password = passwordController.text;
      showLoadingDialog(context);
      final ipAddress = ref.watch(ipAddressProvider);
      try {
        final response = await http.post(
          Uri.parse("http://$ipAddress:5000/students/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }
          ),
        );
        // Navigator.of(context).pop();
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final cookie = response.headers['set-cookie']
              ?.split(';')
              .firstWhere((cookie) => cookie.trim().startsWith('connect.sid='));
          print(cookie);

          // print('connect.sid: $cookie');
          // final cookie = response.headers['set-cookie'];
          // print(response.headers);
          // print(cookie);
          if(cookie!=null) await ref.read(cookieProvider.notifier).saveCookie(cookie);

          if(data['token']!=null) {
            final token = data['token'];
            print(token);
            ref.read(tokenProvider.notifier).state = token;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => TabsScreen()
              ),
            );
          } else{
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to Signin, try again ")),
            );
            print('Token not found in response');
          }
        }
        else{
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to Signin, try again ")),
          );
          print('Failed to signin. Status code: ${response.statusCode}');
        }
      }

      catch(e){
        Navigator.of(context).pop();
        print("Error : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to Signin, try again ")),
        );
      }

    }
  }

  void showLoadingDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(
          child: CircularProgressIndicator(),
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailIDController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WelcomeWidget(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: emailIDController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility:
                                Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;

                                });
                              },
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async{
                            await signin();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (ctx) => TabsScreen()
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            backgroundColor: Colors.yellow[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Sign in', style:
                          GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const Signup(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}