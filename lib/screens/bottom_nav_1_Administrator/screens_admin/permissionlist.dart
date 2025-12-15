
import 'package:chart_harakia/screens/admin_services/permissiongetservice.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/permissionListDetails.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

import 'package:chart_harakia/widgets/colors.dart';

class PermissionListScreen extends StatefulWidget {
  const PermissionListScreen({super.key});

  @override
  State<PermissionListScreen> createState() => _PermissionListScreenState();
}

class _PermissionListScreenState extends State<PermissionListScreen> {
  String _fullName = 'Loading...';
  Future<List<dynamic>?>? permissionFuture;
  List<dynamic> allPermissions = [];
  List<dynamic> filteredPermissions = [];

  String? selectedCardId;
  Color? selectedCardColor;

  TextEditingController filterController = TextEditingController();
  bool isFiltering = false;

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    permissionFuture = _fetchPermissions();
  }

  Future<List<dynamic>?> _fetchPermissions() async {
    String fullName = await _extractFullName();
    final permissionService = permissionServiceGet();
    List<dynamic>? permissionList = await permissionService.fetchpermissiongetservice();

    if (!mounted) return [];

    setState(() {
      _fullName = fullName;
      allPermissions = permissionList ?? [];
      filteredPermissions = allPermissions;
    });

    return permissionList;
  }

  Future<String> _extractFullName() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie');

    if (cookies != null) {
      for (var part in cookies.split(';')) {
        part = part.trim();
        if (part.contains('full_name=')) {
          String encoded = part.substring(part.indexOf('full_name=') + 10);
          try {
            return Uri.decodeComponent(encoded);
          } catch (_) {
            return encoded;
          }
        }
      }
    }
    return 'No full name found';
  }

  void _applyFilter(String query) {
    setState(() {
      filteredPermissions = allPermissions.where((permission) {
        final typeMatch =
            permission['permission_type']?.toLowerCase().contains(query.toLowerCase()) ?? false;

        final permissionDate = DateTime.tryParse(permission['posting_date'] ?? '');
        final fromMatch = fromDate == null ||
            (permissionDate != null &&
                permissionDate.isAfter(fromDate!.subtract(const Duration(days: 1))));

        final toMatch = toDate == null ||
            (permissionDate != null &&
                permissionDate.isBefore(toDate!.add(const Duration(days: 1))));

        return typeMatch && fromMatch && toMatch;
      }).toList();
    });
  }

  void _removeFilter() {
    setState(() {
      isFiltering = false;
      filteredPermissions = allPermissions;
      filterController.clear();
      fromDate = null;
      toDate = null;
    });
  }

  Color _getRandomColor() {
    final colors = [
      Colors.blueAccent,
      MyColors.color,
      Colors.deepOrangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildPermissionCard(dynamic permission) {
    String cardId = permission['name'].toString();
    bool isSelected = selectedCardId == cardId;
    Color cardColor = isSelected ? selectedCardColor ?? MyColors.color : Colors.white;
    Color borderColor = selectedCardColor ?? MyColors.color;

    return GestureDetector(
      onTap: () {
        final randomColor = _getRandomColor();
        setState(() {
          selectedCardId = cardId;
          selectedCardColor = randomColor;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>  PermissionDetailScreen(permissionData: permission),
          ),
        ); 

        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              selectedCardId = null;
              selectedCardColor = null;
            });
          }
        });
      },
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildInfoRow(
                      icon: Icons.verified_user,
                      color: Colors.teal,
                      label: "نوع الصلاحية",
                      value: permission['permission_type']),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      icon: Icons.account_balance_wallet,
                      color: Colors.purpleAccent,
                      label: "الرصيد المتبقي",
                      value: permission['permission_balance'].toString()),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                      icon: Icons.tag,
                      color: Colors.redAccent,
                      label: "رقم الصلاحية",
                      value: permission['name']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color color,
    required String label,
    required String? value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: color),
        Expanded(
          child: Text(
            "$label: ${value ?? ''}",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة الصلاحيات", textDirection: TextDirection.rtl),
        backgroundColor: MyColors.color,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isFiltering) _buildFilterUI(),
          Expanded(
            child: FutureBuilder<List<dynamic>?>(  
              future: permissionFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => _buildShimmerCard(),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: filteredPermissions.length,
                    itemBuilder: (context, index) =>
                        _buildPermissionCard(filteredPermissions[index]),
                  );
                } else {
                  return const Center(child: Text('لا توجد بيانات صلاحيات متاحة.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isFiltering = !isFiltering;
            if (!isFiltering) _removeFilter();
          });
        },
        child: Icon(
            isFiltering ? Icons.cancel : Icons.filter_alt,
            color: Colors.white),
        backgroundColor: MyColors.color,
      ),
    );
  }

  Widget _buildFilterUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: filterController,
                  decoration: InputDecoration(
                    labelText: 'البحث بنوع الصلاحية',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: fromDate == null
                              ? Colors.purple
                              : MyColors.color),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: fromDate == null
                              ? Colors.purple
                              : MyColors.color),
                    ),
                  ),
                  onChanged: _applyFilter,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: _removeFilter,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildDateSelector(
                  label: fromDate == null ? 'من تاريخ' : formatDate(fromDate),
                  isFrom: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateSelector(
                  label: toDate == null ? 'إلى تاريخ' : formatDate(toDate),
                  isFrom: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector({required String label, required bool isFrom}) {
    DateTime? selectedDate = isFrom ? fromDate : toDate;
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          textDirection: TextDirection.rtl,
        );
        if (picked != null) {
          setState(() {
            if (isFrom) {
              fromDate = picked;
            } else {
              toDate = picked;
            }
          });
          _applyFilter(filterController.text);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(
              color: selectedDate == null ? Colors.purple : MyColors.color),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Icon(Icons.date_range,
                color: selectedDate == null ? Colors.purple : MyColors.color),
          ],
        ),
      ),
    );
  }
}
