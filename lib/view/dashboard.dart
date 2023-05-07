import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:savia/blocs/dashboard/dashboard_bloc.dart';
import 'package:savia/constant/size_constant.dart';
import 'package:savia/constant/switch_screen_constant.dart';
import 'package:savia/constant/text_style_constant.dart';
import 'package:savia/models/chat_user.dart';
import 'package:savia/view/auth/sign_in/sign_in.dart';
import 'package:savia/view/chat/chat_page.dart';
import 'package:savia/view/profile/profile_page.dart';
import 'contact/contact_page.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  ChatUserModel? currentUser;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _updateUserStatus(status: true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log("message: ${message.toString()}");
      if (currentUser != null) {
        if (message.toString().contains('resumed')) {
          _updateUserStatus(status: true);
        }
        if (message.toString().contains('paused') ||
            message.toString().contains('inactive')) {
          _updateUserStatus(status: false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      appBar: _appBar(),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardCreateNewDataUserFaild) {
            SwitchScreenConstant.nextScreenReplace(context, SignInPage());
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardGetCurrentUserSuccess) {
              currentUser = state.currentUser;
              final tab = [
                ContactPage(currentUser: currentUser!),
                ChatPage(currentUser: currentUser!),
                ProfilePage(currentUser: currentUser!)
              ];
              return tab[_currentIndex];
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _getCurrentUser() {
    context.read<DashboardBloc>().add(DashboardGetCurrentUserEvent());
  }

  void _updateUserStatus({required bool status}) {
    context
        .read<DashboardBloc>()
        .add(DashboardUpdateUserStatusEvent(status: status));
  }

  AppBar _appBar() {
    return AppBar(
      actionsIconTheme: const IconThemeData(
        color: Colors.black,
        size: 40,
      ),
      toolbarHeight: SizeConstant.heightOfAppBar,
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        'FChat',
        style: TextStyleConstant.titleAppbar,
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 5,
            activeColor: Colors.black,
            iconSize: 30,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(icon: LineIcons.peopleCarry, text: 'Contacts'),
              GButton(icon: LineIcons.facebookMessenger, text: 'Messages'),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
