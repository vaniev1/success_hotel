import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class LoadServices extends ServicesEvent {}

class SelectAdditionalService extends ServicesEvent {
  final String service;

  const SelectAdditionalService(this.service);

  @override
  List<Object> get props => [service];
}

