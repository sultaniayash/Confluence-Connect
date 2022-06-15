import 'package:confluence_connect/theme/app_theme.dart';
import 'package:confluence_connect/utils/app_utils.dart';
import 'package:flutter/material.dart';

class LabelValueWidget extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueWidget({
    Key key,
    @required this.label,
    @required this.value,
  })  : assert(label != null, "label can't be null"),
        assert(value != null, "value can't be null"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s10, vertical: Sizes.s5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyles.labelStyle,
            textAlign: TextAlign.start,
          ),
          C5(),
          Text(
            value,
            style: TextStyles.valueText,
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
