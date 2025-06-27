import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final int seconds;
  final VoidCallback onCompleted;

  const Countdown({super.key, required this.onCompleted, required this.seconds});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late final Stream<int> _stream;

  @override
  void initState() {
    _stream = Stream.periodic(const Duration(seconds: 1), (int value) {
      if (value >= widget.seconds)
        Future.delayed(const Duration(milliseconds: 10), widget.onCompleted);

      return widget.seconds - value - 1;
    }).take(widget.seconds + 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Text('${snapshot.data}');
        } else {
          return Text('${widget.seconds}');
        }
      },
    );
  }
}
