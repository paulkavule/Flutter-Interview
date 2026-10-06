import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account_type.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_state.dart';
import '../validators/registration_validators.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  final companyController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    companyController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    context.read<RegistrationBloc>().add(
      RegistrationSubmitted(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        companyName: companyController.text,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    required bool enabled,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        validator: (v) => requiredField(v, label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is RegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Account created for ${state.user.email}'),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RegistrationLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    selected: {state.accountType},
                    onSelectionChanged: (selection) => context
                        .read<RegistrationBloc>()
                        .add(AccountTypeChanged(selection.first)),
                  ),
                  const SizedBox(height: 24),
                  if (state.accountType == AccountType.business)
                    _field(
                      companyController,
                      'Company name',
                      enabled: !isLoading,
                    ),
                  _field(firstNameController, 'First name', enabled: !isLoading),
                  _field(lastNameController, 'Last name', enabled: !isLoading),
                  _field(
                    emailController,
                    'Email',
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _field(
                    passwordController,
                    'Password',
                    enabled: !isLoading,
                    obscureText: obscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
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
        },
      ),
    );
  }
}
