import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/core/widget/loading_dialog.dart';
import 'package:chat/feature/chat/presentaion/bloc/search/search_bloc.dart';
import 'package:chat/feature/chat/presentaion/bloc/selected_user/selected_user_bloc.dart';
import 'package:chat/feature/chat/presentaion/widgets/user_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class Search extends StatefulWidget {
  final void Function()? searchOnNewUserOnPress;

  Search({
    super.key,
    this.searchOnNewUserOnPress,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // final List<User> subscribers = di.sl<AuthLocalDataSource>().getUser()!.subscribers!;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.height(),
          SizedBox(
            height: 50.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Search',
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                  fontSize: 25.sp,
                ),
              ],
            ),
          ),
          15.height(),
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: TextField(
              maxLines: 1,
              onChanged: (v) {
                BlocProvider.of<SearchBloc>(context).add(NewSearchResultEvent(searchKey: v));
              },
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: primaryColor),
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                  gapPadding: 10,
                ),
              ),
            ),
          ),
          15.height(),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is LoadedNewSearchResultState) {
                  Logger().e(state.users.length);
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return UserContainer(
                        user: state.users[index],
                        onTap: () {
                          BlocProvider.of<SelectedUserBloc>(context).add(ChangeSelectedUserEvent(
                            user: state.users[index],
                          ));
                        },
                      );
                    },
                  );
                } else if (state is LoadingSearchState) {
                  return const LoadingDialog();
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
