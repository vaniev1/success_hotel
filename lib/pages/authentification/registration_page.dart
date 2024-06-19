import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../bloc/registration_bloc/registration_bloc.dart';
import '../../bloc/registration_bloc/registration_event.dart';
import '../../bloc/registration_bloc/registration_state.dart';
import '../addons/booking_page.dart';

Color ButtonColor = Color(0xFF15BE77);
Color UnactiveButton = Color(0x8015BE77);

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Регистрация",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      body: BlocProvider(
        create: (context) => RegistrationBloc(),
        child: BlocListener<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            } else if (state.isLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(color: ButtonColor),
                  );
                },
              );
            } else if (state.successMessage != null) {
              Navigator.of(context).pop();
              Get.off(BookingPage());
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FirstNameInput(),
                SizedBox(height: 16),
                _LastNameInput(),
                SizedBox(height: 16),
                _EmailInput(),
                SizedBox(height: 16),
                _PasswordInput(),
                SizedBox(height: 16),
                _TermsAndPrivacyText(),
                SizedBox(height: 16),
                _RegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
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
          child: TextField(
            onChanged: (firstName) =>
                context.read<RegistrationBloc>().add(FirstNameChanged(firstName.trim())),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person, color: ButtonColor),
              hintText: 'Имя',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s+|\s+$')),
            ],
          ),
        );
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
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
          child: TextField(
            onChanged: (lastName) =>
                context.read<RegistrationBloc>().add(LastNameChanged(lastName.trim())),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person, color: ButtonColor),
              hintText: 'Фамилия',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'^\s+|\s+$')),
            ],
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
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
          child: TextField(
            onChanged: (email) => context.read<RegistrationBloc>().add(EmailChanged(email)),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: ButtonColor),
              hintText: 'Почта',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
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
          child: TextField(
            obscureText: !state.isPasswordVisible,
            onChanged: (password) => context.read<RegistrationBloc>().add(PasswordChanged(password)),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: ButtonColor),
              hintText: 'Пароль',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              suffixIcon: IconButton(
                icon: Icon(
                  state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: ButtonColor,
                ),
                onPressed: () {
                  context.read<RegistrationBloc>().add(PasswordVisibilityChanged());
                },
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
            ],
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isButtonActive
              ? () {
            context.read<RegistrationBloc>().add(RegisterSubmitted());
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
            minimumSize: MaterialStateProperty.all(Size(200, 50)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          child: Text('Сохранить', style: TextStyle(color: Colors.white, fontSize: 18)),
        );
      },
    );
  }
}

class _TermsAndPrivacyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Нажимая сохранить, я соглашаюсь с ',
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: 'правилами сервиса',
              style: TextStyle(color: ButtonColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Правила сервиса')),
                  );
                },
            ),
            TextSpan(
              text: ' и ',
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: 'политикой конфиденциальности',
              style: TextStyle(color: ButtonColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Политика конфиденциальности')),
                  );
                },
            ),
            TextSpan(
              text: '.',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}