import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuildIdUser extends StatelessWidget {
  final String showId;
  const BuildIdUser({super.key, required this.showId});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SelectableText('ID: $showId',
          style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
      IconButton(
          // copy checkId of user to clipBoard
          onPressed: () async {
            await _copyID(context);
          },
          icon: const Icon(Icons.copy))
    ]);
  }

  Future<void> _copyID(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: showId)).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 500),
            backgroundColor: Colors.white,
            content: Center(
                child: Text(
              'ID copied',
              style: TextStyle(color: Colors.black, fontSize: 15),
            )))));
  }
}
