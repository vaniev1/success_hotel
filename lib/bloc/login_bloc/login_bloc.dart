import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:success_hotel/pages/Addons/booking_page.dart';
import 'package:success_hotel/pages/mainPages/content_view.dart';
import 'package:success_hotel/bloc/booking_bloc/booking_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(LoginState(
    email: '',
    password: '',
    isPasswordVisible: false,
    isButtonActive: false,
  )) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final email = event.email;
    final isButtonActive = _isButtonActive(email, state.password);
    emit(state.copyWith(email: email, isButtonActive: isButtonActive));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password = event.password;
    final isButtonActive = _isButtonActive(state.email, password);
    emit(state.copyWith(password: password, isButtonActive: isButtonActive));
  }

  void _onPasswordVisibilityChanged(PasswordVisibilityChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final response = await http.post(
      Uri.parse('https://app.successhotel.ru/api/client/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': state.email,
        'password': state.password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        final token = responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await _loadUserProfile(token, emit);
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Ошибка авторизации: ${responseData['error']}"));
      }
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: "Ошибка сети, код ответа: ${response.statusCode}"));
    }
  }

  Future<void> _loadUserProfile(String token, Emitter<LoginState> emit) async {
    final profileResponse = await http.get(
      Uri.parse('https://app.successhotel.ru/api/client/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (profileResponse.statusCode == 200) {
      final profileData = jsonDecode(profileResponse.body);
      if (profileData['success'] == true) {
        final currentClientRoom = profileData['profile']['current_client_room'];
        emit(state.copyWith(isLoading: false));
        if (currentClientRoom == null) {
          Get.offAll(() => BlocProvider(
            create: (context) => BookingBloc(),
            child: BookingPage(),
          ));
        } else {
          Get.offAll(ContentView());
        }
      } else {
        emit(state.copyWith(isLoading: false, errorMessage: "Ошибка загрузки профиля: ${profileData['error']}"));
      }
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: "Ошибка сети, код ответа: ${profileResponse.statusCode}"));
    }
  }

  bool _isButtonActive(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty && email.contains('@') && password.length >= 6;
  }
}
