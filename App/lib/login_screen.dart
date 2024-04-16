import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Hobbio/user_dashboard.dart';
import 'package:Hobbio/user_registration.dart';
import 'package:Hobbio/forgot_password.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}




class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late final String _selectedGender = '';
  bool passkey = true;
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    _progressDialog = ProgressDialog(context);
  }



Future<void> _login() async {

  try{
     _progressDialog.show();
        final FirebaseAuth auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
            );
             String? userId = userCredential.user?.uid;
        if (userId != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserDashboard(),
              ));
        } 
        else {
          _progressDialog.hide();

          print('Failed to fetch student status.');
        }
  }catch(e){
    _progressDialog.hide();
print("login error $e");
    String errorMessage = 'Login failed';
    Fluttertoast.showToast(
          msg: 'errorMessage',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomPaint(
          painter: BackgroundPainter(),
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Hobbio',
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passController,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Implement your login logic here
                          // For now, let's just print the email and password
                          print('Email: ${_emailController.text}');
                          print('Password: ${_passController.text}');
                          _login();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        elevation: MaterialStateProperty.all<double>(5),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Hobbio',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle Forgot Password tap
                            print('Forgot Password');
                             Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword(title: 'Forgot Password',),));
                          },
                          child: const Text(
                            'Forgot Password...?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 5, 106, 239),
                              fontFamily: 'Hobbio',
                              fontSize: 17
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // Handle Sign Up tap
                            print('Sign Up');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(),));
                          },
                          child: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(
                              color: Color.fromARGB(255, 5, 106, 239),
                              fontFamily: 'Hobbio',
                              fontSize: 17
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
      ),
    );

  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.blue.withOpacity(0.5);
    canvas.drawCircle(const Offset(0, 0), size.height * 0.2, paint);
    canvas.drawCircle(Offset(size.width, size.height * 0.6), size.height * 0.3, paint);

    Path path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width, size.height * 0.8);
    path.close();
    paint.color = Colors.lightBlueAccent.withOpacity(0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
