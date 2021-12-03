import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naprimer_app_v2/app/styling/app_colors.dart';
import 'package:naprimer_app_v2/app/widgets/buttons/button_wrapper.dart';

enum CameraControlTypes {
  TOGGLE_CAMERA,
  NEXT,
  PUBLISH,
  START_RECORD,
  STOP_RECORD,
  UPLOAD_FROM_GALLERY
}

extension CameraControlTypesData on CameraControlTypes {
  Icon get icon {
    switch (this) {
      case CameraControlTypes.NEXT:
        return Icon(
          Icons.arrow_forward,
          color: Colors.white,
        );
      case CameraControlTypes.PUBLISH:
      case CameraControlTypes.START_RECORD:

      case CameraControlTypes.STOP_RECORD:
      case CameraControlTypes.TOGGLE_CAMERA:
        return Icon(Icons.autorenew);
      case CameraControlTypes.UPLOAD_FROM_GALLERY:
        return Icon(Icons.drive_folder_upload);
    }
  }

  Color get iconBackgroundColor {
    switch (this) {
      case CameraControlTypes.NEXT:
        return AppColors.accentBlue;
      case CameraControlTypes.PUBLISH:
      case CameraControlTypes.START_RECORD:
      case CameraControlTypes.STOP_RECORD:
      case CameraControlTypes.TOGGLE_CAMERA:
        return Color.fromRGBO(180, 180, 180, 125);
      case CameraControlTypes.UPLOAD_FROM_GALLERY:
        return AppColors.accentBlue;
    }
  }

  String? get label {
    switch (this) {
      case CameraControlTypes.UPLOAD_FROM_GALLERY:
      case CameraControlTypes.TOGGLE_CAMERA:
        break;
      case CameraControlTypes.PUBLISH:
      case CameraControlTypes.START_RECORD:
      case CameraControlTypes.STOP_RECORD:
      case CameraControlTypes.NEXT:
        return 'Next';
    }
  }
}

class CameraControlBuilder {
  static Widget buildToggleCameraControl({
    required Function onTap,
  }) {
    return SmallCameraControl(
        onTap: onTap, type: CameraControlTypes.TOGGLE_CAMERA);
  }

  static Widget buildNextControl({
    required Function onTap,
  }) {
    return SmallCameraControl(
      onTap: onTap,
      type: CameraControlTypes.NEXT,
    );
  }

  static Widget buildUploadFromGalleryControl({
    required Function onTap,
  }) {
    return SmallCameraControl(
        onTap: onTap, type: CameraControlTypes.UPLOAD_FROM_GALLERY);
  }

  static Widget buildStartRecordControl({
    required Function onTap,
  }) {
    return LargeCameraControl(
        onTap: onTap, type: CameraControlTypes.START_RECORD);
  }

  static Widget buildPauseRecordControl({
    required Function onTap,
  }) {
    return LargeCameraControl(
        onTap: onTap, type: CameraControlTypes.STOP_RECORD);
  }
}

class SmallCameraControl extends StatelessWidget {
  final Function onTap;
  final CameraControlTypes type;

  const SmallCameraControl({
    Key? key,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: type.iconBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(48))),
            child: type.icon,
          ),
          SizedBox(
            height: 8,
          ),
          Text(type.label ?? ''),
        ],
      ),
    );
  }
}

class LargeCameraControl extends StatelessWidget {
  final Function onTap;
  final CameraControlTypes type;

  const LargeCameraControl({
    Key? key,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () => onTap(),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(92)),
                    gradient: RadialGradient(
                      center: const Alignment(0, 0), // near the top right
                      radius: 0.5,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0),
                        Color.fromRGBO(0, 0, 0, 0.5),
                        Color.fromRGBO(0, 0, 0, 0),
                      ],
                      stops: [0.65, 0.8, 1.0],
                    )),
              ),
              if (type == CameraControlTypes.STOP_RECORD)
                Container(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 64, 64, 1),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.all(4),
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(92)),
                  border: Border.all(color: Colors.white, width: 10),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(''),
        ],
      ),
    );
  }
}
