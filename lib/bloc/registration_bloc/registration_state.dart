import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool isButtonActive;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const RegistrationState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.isButtonActive,
    required this.isPasswordVisible,
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  RegistrationState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    bool? isButtonActive,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return RegistrationState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      isButtonActive: isButtonActive ?? this.isButtonActive,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    isButtonActive,
    isPasswordVisible,
    isLoading,
    errorMessage,
    successMessage,
  ];
}
