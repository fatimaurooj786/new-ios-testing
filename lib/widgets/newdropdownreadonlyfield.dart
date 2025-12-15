import 'package:flutter/material.dart';

class CustomReadonlyFieldWithDisplay extends StatelessWidget {
  final String labelText;
  final String? value; // selected ID
  final List<String> items; // list of IDs
  final List<String> displayItems; // list of names

  const CustomReadonlyFieldWithDisplay({
    Key? key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.displayItems,
  })  : assert(items.length == displayItems.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedDisplay = "";
    if (value != null) {
      int index = items.indexOf(value!);
      if (index != -1) {
        selectedDisplay = displayItems[index];
      }
    }
    if (selectedDisplay.isEmpty) {
      selectedDisplay = "—"; // default if nothing selected
    }

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
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              children: hasAsterisk
                  ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : [],
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedDisplay,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              Icon(
                Icons.lock, // show lock icon to indicate readonly
                size: 18,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
