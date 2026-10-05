import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/common.dart';

/// "Send a new code", disabled with a countdown until [availableAt].
class ResendButton extends StatefulWidget {
  const ResendButton({
    super.key,
    required this.availableAt,
    required this.onPressed,
  });

  final DateTime? availableAt;
  final VoidCallback? onPressed;

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton> {
  Timer? _timer;

  int get _seconds {
    final availableAt = widget.availableAt;
    if (availableAt == null) return 0;
    final left = availableAt.difference(DateTime.now()).inSeconds;
    return left > 0 ? left + 1 : 0;
  }

  @override
  void initState() {
    super.initState();
    _tick();
  }

  @override
  void didUpdateWidget(ResendButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableAt != widget.availableAt) _tick();
  }

  void _tick() {
    _timer?.cancel();
    if (_seconds == 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {});
      if (_seconds == 0) timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = _seconds;
    return TextButton(
      onPressed: seconds > 0 ? null : widget.onPressed,
      child: Text(
        seconds > 0
            ? context.coreL10n.verifyResendIn(seconds)
            : context.coreL10n.verifyResend,
      ),
    );
  }
}
