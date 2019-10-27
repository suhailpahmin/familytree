import 'package:familytree/ui/main/business/business.dart';
import 'package:familytree/ui/main/family/family.dart';
import 'package:familytree/ui/main/lounge/lounge.dart';
import 'package:familytree/ui/main/pictories/pictories.dart';
import 'package:familytree/ui/main/profile/profile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Widget> _children = [
    FamilyScreen(),
    PictoriesScreen(),
    LoungeScreen(),
    BusinessScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    tabController = TabController(length: _children.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TabBarView(
        controller: tabController,
        children: _children,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: TabBar(
            indicatorWeight: 2,
            indicatorColor: Colors.white,
            controller: tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.local_bar,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.transparent,
      //   currentIndex: _currentIndex,
      //   onTap: onTabTapped,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: new Icon(
      //         Icons.home,
      //         color: ColorPalette.teaGreenColor,
      //       ),
      //       title: Container(),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: new Icon(
      //         Icons.image,
      //         color: ColorPalette.teaGreenColor,
      //       ),
      //       title: Container(),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         FontAwesomeIcons.userAlt,
      //         color: ColorPalette.teaGreenColor,
      //       ),
      //       title: Container(),
      //     )
      //   ],
      // ),
    );
  }
}
