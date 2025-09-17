import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:flutter_side_menu/src/utils/constants.dart';

class SideMenuItemExpandable extends StatefulWidget {
  const SideMenuItemExpandable({
    super.key,
    required this.isOpen,
    required this.minWidth,
    required this.data,
  });

  final SideMenuItemDataExpandable data;
  final bool isOpen;
  final double minWidth;

  @override
  State<SideMenuItemExpandable> createState() => _SideMenuItemExpandableState();
}

class _SideMenuItemExpandableState extends State<SideMenuItemExpandable> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: widget.isOpen ? widget.data.openSpacing : widget.data.closedSpacing,
      children: [
        _header(context),
        AnimatedCrossFade(
          crossFadeState:
              _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: Constants.duration,
          firstChild: _childrenList(),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }

  OutlinedBorder shape(BuildContext context) {
    return widget.data.borderRadius != null
        ? RoundedRectangleBorder(borderRadius: widget.data.borderRadius!)
        : Theme.of(context).useMaterial3
            ? const StadiumBorder()
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
  }

  Widget _header(BuildContext context) {
    return Container(
      height: widget.data.itemHeight,
      margin: EdgeInsetsDirectional.only(end: 12),
      decoration: widget.data.decoration ??
          ShapeDecoration(
            shape: shape(context),
            color: null,
          ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: widget.data.clipBehavior,
        shape: widget.data.shape ?? shape(context),
        child: InkWell(
          onTap: () {
            widget.data.onTap?.call();
            setState(() => _expanded = !_expanded);
          },
          hoverColor: widget.data.hoverColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              spacing: 8,
              mainAxisAlignment: widget.isOpen
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                if (widget.data.icon != null)
                  IconTheme(
                    data: Theme.of(context).iconTheme,
                    child: widget.data.icon!,
                  ),
                if (widget.isOpen && widget.data.title != null)
                  Expanded(
                    child: AutoSizeText(
                      widget.data.title!,
                      style: widget.data.titleStyle ??
                          Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (widget.isOpen)
                  IconTheme(
                    data: Theme.of(context).iconTheme,
                    child: _expanded
                        ? (widget.data.collapseIcon ??
                            const Icon(Icons.expand_less))
                        : (widget.data.expandIcon ??
                            const Icon(Icons.expand_more)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _childrenList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: widget.isOpen ? widget.data.openSpacing : widget.data.closedSpacing,
      children: widget.data.children.map((child) {
        return switch (child) {
          (SideMenuItemDataTile dataTile) => Padding(
              padding: widget.isOpen
                  ? const EdgeInsetsDirectional.only(start: 24)
                  : EdgeInsetsGeometry.zero,
              child: SideMenuItemTile(
                isOpen: widget.isOpen,
                minWidth: widget.minWidth,
                data: dataTile.resolveWith(
                    g: SideMenuItemTileDefaults(
                  titleStyle: widget.data.titleStyle,
                  selectedTitleStyle: widget.data.selectedTitleStyle,
                  decoration: widget.data.decoration,
                  shape: widget.data.shape,
                  borderRadius: widget.data.borderRadius,
                  hoverColor: widget.data.hoverColor,
                  selectedDecoration: widget.data.selectedDecoration,
                )),
              ),
            ),
          (SideMenuItemDataTitle dataTitle) => Padding(
              padding: widget.isOpen
                  ? const EdgeInsetsDirectional.only(start: 24)
                  : EdgeInsetsGeometry.zero,
              child: SideMenuItemTitle(
                isOpen: widget.isOpen,
                minWidth: widget.minWidth,
                data: dataTitle.resolveWith(
                    g: SideMenuItemTileDefaults(
                  titleStyle: widget.data.titleStyle,
                  selectedTitleStyle: widget.data.selectedTitleStyle,
                  decoration: widget.data.decoration,
                  shape: widget.data.shape,
                  borderRadius: widget.data.borderRadius,
                  hoverColor: widget.data.hoverColor,
                )),
              ),
            ),
          (SideMenuItemDataDivider dataDivider) => Padding(
              padding: widget.isOpen
                  ? const EdgeInsetsDirectional.only(start: 24)
                  : EdgeInsetsGeometry.zero,
              child: SideMenuItemDivider(data: dataDivider),
            ),
          (SideMenuItemDataExpandable dataExpandable) => Padding(
              padding: widget.isOpen
                  ? const EdgeInsetsDirectional.only(start: 24)
                  : EdgeInsetsGeometry.zero,
              child: SideMenuItemExpandable(
                isOpen: widget.isOpen,
                minWidth: widget.minWidth,
                data: dataExpandable,
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      }).toList(),
    );
  }
}
