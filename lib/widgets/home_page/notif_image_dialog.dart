import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationImageDialog extends StatefulWidget {
  const NotificationImageDialog({super.key});

  @override
  State<NotificationImageDialog> createState() =>
      _NotificationImageDialogState();
}

class _NotificationImageDialogState extends State<NotificationImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: NetworkImage(
                      "https://fmklg.klgsys.com/images/mrbs/mrbs_promo.png"),
                  fit: BoxFit.cover,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: 1100,
                maxWidth: 1100,
                maxHeight: 600,
                minHeight: 600,
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: () {
                  context.pop();
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                ),
              ),
            ),
          ],
        ));
  }
}
