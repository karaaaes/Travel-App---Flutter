import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_app/features/destination/domain/entities/destination_entity.dart';
import 'package:travel_app/features/destination/domain/usecases/search_destination_usecase%20.dart';

part 'search_destination_event.dart';
part 'search_destination_state.dart';

class SearchDestinationBloc extends Bloc<SearchDestinationEvent, SearchDestinationState> {
  final SearchDestinationUsecase _useCase;

  SearchDestinationBloc(this._useCase) : super(SearchDestinationInitial()) {
    on<GetSearchDestinationEvent>((event, emit) async {
      emit(SearchDestinationLoading());
      final result = await _useCase(query: event.query);
      result.fold(
        (failure) => emit(SearchDestinationFailure(message: failure.message)),
        (data) => emit(SearchDestinationLoaded(data: data))
        );
    });
  }
}
