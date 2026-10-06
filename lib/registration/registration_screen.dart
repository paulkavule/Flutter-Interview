import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'registration_api.dart';
import 'registration_models.dart';
import 'validators.dart';

/// Registration for individual and business accounts.
///
/// Validation runs locally first; only valid data reaches [api]. Errors stay
/// silent until the first submit attempt, then update live as the user types.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.api});

  final RegistrationApi api;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _company = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  AccountType _accountType = AccountType.individual;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool _submitting = false;
  bool _obscurePassword = true;
  String? _message;
  bool _isSuccess = false;

  bool get _isBusiness => _accountType == AccountType.business;

  List<TextEditingController> get _controllers => [
    _firstName,
    _lastName,
    _company,
    _email,
    _password,
    _confirm,
  ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }
    setState(() {
      _submitting = true;
      _message = null;
    });

    final request = RegistrationRequest(
      accountType: _accountType,
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim().toLowerCase(),
      password: _password.text,
      companyName: _isBusiness ? _company.text.trim() : null,
    );

    String message;
    var success = false;
    try {
      final user = await widget.api.register(request);
      final owner = user.companyName == null ? '' : ' for ${user.companyName}';
      message =
          'Welcome, ${user.firstName}. Account #${user.id}$owner was created.';
      success = true;
    } on RegistrationException catch (e) {
      message = e.message;
    } catch (_) {
      message = 'Something went wrong. Please try again.';
    }

    if (!mounted) return;
    setState(() {
      _submitting = false;
      _message = message;
      _isSuccess = success;
      if (success) {
        for (final c in _controllers) {
          c.clear();
        }
        _formKey.currentState!.reset();
        _autovalidate = AutovalidateMode.disabled;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 14);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidate,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'One profile for yourself, or one for your whole business.',
                        style: TextStyle(color: AppColors.muted),
                      ),
                      const SizedBox(height: 28),
                      _accountTypeSelector(),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _field(
                              _firstName,
                              'First name',
                              AutofillHints.givenName,
                              (v) => Validators.name(v, field: 'First name'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _field(
                              _lastName,
                              'Last name',
                              AutofillHints.familyName,
                              (v) => Validators.name(v, field: 'Last name'),
                            ),
                          ),
                        ],
                      ),
                      if (_isBusiness) ...[
                        gap,
                        _field(
                          _company,
                          'Company name',
                          AutofillHints.organizationName,
                          Validators.company,
                        ),
                      ],
                      gap,
                      _field(
                        _email,
                        _isBusiness ? 'Work email' : 'Email',
                        AutofillHints.email,
                        Validators.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      gap,
                      _field(
                        _password,
                        'Password',
                        AutofillHints.newPassword,
                        Validators.password,
                        obscure: _obscurePassword,
                        suffix: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.muted,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      gap,
                      _field(
                        _confirm,
                        'Confirm password',
                        AutofillHints.newPassword,
                        (v) => Validators.confirmPassword(v, _password.text),
                        obscure: _obscurePassword,
                        isLast: true,
                      ),
                      const SizedBox(height: 24),
                      if (_message != null) ...[
                        Text(
                          _message!,
                          style: TextStyle(
                            color: _isSuccess
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: AppColors.paper,
                                ),
                              )
                            : Text(
                                'Create ${_accountType.label.toLowerCase()} account',
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountTypeSelector() {
    return Row(
      children: [
        for (final type in AccountType.values)
          Expanded(
            child: Semantics(
              button: true,
              selected: type == _accountType,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _submitting
                    ? null
                    : () => setState(() => _accountType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: type == _accountType
                            ? AppColors.ink
                            : AppColors.hairline,
                        width: type == _accountType ? 2 : 1,
                      ),
                    ),
                  ),
                  child: Text(
                    type.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: type == _accountType
                          ? AppColors.ink
                          : AppColors.muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String autofill,
    FormFieldValidator<String> validator, {
    TextInputType? keyboardType,
    bool obscure = false,
    bool isLast = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_submitting,
      validator: validator,
      obscureText: obscure,
      autocorrect: !obscure && keyboardType == null,
      keyboardType: keyboardType,
      autofillHints: [autofill],
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: isLast ? (_) => _submit() : null,
      decoration: InputDecoration(labelText: label, suffixIcon: suffix),
    );
  }
}
