import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naprimer_app_v2/app/styling/app_text_theme.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/button_wrapper.dart';

class VideoControlButtons {
  static Widget playButton(
      {required Function onPressed, IconData? icon, double? size}) {
    return _PlayPauseButton(
      onPressed: onPressed,
      icon: Icon(
        icon ?? Icons.play_arrow_rounded,
        size: size ?? 26,
        color: Colors.black,
      ),
    );
  }

  static Widget pauseButton(
      {required Function onPressed, IconData? icon, double? size}) {
    return _PlayPauseButton(
      onPressed: onPressed,
      icon: Icon(
        icon ?? Icons.pause_rounded,
        size: size ?? 26,
        color: Colors.black,
      ),
    );
  }

  static Widget fastForward(
      {required Function onPressed,
        String? label,
        IconData? icon,
        double? size}) {
    return _ForwardButton(
      onPressed: onPressed,
      label: label ?? '+20',
      icon: Icon(
        icon ?? Icons.refresh_rounded,
        size: size ?? 44,
      ),
    );
  }

  static Widget fastBackward(
      {required Function onPressed,
        String? label,
        IconData? icon,
        double? size}) {
    return _ForwardButton(
      onPressed: onPressed,
      label: label ?? '-10',
      icon: Icon(
        icon ?? Icons.replay_rounded,
        size: size ?? 44,
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);
  final Function onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () => onPressed(),
      child: Container(
        padding: EdgeInsets.all(26),
        margin: EdgeInsets.symmetric(horizontal: 56),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40))),
        child: icon
      ),
    );
  }
}

class _ForwardButton extends StatelessWidget {
  const _ForwardButton(
      {Key? key,
        required this.onPressed,
        required this.label,
        required this.icon})
      : super(key: key);

  final Function onPressed;
  final Icon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () => onPressed(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(
            label,
            style: AppTextTheme.caption,
          )
        ],
      ),
    );
  }
}
