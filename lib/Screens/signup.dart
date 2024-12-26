import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nishabdvaani/Provider/ip_provider.dart';
import 'package:nishabdvaani/Provider/tokenProvider.dart';
import 'package:nishabdvaani/Screens/signin.dart';
import 'package:nishabdvaani/Screens/tabs_screen.dart';
import 'package:nishabdvaani/Widgets/HomeScreen/welcome_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Provider/cookie_provider.dart';


class Signup extends ConsumerStatefulWidget{
  const Signup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Signup();
  }
}

class _Signup extends ConsumerState<Signup>{
  bool isPasswordVisible = false;
  final _formSignupKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ParentEmailIDController = TextEditingController();

  Future<void>signup() async{
    if(_formSignupKey.currentState?.validate()?? false){
      final name = nameController.text;
      final email = emailIDController.text;
      final password = passwordController.text;
      final gurdianEmail = ParentEmailIDController.text;
      final username = userNameController.text;


      showLoadingDialog(context);
      final ipAddress = ref.watch(ipAddressProvider);
      try {
        final response = await http.post(
          Uri.parse("http://$ipAddress:5000/students/register"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'gurdianEmail': gurdianEmail,
            'username': username,
          }
          ),
        );

        Navigator.of(context).pop();
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
              const SnackBar(content: Text("Error getting token or cookie, try again ")),
            );
            print('Token not found in response');
          }

        }
        else{
          print('Failed to signup. Status code: ${response.statusCode}');
        }
      }

      catch(e){
         Navigator.of(context).pop();
         print("Error : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to Sign up")),
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
    nameController.dispose();
    userNameController.dispose();
    emailIDController.dispose();
    passwordController.dispose();
    ParentEmailIDController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WelcomeWidget(child: Column(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
            height: 10,
          ),
        ),
        Expanded(
          flex: 12,
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
              // get started form
              child: Form(
                key: _formSignupKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: GoogleFonts.openSans(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    // full name
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Full name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Full Name'),
                        hintText: 'Enter Full Name',
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
                    //username
                    TextFormField(
                      controller: userNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Username'),
                        hintText: 'Enter Username',
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
                    // email
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
                    TextFormField(
                      controller: ParentEmailIDController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Parent \'s Email'),
                        hintText: 'Enter your parent \'s Email',
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await signup();
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
                        child: Text('Sign up', style:
                        GoogleFonts.openSans(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (e) => const SignIn(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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