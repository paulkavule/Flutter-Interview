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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _businessNameController = TextEditingController();
  AccountType _accountType = AccountType.individual;
  bool _isSubmitting = false;
  String? _feedback;
  bool _requestSucceeded = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _feedback = null;
    });

    final payload = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'username': _usernameController.text.trim(),
      'password': _passwordController.text,
      'accountType': _accountType.name,
      if (_accountType == AccountType.business)
        'companyName': _businessNameController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/users/add'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (!mounted) return;
      setState(() {
        _requestSucceeded =
            response.statusCode >= 200 && response.statusCode < 300;
        _feedback = _requestSucceeded
            ? 'Your account is ready. Welcome aboard!'
            : 'We could not create your account. Please try again.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _requestSucceeded = false;
        _feedback = 'Connection failed. Check your internet and try again.';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create your account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF18352F),
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose the account that fits the way you work.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xFF69766F)),
              ),
              const SizedBox(height: 22),
              SegmentedButton<AccountType>(
                segments: const [
                  ButtonSegment(
                    value: AccountType.individual,
                    label: Text('Individual'),
                    icon: Icon(Icons.person_outline),
                  ),
                  ButtonSegment(
                    value: AccountType.business,
                    label: Text('Business'),
                    icon: Icon(Icons.storefront_outlined),
                  ),
                ],
                selected: {_accountType},
                onSelectionChanged: (selection) => setState(() {
                  _accountType = selection.first;
                  _feedback = null;
                }),
              ),
              const SizedBox(height: 22),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_accountType == AccountType.business) ...[
                      _field(
                        controller: _businessNameController,
                        label: 'Business name',
                        icon: Icons.business_outlined,
                      ),
                      const SizedBox(height: 14),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            controller: _firstNameController,
                            label: 'First name',
                            icon: Icons.badge_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            controller: _lastNameController,
                            label: 'Last name',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _emailController,
                      label: 'Email address',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your email address';
                        }
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(value.trim())) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.alternate_email,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) => value == null || value.length < 6
                          ? 'Use at least 6 characters'
                          : null,
                    ),
                    if (_feedback != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _feedback!,
                        style: TextStyle(
                          color: _requestSucceeded
                              ? const Color(0xFF176B5B)
                              : const Color(0xFFB33B32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF176B5B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Create account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator ??
          (value) => value == null || value.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon, size: 20),
      ),
    );
  }
}
