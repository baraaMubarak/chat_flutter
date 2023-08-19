import 'package:bloc/bloc.dart';
import 'package:chat/core/api/socket_controller.dart';
import 'package:chat/feature/auth/data/model/user.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is NewSearchResultEvent) {
        emit(LoadingSearchState());
        await SocketController.getInstance().search(
            searchKey: event.searchKey,
            ack: (data) async {
              if (data['status'] == 200) {
                final usersList = data['users'] as List<dynamic>;
                final users = usersList.map((e) => UserModel.fromJson(Map<String, dynamic>.from(e))).toList();
                emit(
                  LoadedNewSearchResultState(
                    users: users,
                  ),
                );
              } else {
                emit(ErrorSearchState(message: 'Un Expected Error In Socket'));
              }
            });
      }
    });
  }
}
