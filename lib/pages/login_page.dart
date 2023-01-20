// import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ReqAPI apiReq = ReqAPI();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final FocusNode _usernameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  String? username = "";
  String? password = "";

  List? whiteList = [
    '151839',
    '164369',
    '169742',
  ];

  bool? showPassword = true;

  bool? rememberMe = false;

  bool? isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future checkWhiteList(String username) async {
    for (var element in whiteList!) {
      if (whiteList!.contains(username)) {
        return true;
      } else {
        return false;
      }
    }
  }

  submitLogin() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // loginCerberus(username!, password!, selectedUser)
      // apiReq
      //     .loginDummy(
      //   username!,
      //   password!,
      // )
      // for (var element in whiteList!) {
      // if (whiteList!.contains(username)) {
      apiReq
          .loginHCSSO(username!.toString(), password!.toString())
          .then((value) {
        // print("login Dummy $value");
        setState(() {
          isLoading = false;
        });
        if (value['Status'].toString() == "200") {
          dynamic firstLogin = value['Data']['LoginCount'].toString();
          apiReq.getUserProfile().then((value) async {
            // print("getUserProfile $value");
            if (value['Status'].toString() == "200") {
              // await widget.resetState!();
              // await widget.updateLogin!(
              //   value['Data']['EmpName'],
              //   value['Data']['Email'],
              //   value['Data']['Admin'].toString(),
              //   firstLogin,
              // );
              var admin = value['Data']['Admin'].toString();
              if (firstLogin == "1") {
                context.goNamed('setting',
                    params: {'isAdmin': admin == "1" ? "true" : "false"});
                // Navigator.of(context).pop(true);
              } else {
                context.goNamed('home');
              }
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialogBlack(
                  title: value['Title'],
                  contentText: value['Message'],
                  isSuccess: false,
                ),
              );
            }
          }).onError((error, stackTrace) {
            showDialog(
              context: context,
              builder: (context) => AlertDialogBlack(
                title: 'Can\'t connect to API',
                contentText: error.toString(),
                isSuccess: false,
              ),
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialogBlack(
              title: value['Title'],
              contentText: value['Message'],
              isSuccess: false,
            ),
          );
        }
      }).onError((error, stackTrace) {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: 'Failed connect to API',
            contentText: error.toString(),
            isSuccess: false,
          ),
        );
      });
      // } else {
      //   showDialog(
      //     context: context,
      //     builder: (context) => const AlertDialogBlack(
      //       title: 'Sorry',
      //       contentText:
      //           'Sistem ini baru dapat digunakan tanggal 18 Januari 2023.',
      //       isSuccess: false,
      //     ),
      //   );
      //   // }
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameNode.addListener(() {
      setState(() {});
    });
    _passwordNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _password.dispose();
    _username.dispose();
    _passwordNode.dispose();
    _usernameNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/cover_login.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width > 1366 ? 795 : 570,
                decoration: const BoxDecoration(
                  color: white,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          // vertical: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: Image.asset('assets/navbarlogo.png')
                                      .image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              height: 50,
                              width: 155,
                            ),
                            const SizedBox(
                              height: 32,
                              child: VerticalDivider(
                                color: davysGray,
                                thickness: 1,
                              ),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Text(
                              'Meeting Room Booking System',
                              style: helveticaText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: davysGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 375,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Text(
                                'Login',
                                style: helveticaText.copyWith(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: eerieBlack,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Please login using your HC Plus Account.',
                                style: helveticaText.copyWith(
                                  fontSize: 18,
                                  height: 1.67,
                                  fontWeight: FontWeight.w300,
                                  color: davysGray,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  'Username',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: davysGray,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              BlackInputField(
                                controller: _username,
                                focusNode: _usernameNode,
                                textInputAction: TextInputAction.next,
                                enabled: true,
                                obsecureText: false,
                                maxLines: 1,
                                hintText: 'Your username here ...',
                                validator: (value) => _username.text == ""
                                    ? 'This field is required'
                                    : null,
                                onSaved: (newValue) {
                                  username = newValue.toString();
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: davysGray,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: BlackInputField(
                                      controller: _password,
                                      focusNode: _passwordNode,
                                      textInputAction: TextInputAction.done,
                                      enabled: true,
                                      maxLines: 1,
                                      obsecureText: showPassword,
                                      hintText: 'Your password here ...',
                                      onSaved: (newValue) {
                                        password = newValue.toString();
                                      },
                                      onFieldSubmitted: (value) {
                                        submitLogin();
                                      },
                                      suffixIcon: _passwordNode.hasFocus
                                          ? IconButton(
                                              onPressed: () {
                                                if (showPassword!) {
                                                  showPassword = false;
                                                } else {
                                                  showPassword = true;
                                                }
                                                setState(() {});
                                              },
                                              icon: showPassword!
                                                  ? const Icon(
                                                      FontAwesomeIcons.eyeSlash,
                                                      color: eerieBlack,
                                                      size: 18,
                                                    )
                                                  : const Icon(
                                                      FontAwesomeIcons.eye,
                                                      color: eerieBlack,
                                                      size: 18,
                                                    ),
                                            )
                                          : const SizedBox(),
                                      // suffixIcon: ,
                                    ),
                                  ),
                                ],
                              ),

                              // Column(
                              //   children: user.map((e) {
                              //     return CustomRadioButton(
                              //       group: selectedUser,
                              //       value: e,
                              //       label: e,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           selectedUser = value;
                              //         });
                              //       },
                              //     );
                              //   }).toList(),
                              // ),
                              // const SizedBox(
                              //   height: 100,
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.only(
                              //         left: 3,
                              //       ),
                              //       child: BlackCheckBox(
                              //         selectedValue: rememberMe,
                              //         filled: false,
                              //         onChanged: (value) {
                              //           if (rememberMe!) {
                              //             rememberMe = false;
                              //           } else {
                              //             rememberMe = true;
                              //           }
                              //           setState(() {});
                              //         },
                              //         label: 'Remember Me',
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 100,
                              ),
                              // const Align(
                              //   alignment: Alignment.center,
                              //   child: Text(
                              //     'How to get username & password?',
                              //     style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w400,
                              //       color: davysGray,
                              //       decoration: TextDecoration.underline,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 30,
                              // ),
                              Align(
                                alignment: Alignment.center,
                                child: RegularButton(
                                  text: 'Login',
                                  disabled: false,
                                  padding: ButtonSize().longSize(),
                                  onTap: () {
                                    submitLogin();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
