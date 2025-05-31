import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meetup/constants/app_images.dart';
import 'package:meetup/widgets/buttons/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:meetup/constants/api.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    Key? key,
    this.imageUrl = "",
    this.title = "",
    this.actionText = "Action",
    this.description = "",
    this.showAction = false,
    this.actionPressed,
    this.auth = false,
  }) : super(key: key);

  final String title;
  final String actionText;
  final String description;
  final String imageUrl;
  final Function? actionPressed;
  final bool showAction;
  final bool auth;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Image.asset(
          imageUrl.isNotEmptyAndNotNull ? imageUrl : AppImages.user,
          width: context.percentWidth * 12,
          height: context.percentWidth * 12,
        ).box.makeCentered(),

        //
        title.isNotEmpty
            ? title.text.xl.semiBold.center.makeCentered()
            : const SizedBox.shrink(),

        //
        auth
            ? "You have to login to access profile and history"
                .tr()
                .text
                .center
                .lg
                .light
                .makeCentered()
            : description.isNotEmpty
                ? description.text.lg.light.makeCentered()
                : const SizedBox.shrink(),

        //
        auth
            ? CustomButton(
                title: "Login".tr(),
                onPressed: actionPressed != null ? actionPressed! : () {},
              ).centered()
            : showAction
                ? CustomButton(
                    title: actionText,
                    onPressed: actionPressed != null ? actionPressed! : () {},
                  ).centered()
                : const SizedBox.shrink(),

        "privacy policy"
            .tr()
            .text
            .semiBold
            .makeCentered()
            .py12()
            .onInkTap(openPrivacyPolicy),
      ],
      spacing: 8,
    );
  }
}

openPrivacyPolicy() async {
  final url = Api.privacyPolicy;
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    //   viewContext!.showToast(
    //  msg: 'Could not launch $url',
    // );
  }
}
