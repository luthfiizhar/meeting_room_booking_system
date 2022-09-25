// import 'package:beamer/beamer.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:meeting_room_booking_system/main.dart';
// import 'package:meeting_room_booking_system/pages/login_page.dart';
// import 'package:meeting_room_booking_system/pages/user/home_page.dart';

// class HomeLocation extends BeamLocation<BeamState> {
//   @override
//   List<Pattern> get pathPatterns => ['/'];

//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         BeamPage(
//           key: ValueKey('home'),
//           title: 'Home',
//           child: HomePage(),
//         ),
//       ];

//   @override
//   List<BeamGuard> get guards => [
//         BeamGuard(
//           pathPatterns: [
//             '/',
//           ],
//           check: (context, location) =>
//               jwtToken != "" || jwtToken != null ? true : false,
//           beamToNamed: (_, __) => '/login',
//         ),
//       ];
// }

// class LoginLocation extends BeamLocation<BeamState> {
//   @override
//   List<Pattern> get pathPatterns => ['/login'];

//   @override
//   List<BeamPage> buildPages(BuildContext context, BeamState state) => [
//         BeamPage(
//           key: ValueKey('login'),
//           title: 'Login',
//           child: LoginPage(),
//         ),
//       ];
// }
