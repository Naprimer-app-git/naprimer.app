import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/button_wrapper.dart';

class QuestionModal extends StatelessWidget {
  final spacerColor = Colors.white54;
  final buttonBgColor = const Color.fromRGBO(249, 249, 249, 0.78);
  final blueTextColor = const Color.fromRGBO(0, 122, 255, 1);

  final VoidCallback onBlueAction;
  final VoidCallback onRedAction;
  final VoidCallback onCancel;
  final String questionText;
  final String blueActionText;
  final String redActionText;

  QuestionModal({
    required this.onBlueAction,
    required this.onRedAction,
    required this.onCancel,
    required this.questionText,
    required this.blueActionText,
    required this.redActionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            child: Column(
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: buttonBgColor,
                  ),
                  child: Center(
                    child: Text(
                      questionText,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (blueActionText != null)
                  Container(
                    height: 1,
                    color: spacerColor,
                  ),
                if (blueActionText != null)
                  ButtonWrapper(
                    onTap: onBlueAction,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: buttonBgColor,
                      ),
                      child: Center(
                        child: Text(
                          blueActionText,
                          style: TextStyle(color: blueTextColor, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                if (redActionText != null)
                  Container(
                    height: 1,
                    color: spacerColor,
                  ),
                if (redActionText != null)
                  ButtonWrapper(
                    onTap: onRedAction,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: buttonBgColor,
                      ),
                      child: Center(
                        child: Text(
                          redActionText,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 64, 64, 1),
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ButtonWrapper(
            onTap: onCancel,
            child: Container(
              height: 56,
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: blueTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
