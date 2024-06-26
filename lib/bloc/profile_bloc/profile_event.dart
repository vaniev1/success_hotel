import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String token;

  const LoadProfile(this.token);

  @override
  List<Object?> get props => [token];
}

class Logout extends ProfileEvent {
  final VoidCallback onLogoutSuccess;

  const Logout(this.onLogoutSuccess);

  @override
  List<Object?> get props => [onLogoutSuccess];
}


class CheckOut extends ProfileEvent {
  final VoidCallback onCheckOutSuccess;

  const CheckOut(this.onCheckOutSuccess);

  @override
  List<Object?> get props => [onCheckOutSuccess];
}
