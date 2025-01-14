// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_destination_bloc.dart';

sealed class SearchDestinationEvent extends Equatable {
  const SearchDestinationEvent();

  @override
  List<Object> get props => [];
}

class GetSearchDestinationEvent extends SearchDestinationEvent {
  // Body yang dikirim
  final String query;

  GetSearchDestinationEvent({
    required this.query,
  });

  @override
  // TODO: implement props
  List<Object> get props => [query];
}

class GetSearhDestinationInitial extends SearchDestinationEvent{}
