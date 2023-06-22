import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_management.dart';
import 'register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _loading = false;


  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }


  void _login() {
    if (_formKey.currentState!.validate()) {
      // Input validation passed, proceed with registration logic
      String email = _emailController.text;
      String password = _passwordController.text;

      // Add your registration logic here

      // Clear the form fields after successful registration
      _emailController.clear();
      _passwordController.clear();

      // Display a success message or navigate to the next screen
      _loginUser(email, password);
      setState(() {
        _loading = true;
      });
    }
  }

  void _loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, // Replace with the entered email
        password: password, // Replace with the entered password
      );
      // Registration successful, navigate to the home screen
      // You can replace the line below with your navigation logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeManagement()),
      );
    } catch (e) {
      // Registration failed, handle the error
      print(e.toString());
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Username atau password salah!')),
      );
      return;
    } finally {
      _loading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Berhasil Login ke Akun Dengan Email ${email}!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Center(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Aplikasi Rute Rumah Sakit Terdekat Kota Brebes',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Login Ke Akun Anda',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) => _validateEmail(value!),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) => _validatePassword(value!),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      child: Text('LOGIN'),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text('Belum Punya Akun Daftar Disini!'),
                    ),
                  ],
                ),
              ),
            ),
            if(_loading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        )
      ),
    );
  }
}
