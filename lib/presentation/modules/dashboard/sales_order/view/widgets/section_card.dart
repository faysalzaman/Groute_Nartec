import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;

  const SectionCard({
    Key? key,
    required this.title,
    required this.children,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 5, // Slightly increased elevation
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ), // Horizontal margin for cards
      color: Colors.white, // Use surface color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Clip content to rounded corners
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // Use Row for title and icon
              children: [
                if (icon != null) ...[
                  Icon(icon, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary, // Use primary color
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1), // Increased spacing
            ...children,
          ],
        ),
      ),
    );
  }
}
