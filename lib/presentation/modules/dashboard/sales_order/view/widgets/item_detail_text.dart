import 'package:flutter/material.dart';

class ItemDetailText extends StatelessWidget {
  final String text;
  final bool isBold;

  const ItemDetailText({Key? key, required this.text, this.isBold = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
