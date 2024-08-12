import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/domain/usecases/get_top_destination_usecase%20.dart';

part 'top_destination_event.dart';
part 'top_destination_state.dart';

class TopDestinationBloc extends Bloc<TopDestinationEvent, TopDestinationState> {
  final GetTopDestinationUsecase _useCase; 

  TopDestinationBloc(this._useCase) : super(TopDestinationInitial()) {
    on<GetTopDestinationEvent>((event, emit) async {
      emit(TopDestinationLoading());
      final result = await _useCase();
      result.fold(
        (failure) => emit(TopDestinationFailure(message: failure.message)),
        (data) => emit(TopDestinationLoaded(data: data)),
      );
    });
  }
}
