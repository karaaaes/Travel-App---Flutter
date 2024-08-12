part of 'search_destination_bloc.dart';

sealed class SearchDestinationState extends Equatable {
  const SearchDestinationState();
  
  @override
  List<Object> get props => [];
}

final class SearchDestinationInitial extends SearchDestinationState {}

final class SearchDestinationLoading extends SearchDestinationState {}

final class SearchDestinationFailure extends SearchDestinationState {
  final String message;

  SearchDestinationFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class SearchDestinationLoaded extends SearchDestinationState {
  final List<DestinationEntity> data;

  const SearchDestinationLoaded({required this.data});

  @override
  // TODO: implement props
  List<Object> get props => [data];
}