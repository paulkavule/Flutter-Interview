# registration_form

A Flutter registration screen for **individual** and **business** accounts.
Valid data is submitted to the [DummyJSON](https://dummyjson.com/docs/users#users-add)
users API (`POST https://dummyjson.com/users/add`), which simulates user
creation and returns the submitted data with a generated ID.

## Features

- Account type toggle (Individual / Business) with a company name field shown
  only for business accounts.
- Client-side validation: required fields, email format, and password strength
  (min 8 characters with upper/lowercase, a number and a symbol).
- Submission to the DummyJSON API via the `http` package, with loading state,
  timeout handling and friendly error messages.
- Success dialog showing the data returned by the API, including the new ID.

## Structure

```
lib/
  main.dart                        # App entry point
  models/
    account_type.dart              # Individual / Business enum
    company.dart                   # Company payload for business accounts
    user.dart                      # Registration request/response model
  services/
    api_service.dart               # DummyJSON API client (http)
  screens/
    registration_screen.dart       # The registration form
```

## Running

```sh
flutter pub get
flutter run
```

## Testing

Widget tests use `MockClient` from `package:http/testing` to verify
validation, the business/individual payload shapes, and error handling
without hitting the network.

```sh
flutter test
```
