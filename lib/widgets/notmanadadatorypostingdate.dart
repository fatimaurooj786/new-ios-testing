import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notmanadadatorypostingdate extends StatefulWidget {
  final String labelText;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateChanged;

  const Notmanadadatorypostingdate({
    Key? key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<Notmanadadatorypostingdate> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  void _selectDate(BuildContext context) async {
    DateTime initialDate = widget.selectedDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("ar", "SA"), // Arabic calendar
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = widget.selectedDate != null
        ? _dateFormat.format(widget.selectedDate!)
        : 'اختر التاريخ';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            widget.labelText,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
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
                    displayText,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.selectedDate != null
                          ? Colors.black87
                          : Colors.black54,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey.shade700, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
