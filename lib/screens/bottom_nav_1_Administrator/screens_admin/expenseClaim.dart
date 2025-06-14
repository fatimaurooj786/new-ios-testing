import 'package:chart_harakia/screens/admin_services/Expenseclaimemployee.dart';
import 'package:chart_harakia/screens/admin_services/claim_expense_submit.dart';
import 'package:chart_harakia/screens/admin_services/selectedexpensetypeclaimexpense.dart';
import 'package:chart_harakia/screens/admin_services/tablepaycreatescreenfetched.dart';
import 'package:chart_harakia/widgets/customedropdowntable.dart';
import 'package:chart_harakia/widgets/employeedropdown.dart';
import 'package:chart_harakia/widgets/manadatorypostingdatetable.dart';
import 'package:chart_harakia/widgets/newusedCustominputfield.dart';
import 'package:chart_harakia/widgets/paymentpaysnackbar.dart';
import 'package:chart_harakia/widgets/snackbarpaymentpaysucessful.dart';
import 'package:flutter/material.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:chart_harakia/widgets/customdynamicdropdown.dart';

class ExpenseClaimScreen extends StatefulWidget {
  @override
  _ExpenseClaimScreenState createState() => _ExpenseClaimScreenState();
}

class _ExpenseClaimScreenState extends State<ExpenseClaimScreen> {
  // Removed _selectedDate and _paidAmountController since unused
  String? _selectedstatus;

  List<ExpenseTableEntry> _expenseTableEntries = [ExpenseTableEntry()];
  List<String> _expenseTableOptions = [];
  bool _isExpenseTableLoading = true;

  List<String> _expenseClaimTypes = [];
  bool _isExpenseClaimTypesLoading = false;

  List<Map<String, String>> _employeeList = [];

  String? _selectedEmployeeId;
  bool _isEmployeeLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchempolyeelist();
    _fetchExpenseClaimTypes();
    _fetchExpenseTableOptions();
  }

  Future<void> _fetchempolyeelist() async {
  try {
    final service = Expenseclaimemployee();
    final result = await service.fetchexpenseclaimemployeeservice();
    if (result != null && result.isNotEmpty) {
      setState(() {
        _employeeList = result.map<Map<String, String>>((item) {
          return {
            'id': item['id'].toString(),
            'name': item['name'].toString(),
          };
        }).toList();
        _isEmployeeLoading = false; // <-- Correctly stop loading here
      });
    } else {
      setState(() {
        _employeeList = [];
        _isEmployeeLoading = false;
      });
    }
  } catch (e) {
    print("Error fetching employee list: $e");
    setState(() {
      _employeeList = [];
      _isEmployeeLoading = false;
    });
  }
}


  Future<void> _fetchExpenseClaimTypes() async {
    try {
      final service = Selectedexpensetypeclaimexpense();
      final result = await service.fetchexpenseclaimservice();
      if (result != null && result.isNotEmpty) {
        setState(() {
          _expenseClaimTypes = result.map<String>((item) => item['name'].toString()).toList();
          _isExpenseClaimTypesLoading = false;
        });
      } else {
        setState(() {
          _expenseClaimTypes = [];
          _isExpenseClaimTypesLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching expense claim types: $e");
      setState(() {
        _expenseClaimTypes = [];
        _isExpenseClaimTypesLoading = false;
      });
    }
  }

  Future<void> _fetchExpenseTableOptions() async {
    try {
      final service = Tablepaycreatescreenfetched();
      final result = await service.fetcbAccounttable();
      if (result != null && result.isNotEmpty) {
        setState(() {
          _expenseTableOptions = result.map<String>((item) => item['id'].toString()).toList();
          _isExpenseTableLoading = false;
        });
      } else {
        setState(() {
          _expenseTableOptions = [];
          _isExpenseTableLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching expense table options: $e");
      setState(() {
        _expenseTableOptions = [];
        _isExpenseTableLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    print("Submit button pressed");

    // Validate required top-level fields:
    if (_selectedEmployeeId == null || _selectedstatus == null) {
      showpaymentCustomSnackbar(context, "من فضلك أكمل جميع الحقول المطلوبة (*)", backgroundColor: Colors.red);
      return;
    }

    // Validate expense entries have date, type, and amount:
    if (_expenseTableEntries.isEmpty ||
        _expenseTableEntries.any((entry) =>
            entry.selectedDate == null ||
            entry.selectedExpenseClaimType == null ||
            entry._secondAmountController?.text.isEmpty == true)) {
      showpaymentCustomSnackbar(context, "من فضلك أدخل بيانات التاريخ، النوع، والمبلغ في جدول المصاريف", backgroundColor: Colors.red);
      return;
    }

    // Build form data
    final formData = {
      "approval_status": _selectedstatus,
      "employee": _selectedEmployeeId,
      "expenses": _expenseTableEntries.map((entry) {
        return {
          "expense_date": entry.selectedDate?.toIso8601String() ?? "",
          "amount": double.tryParse(entry._secondAmountController?.text ?? "0"),
          "expense_type": entry.selectedExpenseClaimType,
          "description": entry._descriptionController?.text ?? "",
        };
      }).toList(),
    };

    // Print the form data for debug
    print("Form Data to Submit: ${formData.toString()}");

    try {
      final service = ClaimExpenseSubmit();
      bool success = await service.submitData(formData);
      if (success) {
        showpaymentsuccessfulCustomSnackbar(context, "تم إرسال البيانات بنجاح", backgroundColor: MyColors.color);
        setState(() {
          _selectedstatus = null;
          _selectedEmployeeId = null;
          _expenseTableEntries = [ExpenseTableEntry()];
        });
      } else {
        showpaymentCustomSnackbar(context, "فشل إرسال البيانات", backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Error submitting form: $e");
      showpaymentCustomSnackbar(context, "حدث خطأ أثناء إرسال البيانات", backgroundColor: Colors.red);
    }
  }

  Widget _buildExpenseTableRow(int index) {
  final entry = _expenseTableEntries[index];

  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: _isExpenseTableLoading
        ? Center(child: CircularProgressIndicator())
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Use the custom date picker here
              CustomDatePickertablemanadatory(
                labelText: 'تاريخ المصروف *',
                selectedDate: entry.selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    entry.selectedDate = newDate;
                  });
                },
              ),

              // Edit & Delete Buttons
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: MyColors.color),
                      onPressed: () => _showEditDialog(index),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _expenseTableEntries.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
  );
}


  void _showEditDialog(int index) {
    final entry = _expenseTableEntries[index];
    // Initialize controllers if null to avoid errors
    final _secondAmountController = entry._secondAmountController ?? TextEditingController();
    final _descriptionController = entry._descriptionController ?? TextEditingController();
    String? _dialogSelectedExpenseClaimType = entry.selectedExpenseClaimType;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تفاصيل المصروف', style: TextStyle(fontWeight: FontWeight.w800, color: MyColors.color, fontSize: 14)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SizedBox(
                width: double.maxFinite,
                height: 350,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 20),
                    CustomDropdownDynamicTable(
                      labelText: "نوع مطالبة المصروفات *",
                      value: _dialogSelectedExpenseClaimType,
                      items: _expenseClaimTypes,
                      onChanged: (newValue) {
                        setDialogState(() {
                          _dialogSelectedExpenseClaimType = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CustomNewInputField(
                      labelText: 'الوصف',
                      controller: _descriptionController,
                    ),
                    SizedBox(height: 20),
                    CustomNewInputField(
                      labelText: 'المبلغ*',
                      controller: _secondAmountController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  entry.selectedExpenseClaimType = _dialogSelectedExpenseClaimType;
                  entry._secondAmountController = _secondAmountController;
                  entry._descriptionController = _descriptionController;
                });
                Navigator.of(context).pop();
              },
              child: Text('حفظ', style: TextStyle(fontSize: 12)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.0),
          child: AppBar(
            backgroundColor: MyColors.color,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Text("قسيمة مطالبة بالمصاريف", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              _isEmployeeLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomDropdownDynamicWithDisplay(
  labelText: "موظف *",
  value: _selectedEmployeeId,
  items: _employeeList.map((e) => e['id']!).toList(),
  displayItems: _employeeList.map((e) => e['name']!).toList(),
  onChanged: (newValue) {
    setState(() {
      _selectedEmployeeId = newValue;
    });
  },
),


              SizedBox(height: 20),
              CustomDropdownDynamic(
                labelText: "حالة الموافقة *",
                value: _selectedstatus,
                items: ['Approved', 'Draft', 'Rejected'],
                onChanged: (newValue) {
                  setState(() {
                    _selectedstatus = newValue;
                  });
                },
              ),
              SizedBox(height: 40),
              Text('المصاريف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: MyColors.color)),
              SizedBox(height: 20),
              ..._expenseTableEntries.asMap().entries.map((entry) => _buildExpenseTableRow(entry.key)).toList(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: MyColors.color),
                  onPressed: () {
                    setState(() {
                      _expenseTableEntries.add(ExpenseTableEntry(
                        
                      ));
                    });
                  },
                  child: Text('إضافة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 40),
            Center(
  child: SizedBox(
    height: 50,
    child: ElevatedButton(
      onPressed: _submitForm, // Function that gets called when the button is pressed
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color (white)
        backgroundColor: MyColors.color, // Background color using custom color
        padding: EdgeInsets.symmetric(
          vertical: 15.0, // Vertical padding of 15 units
          horizontal: 120.0, // Horizontal padding of 150 units
        ),
      ),
      child: Text(
        'إرسال', // Arabic for "Submit"
        style: TextStyle(
          fontWeight: FontWeight.w800, // Bold text style
          color: Colors.white, // Text color (white)
          fontSize: 14, // Font size of 13 units
        ),
      ),
    ),
  ),
),

SizedBox(height: 60),
],
),
),
),
);
}
}

class ExpenseTableEntry {
  DateTime? selectedDate;
  TextEditingController? _secondAmountController;
  TextEditingController? _descriptionController;
  String? selectedExpenseClaimType;

  TextEditingController? get secondAmountController => _secondAmountController;
  TextEditingController? get descriptionController => _descriptionController;

  ExpenseTableEntry({
    this.selectedDate,
    TextEditingController? secondAmountController,
    TextEditingController? descriptionController,
    this.selectedExpenseClaimType,
  })  : _secondAmountController = secondAmountController,
        _descriptionController = descriptionController;
}

