import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DetailEventDialog extends StatefulWidget {
  const DetailEventDialog({Key? key}) : super(key: key);

  @override
  State<DetailEventDialog> createState() => _DetailEventDialogState();
}

class _DetailEventDialogState extends State<DetailEventDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 385, maxWidth: 560),
        child: Text('Test'),
      ),
    );
  }
}
