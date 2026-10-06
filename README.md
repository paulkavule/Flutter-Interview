# Registration Form - Question 2

Registration screen for individual and business accounts that submits valid
data to the DummyJSON API using Dio. Built with clean architecture and Bloc.

## Setup

```bash
flutter create . --project-name registration_form
flutter pub get
flutter run
```

`flutter create .` generates the platform folders; it does not overwrite `lib/`.

## API

| Item | Value |
| --- | --- |
| Method | `POST` |
| URL | `https://dummyjson.com/users/add` |
| Content type | `application/json` |
| Success | `201` with the submitted user and a new `id` (not persisted) |
| Error | `4xx` with `{"message": "..."}` |

Business accounts also send `company: { "name": ... }`.

## Structure

```
lib/
  core/
    di/injection.dart              get_it wiring
    error/                         exceptions (data) and failures (domain)
    network/                       Dio client and DioException mapper
    usecase/usecase.dart           UseCase<T, Params> returning Either<Failure, T>
  features/registration/
    data/                          remote data source, models, repository impl
    domain/                        entities, repository contract, RegisterUser use case
    presentation/                  RegistrationBloc, RegistrationPage, validators
  main.dart
```

- The company name field is shown and required only for business accounts.
- Submits use `droppable()`, so repeat taps while a request is in flight are ignored.
