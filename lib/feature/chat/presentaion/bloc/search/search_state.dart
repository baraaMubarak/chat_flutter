part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class LoadedNewSearchResultState extends SearchState {
  final List<User> users;

  LoadedNewSearchResultState({required this.users});
}

class ErrorSearchState extends SearchState {
  final String message;

  ErrorSearchState({required this.message});
}

class LoadingSearchState extends SearchState {}
