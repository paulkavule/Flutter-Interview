import 'package:flutter/material.dart';

import '../data/registered_user.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key, required this.user, required this.onDone});

  final RegisteredUser user;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            Text(
              'Account created',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('ID: ${user.id}'),
            Text(user.fullName),
            Text(user.email),
            if (user.company?.name.isNotEmpty ?? false)
              Text(user.company!.name),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onDone,
              child: const Text('Register another account'),
            ),
          ],
        ),
      ),
    );
  }
}
