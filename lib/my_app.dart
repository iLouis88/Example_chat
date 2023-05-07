import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savia/blocs/chat/chat_bloc.dart';
import 'package:savia/blocs/contact/contact_bloc.dart';
import 'package:savia/blocs/dashboard/dashboard_bloc.dart';
import 'package:savia/blocs/profile_editting/profile_editting_bloc.dart';
import 'package:savia/repositories/chat_repo.dart';
import 'package:savia/repositories/contact_repo.dart';
import 'package:savia/repositories/dashboard_repo.dart';
import 'package:savia/repositories/profile_editting_repo.dart';
import 'package:savia/view/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: ((context) =>
                  DashboardBloc(dashboardRepository: DashboardRepository()))),
          BlocProvider(
              create: ((context) => ProfileEdittingBloc(
                  profileEdittingRepository: ProfileEdittingRepository()))),
          BlocProvider(
              create: ((context) =>
                  ChatBloc(chatRepository: ChatRepository()))),
          BlocProvider(
              create: ((context) =>
                  ContactBloc(contactRepository: ContactRepository()))),
        ],
        child: MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            title: 'FChat',
            home: SplashScreen()));
  }
}
