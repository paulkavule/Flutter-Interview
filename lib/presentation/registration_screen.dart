import 'package:flutter/material.dart';
import 'package:product_search/models/account_type.dart';
import 'package:product_search/models/user_registration_request.dart';
import 'package:product_search/models/user_registration_response.dart';


import '../services/registration_service.dart';
import '../utils/validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, RegistrationService? service})
      : _service = service;

  final RegistrationService? _service;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final RegistrationService _service =
      widget._service ?? RegistrationService();

  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _company = TextEditingController();

  AccountType _type = AccountType.individual;
  bool _obscure = true;
  bool _submitting = false;

  bool get _isBusiness => _type == AccountType.business;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _email, _password, _confirm, _company]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final user = await _service.register(
        UserRegistrationRequest(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          companyName: _isBusiness ? _company.text.trim() : null,
        ),
      );
      if (!mounted) return;
      await _showSuccess(user);
    } on RegistrationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _showSuccess(UserRegistrationResponse user) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Account created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            Text('Name: ${user.firstName} ${user.lastName}'),
            Text('Email: ${user.email}'),
            if (user.isBusiness) Text('Company: ${user.companyName}'),
            const SizedBox(height: 12),
            Text(
              'Note: DummyJSON only simulates this — the user is not saved.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _resetForm();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    for (final c in [_firstName, _lastName, _email, _password, _confirm, _company]) {
      c.clear();
    }
    setState(() => _type = AccountType.individual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
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
                    selected: {_type},
                    onSelectionChanged: _submitting
                        ? null
                        : (s) => setState(() => _type = s.first),
                  ),
                  const SizedBox(height: 24),
                  if (_isBusiness) ...[
                    TextFormField(
                      controller: _company,
                      enabled: !_submitting,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Company name',
                        prefixIcon: Icon(Icons.apartment),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => Validators.requiredName(v, 'Company name'),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstName,
                          enabled: !_submitting,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'First name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => Validators.requiredName(v, 'First name'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lastName,
                          enabled: !_submitting,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) => Validators.requiredName(v, 'Last name'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    enabled: !_submitting,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: _isBusiness ? 'Work email' : 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    enabled: !_submitting,
                    obscureText: _obscure,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: '8+ chars, upper & lower case, number, symbol',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirm,
                    enabled: !_submitting,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => Validators.confirmPassword(v, _password.text),
                  ),
                  const SizedBox(height: 28),
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
                        : Text(_isBusiness
                        ? 'Register business'
                        : 'Register'),
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
