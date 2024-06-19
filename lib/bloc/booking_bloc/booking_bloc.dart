import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:success_hotel/pages/mainPages/content_view.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingState()) {
    on<LoadHotels>(_onLoadHotels);
    on<HotelSelected>(_onHotelSelected);
    on<RoomSelected>(_onRoomSelected);
    on<DateSelected>(_onDateSelected);
    on<CheckIn>(_onCheckIn);
  }

  Future<void> _onLoadHotels(LoadHotels event, Emitter<BookingState> emit) async {
    final response = await http.get(
      Uri.parse('https://app.successhotel.ru/api/client/organizations'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${event.token}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      emit(state.copyWith(hotels: responseData['organizations'], token: event.token));
    } else {
      emit(state.copyWith(error: 'Не удалось загрузить отели'));
    }
  }

  Future<void> _onHotelSelected(HotelSelected event, Emitter<BookingState> emit) async {
    emit(state.copyWith(selectedHotel: event.hotel));
    final hotel = state.hotels.firstWhere((hotel) => hotel['title'] == event.hotel);
    final hotelId = hotel['id'];

    final response = await http.get(
      Uri.parse('https://app.successhotel.ru/api/client/organizations/$hotelId/rooms'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${state.token}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      emit(state.copyWith(rooms: responseData['rooms']));
      //print(responseData.toString());
    } else {
      emit(state.copyWith(error: 'Не удалось загрузить номера'));
    }
    _checkButtonState(emit);
  }

  void _onRoomSelected(RoomSelected event, Emitter<BookingState> emit) {
    emit(state.copyWith(selectedRoomId: event.roomId, selectedRoom: event.roomName));
    _checkButtonState(emit);
  }

  void _onDateSelected(DateSelected event, Emitter<BookingState> emit) {
    emit(state.copyWith(selectedDate: event.date));
    _checkButtonState(emit);
  }

  void _checkButtonState(Emitter<BookingState> emit) {
    final isActive = state.selectedHotel != null && state.selectedRoomId != null && state.selectedDate != null;
    emit(state.copyWith(isButtonActive: isActive));
  }

  Future<void> _onCheckIn(CheckIn event, Emitter<BookingState> emit) async {
    final payload = {
      'room_id': event.roomId,
      'chek_in_date': event.checkInDate,
    };
    //print('Check-in payload: $payload');

    final response = await http.post(
      Uri.parse('https://app.successhotel.ru/api/client/check-in'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${state.token}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      //final responseData = jsonDecode(response.body);
      //print('Response data: $responseData');
      Get.offAll(() => BlocProvider(
        create: (context) => BookingBloc(),
        child: ContentView(),
      ));
    } else {
      print('Failed to check in. Status code: ${response.statusCode}');
    }
  }
}
