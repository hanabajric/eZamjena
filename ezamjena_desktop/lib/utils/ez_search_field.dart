import 'package:flutter/material.dart';

/// Search bar sa maxWidth‑om 500 px, zaobljenim ivicama i ikonicom lupice.
class EzSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const EzSearchField({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Pretraži po nazivu',
            prefixIcon: const Icon(Icons.search),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
