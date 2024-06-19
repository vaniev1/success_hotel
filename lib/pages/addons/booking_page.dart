import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import '../../bloc/booking_bloc/booking_bloc.dart';
import '../../bloc/booking_bloc/booking_event.dart';
import '../../bloc/booking_bloc/booking_state.dart';

Color ButtonColor = Color(0xFF15BE77);
Color UnactiveButton = Color(0x8015BE77);

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late String token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
    if (token.isNotEmpty) {
      context.read<BookingBloc>().add(LoadHotels(token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Заезд',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HotelDropdown(selectedValue: state.selectedHotel),
                SizedBox(height: 16),
                _RoomDropdown(selectedValue: state.selectedRoom),
                SizedBox(height: 16),
                _DateTimePickerField(),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: state.isButtonActive
                      ? () {
                          print('Selected hotel: ${state.selectedHotel}');
                          print('Selected room ID: ${state.selectedRoomId}');
                          print('Selected date: ${state.selectedDate}');
                          context.read<BookingBloc>().add(
                                CheckIn(
                                  roomId: state.selectedRoomId!,
                                  checkInDate: state.selectedDate!,
                                ),
                              );
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return UnactiveButton;
                        }
                        return ButtonColor;
                      },
                    ),
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 50)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: Text('Готово', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 32),
                Center(
                  child: Text(
                    'или',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    //Тут переход на страницу с QR кодом
                  },
                  icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Сканировать QR',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ButtonColor,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HotelDropdown extends StatelessWidget {
  final String? selectedValue;

  _HotelDropdown({this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        List<String> hotelNames =
            state.hotels.map((hotel) => hotel['title'] as String).toList();
        return _DropdownField(
          icon: Icons.hotel,
          hintText: 'Ваш отель',
          items: hotelNames,
          selectedValue: selectedValue,
          onChanged: (value) {
            context.read<BookingBloc>().add(HotelSelected(value));
          },
        );
      },
    );
  }
}

class _RoomDropdown extends StatelessWidget {
  final String? selectedValue;

  _RoomDropdown({this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        List<String> roomNames =
            state.rooms.map((room) => room['name'] as String).toList();
        return _DropdownField(
          icon: Icons.room,
          hintText: 'Номер',
          items: roomNames,
          selectedValue: selectedValue,
          onChanged: (value) {
            final room =
                state.rooms.firstWhere((room) => room['name'] == value);
            context.read<BookingBloc>().add(RoomSelected(room['id'], value));
          },
        );
      },
    );
  }
}

class _DateTimePickerField extends StatefulWidget {
  @override
  __DateTimePickerFieldState createState() => __DateTimePickerFieldState();
}

class __DateTimePickerFieldState extends State<_DateTimePickerField> {
  String _selectedDate = 'Выберите дату';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.date_range, color: Colors.green),
        title: Text(_selectedDate, style: TextStyle(color: Colors.grey)),
        onTap: () {
          DatePicker.showDatePicker(
            context,
            onConfirm: (dateTime, List<int> index) {
              setState(() {
                _selectedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
              });
              context.read<BookingBloc>().add(DateSelected(dateTime.toIso8601String()));
            },
            locale: DateTimePickerLocale.ru,
            dateFormat: 'yyyy-MM-dd HH:mm',
            pickerTheme: DateTimePickerTheme(
              showTitle: true,
              confirm: Text('Готово', style: TextStyle(color: ButtonColor)),
              cancel: Text('Отмена', style: TextStyle(color: Colors.red)),
            ),
          );
        },
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final List<String> items;
  final Function(String) onChanged;
  final String? selectedValue;

  _DropdownField({
    required this.icon,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          prefixIcon:
              selectedValue == null ? Icon(icon, color: Colors.green) : null,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        ),
        borderRadius: BorderRadius.circular(12),
        iconEnabledColor: Colors.green,
        iconDisabledColor: Colors.grey,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(icon, color: ButtonColor),
                SizedBox(width: 12),
                Text(value),
              ],
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          onChanged(newValue!);
        },
      ),
    );
  }
}
