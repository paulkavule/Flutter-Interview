import 'package:flutter/material.dart';
import 'package:product_search/data/services/api_service.dart';

import '../shared_widgets/CustomInput.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _api.registerUser(
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          _passwordController.text,
          {},
        );
        print(response);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register as:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    RadioListTile(
                      title: const Text('Individual'),
                      value: 'individual',
                      groupValue: 'individual',
                      onChanged: (value) {},
                    ),
                    RadioListTile(
                      title: const Text('Company'),
                      value: 'company',
                      groupValue: 'company',
                      onChanged: (value) {},
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                CustomInput(
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  obscureText: false,
                ),
                SizedBox(height: 10.0),
                CustomInput(
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  obscureText: false,
                ),
                SizedBox(height: 10.0),
                CustomInput(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  obscureText: false,
                ),
                SizedBox(height: 10.0),
                CustomInput(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                ),

                SizedBox(height: 16.0),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    _registerUser();
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
