import 'package:chart_harakia/screens/admin_services/Loanemployee.dart';
import 'package:chart_harakia/screens/admin_services/claim_expense_submit.dart';
import 'package:chart_harakia/widgets/customDatepicker.dart';
import 'package:chart_harakia/widgets/customdynamicdropdown.dart';
import 'package:chart_harakia/widgets/employeedropdown.dart';
import 'package:chart_harakia/widgets/inputcustomfield.dart';
import 'package:chart_harakia/widgets/paymentpaysnackbar.dart';
import 'package:chart_harakia/widgets/readonlyfield.dart';
import 'package:chart_harakia/widgets/snackbarpaymentpaysucessful.dart';
import 'package:flutter/material.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanCreateScreen extends StatefulWidget {
  @override
  _LoanCreateScreenState createState() => _LoanCreateScreenState();
}

class _LoanCreateScreenState extends State<LoanCreateScreen> {
  String? _selectedstatus;
  DateTime? _selectedPostingDate;
  DateTime? _selectedRepaymentStartDate;

  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _monthlyRepaymentController = TextEditingController();

  // ✅ Repayment Method Dropdown
  String? _selectedRepaymentMethod;
  final List<String> _repaymentMethods = [
    "Repay Fixed Amount per Period",
    "Repay Over Number of Periods",
  ];

  List<Map<String, String>> _employeeList = [];
  String? _selectedEmployeeId;
  bool _isEmployeeLoading = true;

  String? _fullName;
  bool _isFullNameLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFullName(); // must load first
    _fetchempolyeelist();
  }

  Future<void> _loadFullName() async {
    String name = await _extractFullName();
    setState(() {
      _fullName = name;
      _isFullNameLoading = false;
    });
    debugPrint("Decoded Full Name: $name");
  }

  Future<String> _extractFullName() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie');

    if (cookies != null) {
      List<String> cookieParts = cookies.split(';');
      for (var part in cookieParts) {
        part = part.trim();
        if (part.contains('full_name=')) {
          int index = part.indexOf('full_name=');
          String fullNameSegment = part.substring(index);
          String fullNameEncoded = fullNameSegment.substring('full_name='.length);
          try {
            return Uri.decodeComponent(fullNameEncoded);
          } catch (e) {
            return fullNameEncoded;
          }
        }
      }
    }
    return 'No full name found';
  }

  Future<void> _fetchempolyeelist() async {
    try {
      final service = Expenseclaimemployee();
      final result = await service.fetchexpenseclaimemployeeservice();

      if (result != null && result.isNotEmpty) {
        setState(() {
          _employeeList = result.map<Map<String, String>>((item) {
            return {
              'id': item['id'].toString(), // Employee ID (e.g., EMP-0001)
              'name': "${item['name']} (${item['id']})", // Show name + ID
            };
          }).toList();
          _isEmployeeLoading = false;
        });
      } else {
        setState(() {
          _employeeList = [];
          _isEmployeeLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _employeeList = [];
        _isEmployeeLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_selectedEmployeeId == null ||
        _selectedPostingDate == null ||
        _loanAmountController.text.isEmpty ||
        _monthlyRepaymentController.text.isEmpty ||
        _selectedRepaymentMethod == null ||
        _selectedRepaymentStartDate == null) {
      showpaymentCustomSnackbar(
        context,
        "من فضلك أكمل جميع الحقول المطلوبة (*)",
        backgroundColor: Colors.red,
      );
      return;
    }

    final formData = {
      "applicant_type": "Employee",
      "applicant": _selectedEmployeeId, // ✅ Only ID is sent
      "loan_type": "بنك التنميه",
      "posting_date": DateFormat("yyyy-MM-dd").format(_selectedPostingDate!),
      "loan_amount": _loanAmountController.text,
      "monthly_repayment_amount": _monthlyRepaymentController.text,
      "repayment_method": _selectedRepaymentMethod,
      "repayment_start_date": DateFormat("yyyy-MM-dd").format(_selectedRepaymentStartDate!),
    };

    debugPrint("Submitting Loan Form: $formData");

    try {
      final service = Loansubmitform();
      bool success = await service.submitData(formData);

      if (success) {
        showpaymentsuccessfulCustomSnackbar(
          context,
          "تم إرسال البيانات بنجاح",
          backgroundColor: MyColors.color,
        );

        setState(() {
          _selectedstatus = null;
          _selectedEmployeeId = null;
          _selectedPostingDate = null;
          _loanAmountController.clear();
          _monthlyRepaymentController.clear();
          _selectedRepaymentMethod = null;
          _selectedRepaymentStartDate = null;
        });
      } else {
        showpaymentCustomSnackbar(
          context,
          "فشل إرسال البيانات",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      showpaymentCustomSnackbar(
        context,
        "حدث خطأ أثناء إرسال البيانات",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Filter employees: remove extra spaces and check all parts
    final filteredEmployees = _employeeList.where((e) {
      if (_fullName == null) return false;

      final userParts = _fullName!
          .trim()
          .toLowerCase()
          .split(RegExp(r"\s+"))
          .where((p) => p.isNotEmpty)
          .toList();

      final empParts = e['name']!
          .trim()
          .toLowerCase()
          .split(RegExp(r"\s+"))
          .where((p) => p.isNotEmpty)
          .toList();

      return userParts.every((u) => empParts.contains(u));
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: AppBar(
          backgroundColor: MyColors.color,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // Arabic alignment
          children: [
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const Text(
                    "قسيمة إنشاء قرض",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _isFullNameLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "مرحباً، $_fullName",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Applicant Type (readonly)
            const ReadOnlyInputField(
              labelText: "نوع المتقدم *",
              value: "Employee",
            ),

            // ✅ Employee dropdown
            _isEmployeeLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomDropdownDynamicWithDisplay(
                        labelText: "الموظف *",
                        value: _selectedEmployeeId,
                        items: filteredEmployees.map((e) => e['id']!).toList(),
                        displayItems: filteredEmployees.map((e) => e['name']!).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedEmployeeId = newValue;
                          });
                        },
                      ),
                      if (_selectedEmployeeId != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "المعرف الوظيفي: $_selectedEmployeeId",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                    ],
                  ),

            const SizedBox(height: 20),

            // ✅ Posting Date field
            CustomDatePicker(
              labelText: "تاريخ القيد *",
              selectedDate: _selectedPostingDate,
              onDateChanged: (date) {
                setState(() {
                  _selectedPostingDate = date;
                });
              },
            ),

            const SizedBox(height: 20),
            CustomInputField(
              labelText: "مبلغ القرض *",
              controller: _loanAmountController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),
            CustomInputField(
              labelText: "مبلغ السداد الشهري *",
              controller: _monthlyRepaymentController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),
            CustomDropdownDynamic(
              labelText: "طريقة السداد *",
              value: _selectedRepaymentMethod,
              items: _repaymentMethods,
              onChanged: (newValue) {
                setState(() {
                  _selectedRepaymentMethod = newValue;
                });
              },
            ),

            const SizedBox(height: 20),
            CustomDatePicker(
              labelText: "تاريخ بدء السداد *",
              selectedDate: _selectedRepaymentStartDate,
              onDateChanged: (date) {
                setState(() {
                  _selectedRepaymentStartDate = date;
                });
              },
            ),

            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: MyColors.color,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 120.0,
                    ),
                  ),
                  child: const Text(
                    'إرسال',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
