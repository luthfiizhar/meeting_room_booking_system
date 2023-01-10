import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/main.dart';

class LoginLoading extends StatefulWidget {
  LoginLoading({
    super.key,
    this.queryParam = "",
  });

  dynamic queryParam;

  @override
  State<LoginLoading> createState() => _LoginLoadingState();
}

class _LoginLoadingState extends State<LoginLoading> {
  saveToken(String token, String adminStat, String countLogin) async {
    var box = await Hive.openBox('userLogin');

    await box.put('jwtToken', token);
    await box.put('isAdmin', adminStat);
    await box.put('loginCount', countLogin);

    jwtToken = token;

    context.goNamed('home');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.queryParam.entries);
    List queryParam = [];

    // for (var i = 0; i < widget.queryParam.length; i++) {
    //   queryParam.add({widget.queryParam.keys[i]: widget.queryParam.values[i]});
    // }
    for (var element in widget.queryParam.values) {
      queryParam.add(element);
    }

    saveToken(queryParam[0].toString(), queryParam[1].toString(),
        queryParam[2].toString());
    // print(queryParam[0]);

    // List param = json.decode(queryParam);
    // print("param ---> $param");
    // if (widget.queryParam.toString() != "{}") {
    //   // List param = json.decode(widget.queryParam);
    //   // print(param);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: SizedBox(
            height: 250,
            width: 250,
            child: CircularProgressIndicator(
              color: eerieBlack,
              strokeWidth: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginParameter {
  LoginParameter({
    this.token = "",
    this.isAdmin = "0",
    this.loginCount = "0",
  });
  String token;
  String isAdmin;
  String loginCount;

  @override
  String toString() {
    return "{token : $token}";
  }
}
