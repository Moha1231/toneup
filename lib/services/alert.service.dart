import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/services/app.service.dart';

class AlertService {
  static showLoading({String? title, String? text}) {
    QuickAlert.show(
      context: AppService().navigatorKey.currentContext!,
      type: QuickAlertType.loading,
      title: title ?? "Loading".tr(),
      text: text ?? "Please wait...".tr(),
      barrierDismissible: false,
    );
  }

  //stop loading
  static stopLoading() {
    Navigator.of(AppService().navigatorKey.currentContext!).pop();
  }

  //error alert
  static error({
    String? title,
    String? body,
    String? confirmText,
    Function? onConfirm,
  }) {
    QuickAlert.show(
      context: AppService().navigatorKey.currentContext!,
      type: QuickAlertType.error,
      title: title ?? "Error".tr(),
      text: body ?? "An error occured".tr(),
      confirmBtnText: confirmText ?? "OK".tr(),
      onConfirmBtnTap: onConfirm as void Function()?,
    );
  }
}
