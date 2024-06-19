import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isButtonActive;
  final bool isLoading;
  final String? errorMessage;

  LoginState({
    required this.email,
    required this.password,
    required this.isPasswordVisible,
    required this.isButtonActive,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isButtonActive,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isButtonActive: isButtonActive ?? this.isButtonActive,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, isPasswordVisible, isButtonActive, isLoading, errorMessage];
}
