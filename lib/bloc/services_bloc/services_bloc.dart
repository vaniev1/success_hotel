import 'package:bloc/bloc.dart';
import 'services_event.dart';
import 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc() : super(ServicesInitial()) {
    on<LoadServices>(_onLoadServices);
    on<SelectAdditionalService>(_onSelectAdditionalService);
  }

  void _onLoadServices(LoadServices event, Emitter<ServicesState> emit) async {
    emit(ServicesLoading());
    emit(ServicesLoaded(null));
  }

  void _onSelectAdditionalService(SelectAdditionalService event, Emitter<ServicesState> emit) {
    emit(ServicesLoaded(event.service));
  }
}

