import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/common/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String defaultActionsText;
  final String cancelActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => this,
          );
  }

  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.defaultActionsText,
      this.cancelActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionsText != null);

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogActions(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelActionText),
        ),
      );
    }
    actions.add(PlatformAlertDialogActions(
      onPressed: () => Navigator.of(context).pop(true),
      child: Text(defaultActionsText),
    ));
    return actions;
  }
}

class PlatformAlertDialogActions extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;
  PlatformAlertDialogActions({this.child, this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(onPressed: onPressed, child: child);
  }
}
