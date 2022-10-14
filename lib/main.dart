// import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meeting_room_booking_system/app_view.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/model/booking_room_info.dart';
import 'package:meeting_room_booking_system/model/login_info.dart';
import 'package:meeting_room_booking_system/pages/login_page.dart'
    deferred as loginPage;
import 'package:meeting_room_booking_system/pages/user/calendar_view_page.dart'
    deferred as calendarViewPage;
import 'package:meeting_room_booking_system/pages/user/home_page.dart'
    deferred as homePage;
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart'
    deferred as myBookPage;
import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
import 'package:meeting_room_booking_system/pages/user/rooms_page.dart'
    deferred as roomPage;
import 'package:meeting_room_booking_system/pages/user/search_page.dart'
    deferred as searchPage;
import 'package:meeting_room_booking_system/routes/generate_route.dart';
import 'package:meeting_room_booking_system/routes/locations/locations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

bool isLoggedIn = false;
String? jwtToken = "";
bool firstLogIn = true;

loginCheck() async {
  var box = await Hive.openBox('userLogin');
  jwtToken =
      box.get('jwt') != "" || box.get('jwt') != null ? box.get('jwt') : "";

  print("jwt: " + jwtToken.toString());
}

void main() async {
  await Hive.initFlutter();
  loginCheck().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // MyApp({Key? key}) : super(key: key);
  // final loginInfo = LoginInfoModel();
  final Future<void> loadedLibrary = searchPage.loadLibrary();
  late final _router = GoRouter(
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        // builder: (context, state) => HomePage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: FutureBuilder(
            future: homePage.loadLibrary(),
            builder: (context, snapshot) {
              return homePage.HomePage();
            },
          ),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => FutureBuilder(
          future: loginPage.loadLibrary(),
          builder: (context, snapshot) {
            return loginPage.LoginPage();
          },
        ),
      ),
      GoRoute(
        path: '/calendar',
        // builder: (context, state) => CalendarViewPage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: FutureBuilder(
            future: calendarViewPage.loadLibrary(),
            builder: (context, snapshot) {
              return calendarViewPage.CalendarViewPage();
            },
          ),
        ),
      ),
      // GoRoute(
      //   path: '/search',
      //   // builder: (context, state) => CalendarViewPage(),
      //   pageBuilder: (context, state) =>
      //       NoTransitionPage<void>(key: state.pageKey, child: SearchPage()),
      // ),
      GoRoute(
        path: '/search',
        // builder: (context, state) => CalendarViewPage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: FutureBuilder(
              future: searchPage.loadLibrary(),
              builder: (context, snapshot) {
                return searchPage.SearchPage();
              },
            )),
      ),
      GoRoute(
        path: '/rooms',
        // builder: (context, state) => CalendarViewPage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: FutureBuilder(
                future: roomPage.loadLibrary(),
                builder: (context, snapshot) {
                  return roomPage.RoomsPage();
                })),
      ),
      GoRoute(
        path: '/my_booking',
        // builder: (context, state) => CalendarViewPage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: FutureBuilder(
              future: myBookPage.loadLibrary(),
              builder: (context, snapshot) {
                return myBookPage.MyBookingPage();
              }),
        ),
      ),
      // GoRoute(
      //   path: '/on_boarding',
      //   // builder: (context, state) => CalendarViewPage(),
      //   pageBuilder: (context, state) =>
      //       NoTransitionPage<void>(key: state.pageKey, child: OnBoardPage()),
      // )
    ],
    // redirect: (state) {
    //   final loggingIn = state.subloc == '/login';

    //   if (jwtToken == null || jwtToken == "")
    //     return loggingIn ? null : '/login';

    //   if (loggingIn) return '/';

    //   return null;
    // },
    initialLocation: '/',
  );

  // final routerDelegate = BeamerDelegate(
  //   // initialPath: '/',
  //   locationBuilder: BeamerLocationBuilder(
  //     beamLocations: [
  //       HomeLocation(),
  //       LoginLocation(),
  //     ],
  //   ),
  //   guards: [
  //     BeamGuard(
  //       pathPatterns: [
  //         '/',
  //       ],
  //       check: (context, location) =>
  //           jwtToken != "" || jwtToken != null ? true : false,
  //       beamToNamed: (_, __) => '/login',
  //     ),
  //   ],
  // );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginInfoModel>(
      create: (context) => LoginInfoModel(),
      child: MaterialApp.router(
        title: 'MRBS',
        theme: ThemeData(
          fontFamily: 'Helvetica',
          unselectedWidgetColor: eerieBlack,
          scaffoldBackgroundColor: white,
        ),
        debugShowCheckedModeBanner: false,
        //routeInformationParser: BeamerParser(),
        routeInformationParser: _router.routeInformationParser,
        //routerDelegate: routerDelegate,
        routerDelegate: _router.routerDelegate,
        routeInformationProvider: _router.routeInformationProvider,
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          // maxWidth: 1366,
          minWidth: 480,
          breakpoints: [
            ResponsiveBreakpoint.resize(360, name: MOBILE),
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.resize(600, name: TABLET),
            // ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1100, name: DESKTOP),
            // ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
            ResponsiveBreakpoint.resize(1366, name: DESKTOP),
          ],
        ),
        // builder: (context, child) => ResponsiveWrapper.builder(
        //   child,
        //   maxWidth: 2560,
        //   minWidth: 480,
        //   breakpoints: [
        //     ResponsiveBreakpoint.resize(360, name: PHONE),
        //     ResponsiveBreakpoint.resize(480, name: PHONE),
        //     ResponsiveBreakpoint.resize(600, name: TABLET),
        //     // ResponsiveBreakpoint.autoScale(800, name: TABLET),
        //     ResponsiveBreakpoint.autoScale(1024, name: DESKTOP),
        //     // ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
        //     // ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
        //   ],
        // ),
      ),
      // child: MaterialApp(
      //   title: 'Meeting Room Booking System',
      //   theme: ThemeData(
      //     primarySwatch: Colors.blue,
      //   ),
      //   builder: (context, child) => ResponsiveWrapper.builder(
      //     child,
      //     maxWidth: 1400,
      //     minWidth: 480,
      //     breakpoints: [
      //       ResponsiveBreakpoint.autoScale(360, name: PHONE),
      //       ResponsiveBreakpoint.autoScale(480, name: PHONE),
      //       ResponsiveBreakpoint.autoScale(600, name: TABLET),
      //       ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //       ResponsiveBreakpoint.autoScale(1024, name: TABLET),
      //       // ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
      //       ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
      //     ],
      //   ),
      //   // home: LoginPage(),
      //   onGenerateRoute: RouterGenerator.generateRoute,
      // ),
    );
  }
}
