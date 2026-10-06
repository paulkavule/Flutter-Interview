import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/register_user.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUser _registerUser;

  RegistrationBloc({required RegisterUser registerUser})
      : _registerUser = registerUser,
        super(const RegistrationState()) {
    on<RegistrationAccountTypeChanged>(_onAccountTypeChanged);
    on<RegistrationSubmitted>(_onSubmitted);
  }

  void _onAccountTypeChanged(
    RegistrationAccountTypeChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(accountType: event.accountType));
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(
      status: RegistrationStatus.loading,
      errorMessage: null,
    ));

    try {
      final response = await _registerUser(event.payload);
      emit(state.copyWith(
        status: RegistrationStatus.success,
        createdUserId: response['id'],
      ));
    } catch (e) {
      final cleanMessage = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: cleanMessage,
      ));
    }
  }
}
