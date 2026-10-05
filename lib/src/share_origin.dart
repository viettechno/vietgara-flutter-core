import 'package:flutter/widgets.dart';

/// Where the share sheet anchors: the widget of [context] on screen.
///
/// iPad shows the share sheet as a popover, which needs this anchor
/// (`ShareParams.sharePositionOrigin`); phones ignore it.
Rect? shareOrigin(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}
