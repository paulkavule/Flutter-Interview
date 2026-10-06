import 'package:flutter/material.dart';

import 'message_view.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.search_off,
      text: query.isEmpty
          ? 'No products available'
          : 'No products match "$query"',
    );
  }
}
