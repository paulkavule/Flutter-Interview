import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/account_type.dart';
import '../../domain/entities/registration_details.dart';
import '../../domain/usecases/register_user.dart';
import 'registration_state.dart';

part 'registration_event.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({required RegisterUser registerUser})
    : _registerUser = registerUser,
      super(const RegistrationInitial()) {
    on<AccountTypeChanged>(_onAccountTypeChanged);
    on<RegistrationSubmitted>(_onSubmitted, transformer: droppable());
  }

  final RegisterUser _registerUser;

  void _onAccountTypeChanged(
    AccountTypeChanged event,
    Emitter<RegistrationState> emit,
  ) {
    if (state is RegistrationLoading ||
        event.accountType == state.accountType) {
      return;
    }
    emit(RegistrationInitial(event.accountType));
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    final accountType = state.accountType;
    emit(RegistrationLoading(accountType));
    final result = await _registerUser(
      RegistrationDetails(
        accountType: accountType,
        firstName: event.firstName.trim(),
        lastName: event.lastName.trim(),
        email: event.email.trim(),
        password: event.password,
        companyName: accountType == AccountType.business
            ? event.companyName?.trim()
            : null,
      ),
    );
    emit(
      result.fold(
        (failure) => RegistrationFailure(accountType, failure.message),
        (user) => RegistrationSuccess(accountType, user),
      ),
    );
  }
}
