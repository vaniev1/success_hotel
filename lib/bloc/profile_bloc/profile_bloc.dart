import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<Logout>(_onLogout);
    on<CheckOut>(_onCheckOut);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final response = await http.get(
      Uri.parse('https://app.successhotel.ru/api/client/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${event.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final profile = data['profile'];
      final fullname = profile['full_name'] ?? '';
      final email = profile['email'] ?? '';
      emit(ProfileLoaded(fullname, email));
    } else {
      emit(ProfileError('Failed to load profile'));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<ProfileState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    emit(ProfileInitial());
    event.onLogoutSuccess();
  }

  Future<void> _onCheckOut(CheckOut event, Emitter<ProfileState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      emit(ProfileError('Token not found'));
      return;
    }

    final response = await http.get(
      Uri.parse('https://app.successhotel.ru/api/client/check-out'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        event.onCheckOutSuccess();
      } else {
        emit(ProfileError('Failed to check out'));
      }
    } else {
      emit(ProfileError('Failed to check out, status code: ${response.statusCode}'));
    }
  }
}

