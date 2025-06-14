import 'package:chart_harakia/screens/admin_services/employee_advaceget.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/employee_advancedetailslist.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

class Employeeadvancelist extends StatefulWidget {
  const Employeeadvancelist({super.key});

  @override
  State<Employeeadvancelist> createState() => _EmployeeadvancelistState();
}

class _EmployeeadvancelistState extends State<Employeeadvancelist> {
  Future<List<dynamic>?>? paymentDataFuture;
  List<dynamic> allPaymentData = [];
  List<dynamic> filteredPaymentData = [];
  String? selectedCardId;
  Color? selectedCardColor;
  TextEditingController filterController = TextEditingController();
  bool isFiltering = false;

  @override
  void initState() {
    super.initState();
    paymentDataFuture = EmployeeAdvaceget().employeegetservice();
    _fetchPayments();
  }

  Future<void> _fetchPayments() async {
    final data = await paymentDataFuture;
    if (data != null && data.isNotEmpty) {
      final filtered = data.where((item) => item['paid_amount'] != null).toList();
      setState(() {
        allPaymentData = filtered;
        filteredPaymentData = filtered;
      });
    }
  }

  void _applyFilter(String query) {
    setState(() {
      filteredPaymentData = allPaymentData.where((payment) {
        final nameMatch = payment['name'].toLowerCase().contains(query.toLowerCase());
        return nameMatch;
      }).toList();
    });
  }

  void _removeFilter() {
    setState(() {
      isFiltering = false;
      filteredPaymentData = allPaymentData;
      filterController.clear();
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

  Widget _buildPaymentCard(dynamic item) {
    String cardId = item['id'].toString();
    bool isSelected = selectedCardId == cardId;
    Color cardColor = isSelected ? selectedCardColor ?? MyColors.color : Colors.white;
    Color borderColor = selectedCardColor ?? MyColors.color;

    return GestureDetector(
      onTap: () async {
        final Color randomColor = _getRandomColor();

        setState(() {
          selectedCardId = cardId;
          selectedCardColor = randomColor;
        });

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeAdvancedetailslist(paymentItem: item),
           ),
        );

        if (mounted) {
          setState(() {
            selectedCardId = null;
            selectedCardColor = null;
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
                          Icon(Icons.receipt_long, color: Colors.blue),
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
                          Icon(Icons.attach_money, color: Colors.green),
                          SizedBox(width: 8),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          "المبلغ المدفوع: ${item['paid_amount']}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Icon(
                          Icons.open_in_new,
                          color: isSelected ? selectedCardColor : MyColors.color,
                          size: 25,
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
                          Icon(Icons.person, color: Colors.deepOrange),
                          SizedBox(width: 8),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          "اسم الموظف: ${item['employee_name'] ?? 'غير متوفر'}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.deepOrange,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة المدفوعات", textDirection: TextDirection.rtl),
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: filterController,
                      decoration: InputDecoration(
                        labelText: 'البحث بالاسم',
                        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.color),
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
            ),
          Expanded(
            child: FutureBuilder<List<dynamic>?>(
              future: paymentDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => _buildShimmerCard(),
                  );
                } else if (snapshot.hasData && filteredPaymentData.isNotEmpty) {
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
