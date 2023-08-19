part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class NewSearchResultEvent extends SearchEvent {
  final String searchKey;

  NewSearchResultEvent({required this.searchKey});
}
