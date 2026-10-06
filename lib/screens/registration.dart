import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_search/data/auth.dart';
import 'package:product_search/models/user.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, this.authRepository});

  final AuthRepository? authRepository;

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

  late final AuthRepository _authRepository;
  late final bool _ownsRepository;
  UserRole _role = UserRole.user;
  bool _isSubmitting = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _ownsRepository = widget.authRepository == null;
    _authRepository = widget.authRepository ?? AuthRepository();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    if (_ownsRepository) _authRepository.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await _authRepository.register(
        User(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _role,
          companyName:
              _role == UserRole.company ? _companyController.text.trim() : null,
        ),
      );
      if (!mounted) return;
      setState(() {
        _successMessage = 'Account creation successful!';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error is RegistrationException
            ? error.message
            : 'Something went wrong, try again.';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  DropdownButtonFormField<UserRole>(
                    initialValue: _role,
                    decoration:
                        const InputDecoration(labelText: 'Account type'),
                    items: const [
                      DropdownMenuItem(
                        value: UserRole.user,
                        child: Text('User'),
                      ),
                      DropdownMenuItem(
                        value: UserRole.company,
                        child: Text('Company'),
                      ),
                    ],
                    onChanged: (role) {
                      if (role == null) return;
                      setState(() {
                        _role = role;
                        _errorMessage = null;
                        _successMessage = null;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    keyName: 'first-name',
                    controller: _firstNameController,
                    label: 'First name',
                    textCapitalization: TextCapitalization.words,
                    validator: _requiredValidator('Enter your first name.'),
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    keyName: 'last-name',
                    controller: _lastNameController,
                    label: 'Last name',
                    textCapitalization: TextCapitalization.words,
                    validator: _requiredValidator('Enter your last name.'),
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    keyName: 'email',
                    controller: _emailController,
                    label: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Enter your email address.';
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return 'Enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    keyName: 'password',
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: !_isPasswordVisible,
                    textInputAction: _role == UserRole.company
                        ? TextInputAction.next
                        : TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a password.';
                      }
                      if (value.length < 8) {
                        return 'Use at least 8 characters.';
                      }
                      return null;
                    },
                    suffix: IconButton(
                      tooltip: _isPasswordVisible
                          ? 'Hide password'
                          : 'Show password',
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  if (_role == UserRole.company) ...[
                    const SizedBox(height: 12),
                    _textField(
                      keyName: 'company-name',
                      controller: _companyController,
                      label: 'Company name',
                      textCapitalization: TextCapitalization.words,
                      validator: _requiredValidator('Enter your company name.'),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_successMessage != null) ...[
                    Text(_successMessage!),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required String keyName,
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextFormField(
      key: ValueKey(keyName),
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autocorrect: !obscureText,
      enableSuggestions: !obscureText,
      inputFormatters: keyboardType == TextInputType.emailAddress
          ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
          : null,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffix,
      ),
      validator: validator,
    );
  }

  String? Function(String?) _requiredValidator(String message) {
    return (value) => value == null || value.trim().isEmpty ? message : null;
  }
}
