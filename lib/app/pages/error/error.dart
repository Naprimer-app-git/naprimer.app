import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naprimer_app_v2/app/styling/app_text_theme.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/rounded_button.dart';

enum ErrorState { SOMETHING_WENT_WRONG, USER_NOT_FOUND, VIDEO_NOT_FOUND }

extension ErrorStateData on ErrorState {
  String get title {
    switch (this) {
      case ErrorState.SOMETHING_WENT_WRONG:
        return 'Something went wrong';
      case ErrorState.USER_NOT_FOUND:
        return 'User not found';
      case ErrorState.VIDEO_NOT_FOUND:
        return 'Video not found';
    }
  }
}

class ErrorPage extends StatelessWidget {
  final ErrorState errorState;

  const ErrorPage({Key? key, this.errorState = ErrorState.SOMETHING_WENT_WRONG})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Oops', style: AppTextTheme.titleTextStyle,),
          SizedBox(height: 12),

          Text(errorState.title,style: AppTextTheme.caption,),
          SizedBox(height: 36),

          RoundedButton(onTap: Get.back,label: 'BACK TO HOME',

          )
        ],
      ),
    );
  }
}
