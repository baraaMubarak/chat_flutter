import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/feature/chat/presentaion/widgets/tab_bar/diplay_subscribers.dart';
import 'package:chat/feature/chat/presentaion/widgets/tab_bar/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarForHome extends StatefulWidget {
  const TabBarForHome({Key? key}) : super(key: key);

  @override
  _TabBarForHomeState createState() => _TabBarForHomeState();
}

class _TabBarForHomeState extends State<TabBarForHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabBarWidgets = [
      DisplaySubscribers(
        searchOnNewUserOnPress: () {
          setState(() {
            _tabController.index = 3;
          });
        },
      ),
      const Text('A'),
      const Text('B'),
      Search(),
      const Text('D'),
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Container(
            height: 55.h,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  blurStyle: BlurStyle.outer,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Expanded(child: Container()),
                TabBar(
                  onTap: (value) {
                    setState(() {
                      _tabController;
                    });
                  },
                  controller: _tabController,
                  unselectedLabelColor: Colors.grey,
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  tabs: <Widget>[
                    const Tab(
                      icon: Icon(Icons.chat),
                    ),
                    const Tab(
                      icon: Icon(Icons.phone),
                    ),
                    const Tab(
                      icon: Icon(Icons.notifications_sharp),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.people,
                        color: _tabController.index == 3 ? primaryColor : Colors.grey,
                      ),
                    ),
                    const Tab(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('https://png.pngtree.com/png-vector/20220623/ourmid/pngtree-user-avatar-icon-profile-silhouette-png-image_5173766.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: tabBarWidgets[_tabController.index],
    );
  }
}
