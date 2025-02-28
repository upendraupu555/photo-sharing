import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/repositories/local_auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  AuthSignUp(this.email, this.password);
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;
  AuthSignIn(this.email, this.password);
}

class AuthSignOut extends AuthEvent {}

// State
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String email;
  Authenticated(this.email);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class Unauthenticated extends AuthState {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalAuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.signUp(event.email, event.password);
        if (success) {
          emit(Authenticated(event.email));
        } else {
          emit(AuthError("Sign-up failed"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.signIn(event.email, event.password);
        if (success) {
          emit(Authenticated(event.email));
        } else {
          emit(AuthError("Invalid credentials"));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignOut>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
