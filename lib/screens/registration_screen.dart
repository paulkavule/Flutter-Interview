import 'package:flutter/material.dart';

import '../api/registration_api.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.api});

  final RegistrationApi api;

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
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  bool get _isBusiness => _accountType == AccountType.business;

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
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  String? _validateEmail(String? value) {
    final error = _required(value, 'Email');
    if (error != null) return error;
    if (!value!.trim().contains("@") || !value.trim().contains(".")) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final request = RegistrationRequest(
      accountType: _accountType,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      companyName: _isBusiness ? _companyController.text.trim() : null,
    );

    try {
      final id = await widget.api.register(request);
      if (!mounted) return;
      _formKey.currentState!.reset();
      for (final controller in [
        _firstNameController,
        _lastNameController,
        _emailController,
        _passwordController,
        _companyController,
      ]) {
        controller.clear();
      }
      _showMessage('Account created (ID: $id)');
    } on RegistrationException catch (e) {
      if (!mounted) return;
      _showMessage(e.message, isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colors.error : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<AccountType>(
                segments: const [
                  ButtonSegment(
                    value: AccountType.individual,
                    label: Text('Individual'),
                    icon: Icon(Icons.person),
                  ),
                  ButtonSegment(
                    value: AccountType.business,
                    label: Text('Business'),
                    icon: Icon(Icons.business),
                  ),
                ],
                selected: {_accountType},
                onSelectionChanged: _isSubmitting
                    ? null
                    : (selection) =>
                        setState(() => _accountType = selection.first),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstNameController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(labelText: 'First name'),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.givenName],
                validator: (value) => _required(value, 'First name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(labelText: 'Last name'),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.familyName],
                validator: (value) => _required(value, 'Last name'),
              ),
              if (_isBusiness) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyController,
                  enabled: !_isSubmitting,
                  decoration: const InputDecoration(labelText: 'Company name'),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.organizationName],
                  validator: (value) => _required(value, 'Company name'),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                enabled: !_isSubmitting,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: _validatePassword,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
