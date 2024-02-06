import 'package:flutter/material.dart';

class StateMessageWidget extends StatelessWidget {
  final String message;
  final EdgeInsets verticalPadding;

  const StateMessageWidget({
    Key? key,
    required this.message,
    this.verticalPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: verticalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
