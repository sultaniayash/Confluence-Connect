import 'package:confluence_connect/theme/app_theme.dart';
import 'package:confluence_connect/utils/app_utils.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final String buttonText;
  final String image;
  final Function onTap;
  final Widget child;
  final bool showButton;
  final PageState pageState;

  const AppErrorWidget({
    Key key,
    @required this.message,
    @required this.pageState,
    this.buttonText,
    @required this.onTap,
    this.child,
    this.image,
    this.showButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Offstage(
        offstage: pageState != PageState.ERROR,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[child],
          ),
        ),
      );
    }

    return Offstage(
      offstage: pageState != PageState.ERROR,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(Sizes.s50),
              child: Image(
                height: Sizes.s150 * 2,
                image: AssetImage(image ?? Assets.logoConfluence),
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Sizes.s10),
              child: Text(
                message,
                style: TextStyles.defaultMedium.copyWith(
                  fontSize: FontSize.s18,
                  color: AppColors.warmGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.s30, horizontal: Sizes.s40),
              child: showButton
                  ? AppButton(
                      text: buttonText ?? Strings.retry,
                      onTap: onTap ?? () {},
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.s20),
      child: Column(
        children: <Widget>[
          Image(image: AssetImage(Assets.numberNotRegistered)),
          C5(),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  message,
                  style: TextStyles.defaultSemiBold.copyWith(
                    color: Colors.black38,
                    fontSize: FontSize.s20,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
