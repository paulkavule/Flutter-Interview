import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AccountType { individual, business }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();

  AccountType _accountType = AccountType.individual;
  bool _submitting = false;
  bool _obscurePassword = true;

  static final _endpoint = Uri.parse('https://dummyjson.com/users/add');


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }
// Validate the email
  String? _email(String? value) {
    final requiredError = _required(value, 'Email');
    if (requiredError != null) return requiredError;
    if (!value!.contains('@')) return 'Enter a valid email';
    return null;
  }

  // Validate the password
  String? _password(String? value) {
    final requiredError = _required(value, 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  // Submit the form
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final body = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };

    if (_accountType == AccountType.business) {
      body['company'] = {'name': _companyController.text.trim()};
    }

    setState(() => _submitting = true);

    try {
      final response = await http.post(
        _endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        _showMessage('Request failed (${response.statusCode})');
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final id = data['id'];
      if (_accountType == AccountType.business) {
        final companyName = _companyController.text.trim();
        _showMessage('Business "$companyName" added successfully. ID: $id');
      } else {
        final fullName = [
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
        ].join(' ');
        _showMessage(
          'Individual account for $fullName added successfully. ID: $id',
        );
      }
    } catch (error) {
      if (!mounted) return;
      _showMessage('Could not reach the API. $error');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      // Form for the registration
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<AccountType>(
              segments: const [
                ButtonSegment(
                  value: AccountType.individual,
                  label: Text('Individual'),
                ),
                ButtonSegment(
                  value: AccountType.business,
                  label: Text('Business'),
                ),
              ],
              selected: {_accountType},
              onSelectionChanged: (selected) {
                setState(() => _accountType = selected.first);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'First name'),
              validator: (value) => _required(value, 'First name'),
            ),
            TextFormField(
              controller: _lastNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Last name'),
              validator: (value) => _required(value, 'Last name'),
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: _email,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: _accountType == AccountType.business
                  ? TextInputAction.next
                  : TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              validator: _password,
            ),
            if (_accountType == AccountType.business)
              TextFormField(
                controller: _companyController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Company name'),
                validator: (value) => _required(value, 'Company name'),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
