import 'package:flutter/material.dart';
import '../widgets/login_form.dart'; 

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: LoginForm(), 
        ),
      ),
    );
  }
}
