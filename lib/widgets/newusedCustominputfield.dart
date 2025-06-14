import 'package:flutter/material.dart';

class CustomNewInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomNewInputField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
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
              style: TextStyle(
                fontSize: 12, // Smaller font size for the label
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              children: hasAsterisk
                  ? [
                      TextSpan(
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
        SizedBox(height: 4), // Reduced space between label and input field
        // You can wrap the TextFormField inside a Container to adjust its width
        Container(
          width: double.infinity, // This makes the field take full width of its parent
          height: 50, // Adjust the height as you like (this defines the height of the TextField)
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: 'أدخل $labelWithoutAsterisk',
              hintStyle: TextStyle(
    fontSize: 12, // <-- Change this to your desired font size
    color: Colors.grey,
  ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Padding controls the inner height
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Border radius can be adjusted
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
