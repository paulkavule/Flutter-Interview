import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';
import '../data/models/registration_payload.dart';
import 'widgets/account_type_selector.dart';
import 'widgets/app_text_field.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _submitForm(AccountType accountType) {
    if (!_formKey.currentState!.validate()) return;

    final payload = RegistrationPayload(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      accountType: accountType,
      companyName: accountType == AccountType.business
          ? _companyController.text.trim()
          : null,
    );

    context.read<RegistrationBloc>().add(RegistrationSubmitted(payload));
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Account'),
      ),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status == RegistrationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Registration failed'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state.status == RegistrationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Registration successful! (Created User ID: ${state.createdUserId})',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == RegistrationStatus.loading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AccountTypeSelector(
                    selectedType: state.accountType,
                    enabled: !isLoading,
                    onTypeChanged: (type) {
                      context.read<RegistrationBloc>().add(
                            RegistrationAccountTypeChanged(type),
                          );
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'First Name',
                    controller: _firstNameController,
                    enabled: !isLoading,
                    validator: (v) => _validateRequired(v, 'First name'),
                  ),
                  AppTextField(
                    label: 'Last Name',
                    controller: _lastNameController,
                    enabled: !isLoading,
                    validator: (v) => _validateRequired(v, 'Last name'),
                  ),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                    validator: _validateEmail,
                  ),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    enabled: !isLoading,
                    validator: _validatePassword,
                  ),
                  if (state.accountType == AccountType.business) ...[
                    AppTextField(
                      label: 'Company Name',
                      controller: _companyController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      validator: (v) => _validateRequired(v, 'Company name'),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : () => _submitForm(state.accountType),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit Registration',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
