// import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/login_info.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);

    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: 150,
              height: 150,
              // color: Colors.blue,
              child: SvgPicture.asset(
                'assets/ilus2.svg',
                // color: Colors.black,
                fit: BoxFit.cover,
                // height: 100,
                // width: 300,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                context.read<LoginInfoModel>().login();
                jwtToken = "asd";
                context.go('/');
                //context.beamToNamed('/');
                var box = await Hive.openBox('userLogin');
                box.put('jwt', 'ASD');
                setState(() {});
              },
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
