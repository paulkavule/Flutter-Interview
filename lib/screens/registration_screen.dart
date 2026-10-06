import 'package:flutter/material.dart';

import '../models/account_type.dart';
import '../models/company.dart';
import '../models/user.dart';
import '../services/api_service.dart';

/// Registration form for individual and business accounts.
///
/// Valid data is submitted to the DummyJSON users API via [ApiService].
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Denis RegEx for widgets that don't support it
  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp _hasUpper = RegExp(r'[A-Z]');
  static final RegExp _hasLower = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'\d');
  static final RegExp _hasSpecial = RegExp(r'[^A-Za-z0-9]');

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();

  AccountType _accountType = AccountType.individual;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool _submitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final required = _validateRequired(value, 'Email');
    if (required != null) return required;
    if (!_emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final required = _validateRequired(value, 'Password');
    if (required != null) return required;
    if (value!.length < 8) return 'Password must be at least 8 characters';
    if (!_hasUpper.hasMatch(value)) {
      return 'Password needs an uppercase letter';
    }
    if (!_hasLower.hasMatch(value)) {
      return 'Password needs a lowercase letter';
    }
    if (!_hasDigit.hasMatch(value)) return 'Password needs a number';
    if (!_hasSpecial.hasMatch(value)) {
      return 'Password needs a special character';
    }
    return null;
  }

  String? _validateCompany(String? value) =>
      _validateRequired(value, 'Company name');

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.always);
      return;
    }

    final user = User(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      company: _accountType == AccountType.business
          ? Company(name: _companyController.text.trim())
          : null,
    );

    setState(() => _submitting = true);
    try {
      final created = await widget.api.registerUser(user);
      if (!mounted) return;
      _showSuccessDialog(created);
    } on ApiException catch (error) {
      if (!mounted) return;
      _showError(error.message);
    } catch (_) {
      if (!mounted) return;
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSuccessDialog(User user) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Account created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'ID', value: '#${user.id}'),
            _DetailRow(
              label: 'Name',
              value: '${user.firstName} ${user.lastName}',
            ),
            _DetailRow(label: 'Email', value: user.email),
            _DetailRow(label: 'Account', value: _accountType.label),
            if (user.company != null)
              _DetailRow(label: 'Company', value: user.company!.name),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Done'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _resetForm();
            },
            child: const Text('Register another'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      _autovalidate = AutovalidateMode.disabled;
      _accountType = AccountType.individual;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create your account',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _accountType.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
                        icon: Icon(Icons.business_outlined),
                      ),
                    ],
                    selected: {_accountType},
                    onSelectionChanged: (selection) {
                      if (_submitting) return;
                      setState(() => _accountType = selection.first);
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        _validateRequired(value, 'First name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateRequired(value, 'Last name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: _accountType == AccountType.business
                        ? TextInputAction.next
                        : TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText:
                          'At least 8 characters with upper/lowercase, a number and a symbol',
                      helperMaxLines: 2,
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  if (_accountType == AccountType.business) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _companyController,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Company name',
                        prefixIcon: Icon(Icons.business_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateCompany,
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single label/value row used in the success dialog.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
