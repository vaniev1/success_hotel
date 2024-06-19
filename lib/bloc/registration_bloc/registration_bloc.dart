import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:success_hotel/pages/Addons/booking_page.dart';
import 'package:get/get.dart';
import '../booking_bloc/booking_bloc.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(RegistrationState(
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    isButtonActive: false,
    isPasswordVisible: false,
    isLoading: false,
    errorMessage: null,
    successMessage: null,
  )) {
    on<FirstNameChanged>(_onFirstNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  void _onFirstNameChanged(FirstNameChanged event, Emitter<RegistrationState> emit) {
    final firstName = event.firstName.trim();
    final isButtonActive = _isButtonActive(firstName, state.lastName, state.email, state.password);
    emit(state.copyWith(firstName: firstName, isButtonActive: isButtonActive));
  }

  void _onLastNameChanged(LastNameChanged event, Emitter<RegistrationState> emit) {
    final lastName = event.lastName.trim();
    final isButtonActive = _isButtonActive(state.firstName, lastName, state.email, state.password);
    emit(state.copyWith(lastName: lastName, isButtonActive: isButtonActive));
  }

  void _onEmailChanged(EmailChanged event, Emitter<RegistrationState> emit) {
    final email = event.email.trim();
    final isButtonActive = _isButtonActive(state.firstName, state.lastName, email, state.password);
    emit(state.copyWith(email: email, isButtonActive: isButtonActive));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<RegistrationState> emit) {
    final password = event.password.trim();
    final isButtonActive = _isButtonActive(state.firstName, state.lastName, state.email, password);
    emit(state.copyWith(password: password, isButtonActive: isButtonActive));
  }

  void _onPasswordVisibilityChanged(PasswordVisibilityChanged event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  bool _isButtonActive(String firstName, String lastName, String email, String password) {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        email.contains('@') &&
        password.isNotEmpty &&
        password.length >= 6;
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    final response = await http.post(
      Uri.parse('https://app.successhotel.ru/api/client/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': state.firstName,
        'lastName': state.lastName,
        'email': state.email,
        'password': state.password,
        'confirmPassword': state.password,
        'guard': 'client',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        final token = responseData['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        emit(state.copyWith(isLoading: false, successMessage: 'Регистрация успешна'));
        Get.offAll(() => BlocProvider(
          create: (context) => BookingBloc(),
          child: BookingPage(),
        ));
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: responseData['error']));
      }
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'Ошибка сети, код ответа: ${response.statusCode}'));
    }
  }
}
