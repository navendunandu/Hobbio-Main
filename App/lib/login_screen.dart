import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:hobbio/user_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  late String _selectedGender = '';
  bool passkey = true;
  Future<void> login() async {
    print(_emailController.text);
    print(_selectedGender);
    try{
      final FirebaseAuth auth=FirebaseAuth.instance;
      final UserCredential userCredential=await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
        );
      String userid=userCredential.user!.uid; 
      if(userid!="")
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserDashboard(),));
      }
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
                  children: [
            Text('Login Screen'),
            TextFormField(
               validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            TextFormField(
              
              validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      passkey=!passkey;
                    });
                  },
                  child: Icon(passkey
                              ? Icons.visibility_off
                              : Icons.visibility),
                ),
                hintText: 'Password',
              ),
              obscureText: passkey,
              keyboardType: TextInputType.visiblePassword,
              controller: _passController,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                              login();
                            }
                },
                child: Text('Login'))
                  ],
                ),
          ),
        ));
  }
}
