import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class LoginPopUp extends StatefulWidget {
  LoginPopUp({
    super.key,
    this.resetState,
    this.updateLogin,
  });

  Function? resetState;
  Function? updateLogin;
  // GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<LoginPopUp> createState() => _LoginPopUpState();
}

class _LoginPopUpState extends State<LoginPopUp> {
  ReqAPI apiReq = ReqAPI();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  FocusNode _usernameNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  String? username = "";
  String? password = "";

  String selectedUser = "Luthfi";

  List user = ['Luthfi', 'Edward', 'Nico'];

  bool? showPassword = true;

  bool? rememberMe = false;

  bool? isLoading = false;

  final _formKey = new GlobalKey<FormState>();

  submitLogin() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // loginCerberus(username!, password!, selectedUser)
      apiReq
          .loginDummy(
        username!,
        password!,
      )
          .then((value) {
        print("login Dummy $value");
        setState(() {
          isLoading = false;
        });
        if (value['Status'] == "200") {
          apiReq.getUserProfile().then((value) async {
            print("getUserProfile $value");
            if (value['Status'] == "200") {
              await widget.resetState!();
              await widget.updateLogin!(
                value['Data']['EmpName'],
                value['Data']['Email'],
                value['Data']['Admin'].toString(),
              );
              Navigator.of(context).pop(true);
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
    // TODO: implement dispose
    super.dispose();
    _password.dispose();
    _username.dispose();
    _passwordNode.dispose();
    _usernameNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: culturedWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: ThemeData(fontFamily: 'Helvetica'),
        child: Container(
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(10),
            color: culturedWhite,
            boxShadow: const [
              BoxShadow(
                blurRadius: 40,
                offset: Offset(0, 12),
                color: Color.fromRGBO(
                  29,
                  29,
                  29,
                  0.2,
                ),
              ),
              BoxShadow(
                // blurRadius: 40,
                offset: Offset(0, 8),
                color: eerieBlack,
              )
            ],
          ),
          width: 465,
          height: 535,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Please login using your Windows / laptop credential.',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          height: 1.67,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
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
                        height: 20,
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
                                  : SizedBox(),
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
                        height: 40,
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
              // Positioned(
              //   top: 20,
              //   right: 20,
              //   child: IconButton(
              //     splashRadius: 1,
              //     style: const ButtonStyle(
              //       splashFactory: NoSplash.splashFactory,
              //     ),
              //     icon: Icon(Icons.close),
              //     onPressed: () {
              //       Navigator.of(context).pop(false);
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
