import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:registration_form/screens/registration_screen.dart';
import 'package:registration_form/services/api_service.dart';

ApiService mockApi({int statusCode = 200, Map<String, dynamic>? response}) {
  return ApiService(
    client: MockClient((request) async {
      return http.Response(
        jsonEncode(response ?? {}),
        statusCode,
        headers: {'content-type': 'application/json'},
      );
    }),
  );
}

Widget app(ApiService api) {
  return MaterialApp(home: RegistrationScreen(api: api));
}

Future<void> fillForm(WidgetTester tester) async {
  final fields = find.byType(TextFormField);

  await tester.enterText(fields.at(0), 'Jane');
  await tester.enterText(fields.at(1), 'Doe');
  await tester.enterText(fields.at(2), 'jane@example.com');
  await tester.enterText(fields.at(3), 'Test1234!');
}

void main() {
  testWidgets('shows validation errors', (tester) async {
    await tester.pumpWidget(app(mockApi()));

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('First name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('shows company field for business', (tester) async {
    await tester.pumpWidget(app(mockApi()));

    expect(find.text('Company name'), findsNothing);

    await tester.tap(find.text('Business'));
    await tester.pump();

    expect(find.text('Company name'), findsOneWidget);
  });

  testWidgets('registers successfully', (tester) async {
    final api = mockApi(
      response: {
        'id': 1,
        'firstName': 'Jane',
        'lastName': 'Doe',
        'email': 'jane@example.com',
      },
    );

    await tester.pumpWidget(app(api));

    await fillForm(tester);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Account created'), findsOneWidget);
  });

  testWidgets('shows error when registration fails', (tester) async {
    await tester.pumpWidget(app(mockApi(statusCode: 500)));

    await fillForm(tester);

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(
      find.text('Registration failed (HTTP 500). Please try again.'),
      findsOneWidget,
    );
  });
}
