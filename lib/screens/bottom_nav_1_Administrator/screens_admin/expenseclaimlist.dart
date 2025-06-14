import 'package:chart_harakia/screens/admin_services/expenseclaimlistservice.dart';

import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/expenserecievelistdetails.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'dart:math';

class Expenseclaimlist extends StatefulWidget {
  const Expenseclaimlist({super.key});

  @override
  State<Expenseclaimlist> createState() => _ExpenseclaimlistState();
}

class _ExpenseclaimlistState extends State<Expenseclaimlist> {
  Future<List<dynamic>?>? paymentDataFuture;
  List<dynamic> allPaymentData = [];
  List<dynamic> filteredPaymentData = [];
  Set<String> selectedCardIds = {};
  Map<String, Color> cardColors = {};
  TextEditingController filterController = TextEditingController();
  bool isFiltering = false;

  DateTime? fromDate;
  DateTime? toDate;
  String? statusFilter; // Add status filter variable

  @override
  void initState() {
    super.initState();
    paymentDataFuture = Expenseclaimlistservice().fetchexpenseclaimservice();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    final data = await paymentDataFuture;
    if (data != null && data.isNotEmpty) {
      setState(() {
        allPaymentData = data;
        filteredPaymentData = data;
      });
    }
  }

  void _applyFilter(String query) {
    setState(() {
      filteredPaymentData = allPaymentData.where((payment) {
        final nameMatch = payment['name'].toLowerCase().contains(query.toLowerCase());
        final paymentDate = DateTime.tryParse(payment['posting_date']);
        final fromMatch = fromDate == null || (paymentDate != null && paymentDate.isAfter(fromDate!.subtract(const Duration(days: 1))));
        final toMatch = toDate == null || (paymentDate != null && paymentDate.isBefore(toDate!.add(const Duration(days: 1))));
        final statusMatch = statusFilter == null || payment['status'] == statusFilter; // Add status match condition
        return nameMatch && fromMatch && toMatch && statusMatch;
      }).toList();
    });
  }

  void _removeFilter() {
    setState(() {
      isFiltering = false;
      filteredPaymentData = allPaymentData;
      filterController.clear();
      fromDate = null;
      toDate = null;
      statusFilter = null; // Reset the status filter
    });
  }

  Color _getRandomColor() {
    final List<Color> colorOptions = [
      Colors.blueAccent,
      MyColors.color,
      Colors.deepOrangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
    ];
    Random random = Random();
    return colorOptions[random.nextInt(colorOptions.length)];
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildPaymentCard(dynamic item) {
    String cardId = item['id'].toString();
    bool isSelected = selectedCardIds.contains(cardId);
    Color cardColor = isSelected ? cardColors[cardId] ?? MyColors.color : Colors.white;
    Color borderColor = cardColors[cardId] ?? MyColors.color;

    return KeyedSubtree(
      key: ValueKey(cardId),
      child: GestureDetector(
        onTap: () async {
          final Color randomColor = _getRandomColor();

          setState(() {
            selectedCardIds.add(cardId);
            cardColors[cardId] = randomColor;
          });

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Expenserecievelistdetails(paymentItem: item),
            ),
          );

          if (mounted) {
            setState(() {
              selectedCardIds.remove(cardId);
              cardColors.remove(cardId);
            });
          }
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.receipt_long, color: MyColors.color),
                            SizedBox(width: 8),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "${item['name']}",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MyColors.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.purpleAccent),
                            SizedBox(width: 8),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "المجموع الكلي: ${item['grand_total']}",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Icon(
                            Icons.open_in_new,
                            color: isSelected ? borderColor : MyColors.color,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                           Icon(
  Icons.start_rounded,
  color: item['status'] == 'Paid'
      ? Colors.green
      : (item['status'] == 'Draft' || item['status'] == 'Cancelled' || item['status'] == 'Unpaid')
          ? Colors.red
          : Colors.deepOrange,
),

                            const SizedBox(width: 8),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            " :حالة المستند  ${item['status']}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              color: item['status'] == 'Paid'
                                  ? Colors.green
                                  : (item['status'] == 'Draft' || item['status'] == 'Cancelled' || item['status'] == 'Unpaid')
                                      ? Colors.red
                                      : Colors.deepOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

 Widget _buildStatusFilter() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: Container(
      height: 40, // Set a fixed, smaller height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.purple,
          width: 1,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: statusFilter,
            hint: const Text(
              "اختار الحالة",
              style: TextStyle(fontSize: 13),
            ),
            onChanged: (value) {
              setState(() {
                statusFilter = value;
              });
              _applyFilter(filterController.text);
            },
            items: [
              'Paid',
              'UnPaid',
              'Draft',
              'Cancelled',
              'Other',
            ].map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(
                  status,
                  style: const TextStyle(fontSize: 12, color: Colors.purple),
                ),
              );
            }).toList(),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.purple),
            iconSize: 24,
            isExpanded: true,
          ),
        ),
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة مطالبات النفقات", textDirection: TextDirection.rtl),
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
          if (isFiltering)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: filterController,
                          decoration: InputDecoration(
                            labelText: 'البحث بالاسم',
                            contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: fromDate == null ? Colors.purple : MyColors.color,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: fromDate == null ? Colors.purple : MyColors.color,
                              ),
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
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: fromDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              textDirection: TextDirection.rtl,
                            );
                            if (picked != null) {
                              setState(() {
                                fromDate = picked;
                              });
                              _applyFilter(filterController.text);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: fromDate == null ? Colors.purple : MyColors.color),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fromDate == null ? 'من تاريخ' : formatDate(fromDate),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.date_range, color: fromDate == null ? Colors.purple : MyColors.color),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: toDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              textDirection: TextDirection.rtl,
                            );
                            if (picked != null) {
                              setState(() {
                                toDate = picked;
                              });
                              _applyFilter(filterController.text);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: toDate == null ? Colors.purple : MyColors.color),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  toDate == null ? 'إلى تاريخ' : formatDate(toDate),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.date_range, color: toDate == null ? Colors.purple : MyColors.color),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Add the status filter dropdown
                  _buildStatusFilter(),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<dynamic>?>( // Existing code for FutureBuilder...
              future: paymentDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => _buildShimmerCard(),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: filteredPaymentData.length,
                    itemBuilder: (context, index) =>
                        _buildPaymentCard(filteredPaymentData[index]),
                  );
                } else {
                  return const Center(child: Text("لا توجد بيانات دفع متاحة."));
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
          color: Colors.white,
        ),
        backgroundColor: MyColors.color,
      ),
    );
  }
}
