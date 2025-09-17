import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/src/data/side_menu_item_data.dart';

class SideMenuItemTitle extends StatelessWidget {
  const SideMenuItemTitle({
    super.key,
    required this.data,
    required this.isOpen,
    required this.minWidth,
  });
  final SideMenuItemDataTitle data;
  final bool isOpen;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    if (!isOpen) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_title(context: context)],
        ),
      );
    }
    return Padding(
      padding: data.padding,
      child: _title(context: context),
    );
  }

  Widget _title({
    required BuildContext context,
  }) {
    final TextStyle? titleStyle =
        data.titleStyle ?? Theme.of(context).textTheme.bodyLarge;
    return AutoSizeText(
      data.title,
      style: titleStyle,
      maxLines: 1,
      textAlign: data.textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }
}
