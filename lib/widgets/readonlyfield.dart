import 'package:flutter/material.dart';

class ReadOnlyInputField extends StatelessWidget {
  final String labelText;
  final String value;

  const ReadOnlyInputField({
    Key? key,
    required this.labelText,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String labelWithoutAsterisk = labelText.replaceAll('*', '').trim();
    bool hasAsterisk = labelText.contains('*');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              text: labelWithoutAsterisk,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              children: hasAsterisk
                  ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            value.isNotEmpty ? value : '-',
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
