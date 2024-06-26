import 'package:equatable/equatable.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final String? selectedService;

  const ServicesLoaded(this.selectedService);

  @override
  List<Object> get props => [selectedService ?? ''];
}
