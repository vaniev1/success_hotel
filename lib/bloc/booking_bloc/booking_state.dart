import 'package:equatable/equatable.dart';

class BookingState extends Equatable {
  final List<dynamic> hotels;
  final List<dynamic> rooms;
  final String? selectedHotel;
  final String? selectedRoom;
  final int? selectedRoomId;
  final String? selectedDate;
  final bool isButtonActive;
  final String? error;
  final String token;

  const BookingState({
    this.hotels = const [],
    this.rooms = const [],
    this.selectedHotel,
    this.selectedRoom,
    this.selectedRoomId,
    this.selectedDate,
    this.error,
    this.token = '',
    this.isButtonActive = false,
  });

  BookingState copyWith({
    List<dynamic>? hotels,
    List<dynamic>? rooms,
    String? selectedHotel,
    String? selectedRoom,
    int? selectedRoomId,
    String? selectedDate,
    String? error,
    String? token,
    bool? isButtonActive,
  }) {
    return BookingState(
      hotels: hotels ?? this.hotels,
      rooms: rooms ?? this.rooms,
      selectedHotel: selectedHotel ?? this.selectedHotel,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      selectedDate: selectedDate ?? this.selectedDate,
      isButtonActive: (selectedHotel ?? this.selectedHotel) != null &&
          (selectedRoomId ?? this.selectedRoomId) != null &&
          (selectedDate ?? this.selectedDate) != null,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [hotels, rooms, selectedHotel, selectedRoom, selectedRoomId, selectedDate, error, token, isButtonActive];
}
