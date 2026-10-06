import 'package:flutter/material.dart';

import 'registration_service.dart';

enum AccountType { individual, business }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.service});

  final RegistrationService service;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _businessName = TextEditingController();
  final _registrationNumber = TextEditingController();
  final _contactPerson = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  AccountType _accountType = AccountType.individual;
  bool _submitting = false;

  List<TextEditingController> get _controllers => [
    _firstName,
    _lastName,
    _businessName,
    _registrationNumber,
    _contactPerson,
    _email,
    _phone,
    _username,
    _password,
    _confirmPassword,
  ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!email.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (!RegExp(r'^\+?[0-9]{9,15}$').hasMatch(value.trim())) {
      return 'Enter a Valid Phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length < 6) return 'At least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value != _password.text) return 'Passwords do not match';
    return null;
  }

  Map<String, dynamic> _buildPayload() {
    final common = {
      'email': _email.text.trim(),
      'phone': _phone.text.trim(),
      'username': _username.text.trim(),
      'password': _password.text,
    };

    if (_accountType == AccountType.individual) {
      return {
        'accountType': 'individual',
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        ...common,
      };
    }

    return {
      'accountType': 'business',
      'company': {
        'name': _businessName.text.trim(),
        'registrationNumber': _registrationNumber.text.trim(),
      },
      'contactPerson': _contactPerson.text.trim(),
      ...common,
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final result = await widget.service.register(_buildPayload());
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account has been successfully created'),
          content: Text('Username: ${result['username']}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      _formKey.currentState?.reset();
      for (final c in _controllers) {
        c.clear();
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Try again')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndividual = _accountType == AccountType.individual;

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Account type'),
            RadioGroup<AccountType>(
              groupValue: _accountType,
              onChanged: (value) {
                if (value == null || _submitting) return;
                setState(() => _accountType = value);
              },
              child: const Column(
                children: [
                  RadioListTile(
                    value: AccountType.individual,
                    title: Text('Individual'),
                  ),
                  RadioListTile(
                    value: AccountType.business,
                    title: Text('Organisation'),
                  ),
                ],
              ),
            ),
            if (isIndividual) ...[
              TextFormField(
                controller: _firstName,
                decoration: const InputDecoration(labelText: 'First name'),
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              TextFormField(
                controller: _lastName,
                decoration: const InputDecoration(labelText: 'Last name'),
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
            ] else ...[
              TextFormField(
                controller: _businessName,
                decoration: const InputDecoration(labelText: 'Business name'),
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              TextFormField(
                controller: _registrationNumber,
                decoration: const InputDecoration(
                  labelText: 'Registration number',
                ),
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              TextFormField(
                controller: _contactPerson,
                decoration: const InputDecoration(labelText: 'Contact person'),
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
            ],
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),
            TextFormField(
              controller: _phone,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: _validatePhone,
            ),
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
              textInputAction: TextInputAction.next,
              validator: _required,
            ),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
            ),
            TextFormField(
              controller: _confirmPassword,
              decoration: const InputDecoration(labelText: 'Confirm password'),
              obscureText: true,
              validator: _validateConfirmPassword,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
