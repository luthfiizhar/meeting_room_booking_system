import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/pages/user/home_page.dart';
import 'package:provider/provider.dart';

class OnBoardPage extends StatelessWidget {
  OnBoardPage({Key? key}) : super(key: key);
  final loginInfo = MainModel();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, child) {
      return Dialog(
        child: IntroductionScreen(
          scrollPhysics: const BouncingScrollPhysics(),
          showSkipButton: true,
          skip: const Icon(Icons.skip_next),
          next: const Icon(Icons.forward),
          done: const Text("Done"),
          onDone: () {
            model.onBoardDone();
            Navigator.of(context).pop(false);
          },
          onSkip: () {},
          dotsDecorator: DotsDecorator(
              size: const Size.square(10),
              activeSize: const Size(20, 10),
              activeColor: Colors.amber,
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
          pages: [
            PageViewModel(
              title: 'Title of 1st Page',
              body: 'Body of 1st Page',
            ),
            PageViewModel(
              title: 'Title of 2nd Page',
              body: 'Body of 2nd Page',
            ),
            PageViewModel(
              title: 'Title of 3rd Page',
              body: 'Body of 3rd Page',
            ),
            PageViewModel(
              title: 'Title of 4th Page',
              body: 'Body of 4th Page',
            ),
          ],
        ),
      );
    });
  }
}
