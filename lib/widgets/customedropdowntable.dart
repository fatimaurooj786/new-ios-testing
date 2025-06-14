import 'package:flutter/material.dart';

class CustomDropdownDynamicTable extends StatefulWidget {
  final String labelText;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdownDynamicTable({
    Key? key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownDynamicTableState createState() =>
      _CustomDropdownDynamicTableState();
}

class _CustomDropdownDynamicTableState extends State<CustomDropdownDynamicTable> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDropdownOpen = false;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(covariant CustomDropdownDynamicTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filteredItems = widget.items;
      _filterItems();
    }
  }

  void _filterItems() {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              item.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    String labelWithoutAsterisk = widget.labelText.replaceAll('*', '').trim();
    bool hasAsterisk = widget.labelText.contains('*');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              text: labelWithoutAsterisk,
              style: TextStyle(
                fontSize: 12, // Reduced font size
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
        SizedBox(height: 4), // Reduced space
        GestureDetector(
          onTap: _toggleDropdown,
          child: FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: 0.98, // Set width to 50% of the parent
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Smaller padding
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30), // Slightly less rounded
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.value ?? 'اختر نوع',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.black54), // Smaller font size
                    ),
                  ),
                  Icon(
                    _isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isDropdownOpen) ...[
          SizedBox(height: 8), // Reduced space
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                SizedBox(height: 8),
                // Filtered and scrollable list
                _filteredItems.isEmpty
                    ? Text('لا توجد نتائج')
                    : SizedBox(
                        height: 150, // Scrollable height reduced
                        child: ListView.builder(
                          itemCount: _filteredItems.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_filteredItems[index]),
                              onTap: () {
                                widget.onChanged(_filteredItems[index]);
                                setState(() {
                                  _searchController.text =
                                      _filteredItems[index];
                                  _isDropdownOpen = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
