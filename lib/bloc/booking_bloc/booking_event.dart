import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class LoadHotels extends BookingEvent {
  final String token;

  const LoadHotels(this.token);

  @override
  List<Object> get props => [token];
}

class HotelSelected extends BookingEvent {
  final String hotel;

  const HotelSelected(this.hotel);

  @override
  List<Object> get props => [hotel];
}

class RoomSelected extends BookingEvent {
  final int roomId;
  final String roomName;

  const RoomSelected(this.roomId, this.roomName);

  @override
  List<Object> get props => [roomId, roomName];
}

class DateSelected extends BookingEvent {
  final String date;

  const DateSelected(this.date);

  @override
  List<Object> get props => [date];
}

class CheckIn extends BookingEvent {
  final int roomId;
  final String checkInDate;

  const CheckIn({
    required this.roomId,
    required this.checkInDate,
  });

  @override
  List<Object> get props => [roomId, checkInDate];
}
