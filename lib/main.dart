// import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_intro/flutter_intro.dart';
import 'package:go_router/go_router.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:meeting_room_booking_system/app_view.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
// import 'package:meeting_room_booking_system/constant/custom_scroll_behavior.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
// import 'package:meeting_room_booking_system/model/booking_room_info.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/pages/admin/admin_detail_booking.dart';
import 'package:meeting_room_booking_system/pages/admin/admin_list_approval_page.dart';
import 'package:meeting_room_booking_system/pages/admin/admin_setting_page.dart';
import 'package:meeting_room_booking_system/pages/loading_login.dart';
import 'package:meeting_room_booking_system/pages/login_page.dart';
import 'package:meeting_room_booking_system/pages/admin/bug_list.dart';
import 'package:meeting_room_booking_system/pages/admin/feedback_list.dart';
import 'package:meeting_room_booking_system/pages/user/event_confirm_page.dart';
import 'package:meeting_room_booking_system/pages/user/google_workspace_page.dart';
// import 'package:meeting_room_booking_system/pages/user/calendar_view_page.dart'
//     deferred as calendarViewPage;

// import 'package:meeting_room_booking_system/pages/user/home_page.dart'
//     deferred as homePage;
// import 'package:meeting_room_booking_system/pages/user/my_book_page.dart'
//     deferred as myBookPage;
// import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
// import 'package:meeting_room_booking_system/pages/user/rooms_page.dart'
//     deferred as roomPage;
// import 'package:meeting_room_booking_system/pages/user/search_page.dart'
//     deferred as searchPage;
// import 'package:meeting_room_booking_system/pages/user/booking_page.dart'
//     deferred as bookPage;
// import 'package:meeting_room_booking_system/pages/user/detail_event_page.dart'
//     deferred as detailEventPage;
import 'package:meeting_room_booking_system/pages/user/calendar_view_page.dart';
import 'package:meeting_room_booking_system/pages/user/home_page.dart';
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart';
import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
import 'package:meeting_room_booking_system/pages/user/rooms_page.dart';
import 'package:meeting_room_booking_system/pages/user/search_page.dart';
import 'package:meeting_room_booking_system/pages/user/booking_page.dart';
import 'package:meeting_room_booking_system/pages/user/detail_event_page.dart';
import 'package:meeting_room_booking_system/routes/generate_route.dart';
import 'package:meeting_room_booking_system/routes/locations/locations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

bool isLoggedIn = false;
String? jwtToken = "";
String? token = "";
bool isTokenValid = false;
bool firstLogIn = true;
bool isAdmin = false;

loginCheck() async {
  var box = await Hive.openBox('userLogin');
  jwtToken = box.get('jwtToken') != "" || box.get('jwtToken') != null
      ? box.get('jwtToken')
      : "";

  print("jwt: " + jwtToken.toString());
}

void main() async {
  await Hive.initFlutter();
  // final ipv4 = await Ipify.ipv4();
  // print(ipv4);
  await loginCheck();
  // runApp(MyApp());
  ReqAPI reqApi = ReqAPI();
  reqApi.checkToken().then((value) {
    // print(value);
    if (value["Status"] == "200") {
      isTokenValid = true;
    } else {
      isTokenValid = false;
    }
    // print('token valid? $isTokenValid');
    runApp(MyApp());
  });

  // loginCheck().then((_) {
  //   runApp(MyApp());
  // });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // final loginInfo = MainModel();
  // final Future<void> loadedLibrary = searchPage.loadLibrary();
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: LoginPage(),
        ),
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        // builder: (context, state) => HomePage(),
        // pageBuilder: (context, state) => NoTransitionPage<void>(
        //       key: state.pageKey,
        //       child: FutureBuilder(
        //         future: homePage.loadLibrary(),
        //         builder: (context, snapshot) {
        //           return homePage.HomePage();
        //         },
        //       ),
        //     ),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: HomePage(
            index: 0,
          ),
        ),
        // routes: [
        // GoRoute(
        //   name: 'booking',
        //   path:
        //       'booking/roomId=:roomId&date=:date&startTime=:startTime&endTime=:endTime&participant=:participant&facilities=:facilities&type=:roomType',
        //   pageBuilder: (context, state) => NoTransitionPage<void>(
        //     key: state.pageKey,
        //     child: BookingRoomPage(
        //       roomId: state.params['roomId'],
        //       date: state.params['date'],
        //       startTime: state.params['startTime'],
        //       endTime: state.params['endTime'],
        //       participant: state.params['participant'],
        //       facilities: state.params['facilities'],
        //       roomType: state.params['roomType'],
        //     ),
        //   ),
        // ),
        // ],
      ),
      // GoRoute(
      //   name: 'login',
      //   path: '/login',
      //   builder: (context, state) => FutureBuilder(
      //     future: loginPage.loadLibrary(),
      //     builder: (context, snapshot) {
      //       return loginPage.LoginPage();
      //     },
      //   ),
      // ),
      GoRoute(
        name: 'calendar',
        path: '/calendar',
        // builder: (context, state) => CalendarViewPage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: CalendarViewPage(),
        ),
        // pageBuilder: (context, state) => NoTransitionPage<void>(
        //   key: state.pageKey,
        //   child: FutureBuilder(
        //     future: calendarViewPage.loadLibrary(),
        //     builder: (context, snapshot) {
        //       return calendarViewPage.CalendarViewPage();
        //     },
        //   ),
        // ),
      ),
      // GoRoute(
      //   path: '/search',
      //   // builder: (context, state) => CalendarViewPage(),
      //   pageBuilder: (context, state) =>
      //       NoTransitionPage<void>(key: state.pageKey, child: SearchPage()),
      // ),
      GoRoute(
        name: 'search',
        path: '/search',
        pageBuilder: (context, state) {
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: SearchPage(
              queryParam: state.queryParams,
            ),
          );
        },
        routes: [
          GoRoute(
            name: 'booking_search',
            path:
                'booking/roomId=:roomId&date=:date&startTime=:startTime&endTime=:endTime&participant=:participant&type=:roomType&isEdit=:isEdit',
            // 'booking/isEdit=:isEdit',
            pageBuilder: (context, state) {
              return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: BookingRoomPage(
                    index: 1,
                    roomId: state.params['roomId'],
                    date: state.params['date'],
                    startTime: state.params['startTime'],
                    endTime: state.params['endTime'],
                    participant: state.params['participant'],
                    // facilities: state.params['facilities'],
                    roomType: state.params['roomType'],
                    isEdit: state.params['isEdit']!,
                    queryParameter: state.queryParams,
                  ));
            },
          ),
        ],
      ),
      GoRoute(
        name: 'rooms',
        path: '/rooms',
        // builder: (context, state) => CalendarViewPage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: RoomsPage(),
        ),
        // pageBuilder: (context, state) => NoTransitionPage<void>(
        //   key: state.pageKey,
        //   child: FutureBuilder(
        //     future: roomPage.loadLibrary(),
        //     builder: (context, snapshot) {
        //       return roomPage.RoomsPage();
        //     },
        //   ),
        // ),
        routes: [
          GoRoute(
              name: 'booking_rooms',
              path:
                  'booking_rooms/roomId=:roomId&date=:date&startTime=:startTime&endTime=:endTime&participant=:participant&type=:roomType&isEdit=:isEdit&floor=:floor',
              pageBuilder: (context, state) {
                dynamic edit = state.queryParams;
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: BookingRoomPage(
                    roomId: state.params['roomId'],
                    date: state.params['date'],
                    startTime: state.params['startTime'],
                    endTime: state.params['endTime'],
                    participant: state.params['participant'],
                    roomType: state.params['roomType'],
                    isEdit: state.params['isEdit']!,
                    floor: state.params['floor']!,
                    edit: edit,
                  ),
                );
              })
        ],
      ),
      GoRoute(
        name: 'booking_list',
        path: '/booking_list',
        // builder: (context, state) => CalendarViewPage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: MyBookingPage(),
        ),
        routes: [
          GoRoute(
            name: 'detail_booking_list',
            path: 'detail_event/:eventId',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: DetailEventPage(
                bookingId: state.params['eventId'],
              ),
            ),
          )
        ],
      ),
      GoRoute(
          name: 'booking',
          path:
              '/booking/roomId=:roomId&date=:date&startTime=:startTime&endTime=:endTime&participant=:participant&type=:roomType&isEdit=:isEdit',
          pageBuilder: (context, state) {
            dynamic edit = state.queryParams;
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: BookingRoomPage(
                roomId: state.params['roomId'],
                date: state.params['date'],
                startTime: state.params['startTime'],
                endTime: state.params['endTime'],
                participant: state.params['participant'],
                // facilities: state.params['facilities'],
                roomType: state.params['roomType'],
                isEdit: state.params['isEdit']!,
                edit: edit,
              ),
            );
          }),
      GoRoute(
        name: 'comfirm_event',
        path: '/confirm_event/:eventId',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: ConfirmEventPage(
            bookingId: state.params['eventId'],
          ),
        ),
        // routes: [
        //   GoRoute(
        //     name: 'detail_event_edit',
        //     path: 'edit/roomId=:roomId&date=:date&',
        //   )
        // ],
      ),
      GoRoute(
        name: 'detail_event',
        path: '/detail_event/eventID=:eventId',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: DetailEventPage(
            bookingId: state.params['eventId'],
          ),
        ),
        // routes: [
        //   GoRoute(
        //     name: 'detail_event_edit',
        //     path: 'edit/roomId=:roomId&date=:date&',
        //   )
        // ],
      ),
      GoRoute(
        name: 'admin_list',
        path: '/admin/list',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: AdminListPage(),
        ),
        routes: [
          GoRoute(
            name: 'detail_approval',
            path: 'detail_event/eventID=:eventId',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: AdminDetailBooking(
                bookingId: state.params['eventId'],
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        name: 'setting',
        path: '/setting/:menu/:isAdmin',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: AdminSettingPage(
            firstMenu: state.params['menu'],
            isAdmin: state.params['isAdmin'],
          ),
        ),
      ),
      GoRoute(
          name: 'gws',
          path: '/gws',
          pageBuilder: (context, state) {
            var param = state.queryParams;
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: GoogleWorkspacePage(
                param: param,
              ),
            );
          }),
      GoRoute(
        name: 'login_auth',
        path: '/login_auth',
        pageBuilder: (context, state) {
          dynamic param = state.queryParams;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: LoginLoading(
              queryParam: param,
            ),
          );
        },
      ),
      GoRoute(
        name: 'bug_list',
        path: '/bug_list',
        pageBuilder: (context, state) {
          dynamic param = state.queryParams;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const BugListPage(),
          );
        },
      ),
      GoRoute(
        name: 'feedback_list',
        path: '/feedback_list',
        pageBuilder: (context, state) {
          dynamic param = state.queryParams;
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const FeedBackListPage(),
          );
        },
      ),
    ],
    redirect: (context, state) {
      // final goHome = state.subloc == '/home';
      // final roomPage = state.location == '/rooms';
      // final search = state.name == '/search';

      final login = state.subloc == '/login';

      if (jwtToken == null || jwtToken == "" || !isTokenValid) {
        return login ? null : '/login';
      }
      // if (!roomPage) {
      //   if (jwtToken == null || jwtToken == "") {
      //     return goHome ? null : '/home';
      //   }
      //   if (!isTokenValid) {
      //     return goHome ? null : '/home';
      //   }
      // }
      // if (loggingIn) return '/home';

      return null;
    },
    initialLocation: '/home',
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainModel>(
          lazy: false,
          create: (_) => MainModel(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Meeting Room Booking System',
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
          defaultScale: MediaQuery.of(context).size.width < 1100 ? true : false,
          minWidth: MediaQuery.of(context).size.width < 1100 ? 360 : 1100,
          breakpoints: [
            // ResponsiveBreakpoint.resize(360, name: MOBILE),
            // ResponsiveBreakpoint.resize(480, name: MOBILE),
            // ResponsiveBreakpoint.resize(600, name: TABLET),
            // ResponsiveBreakpoint.autoScale(800, name: TABLET),
            // ResponsiveBreakpoint.resize(1100, name: DESKTOP),
            // ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
            // ResponsiveBreakpoint.resize(1366, name: DESKTOP),
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
    );
  }
}
