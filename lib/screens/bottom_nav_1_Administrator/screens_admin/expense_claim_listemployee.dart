import 'package:chart_harakia/screens/admin_services/Expenseclaimemployee.dart';
import 'package:chart_harakia/screens/admin_services/claim_expense_submit.dart';
import 'package:chart_harakia/screens/admin_services/paymentpaymodeofpayment.dart';
import 'package:chart_harakia/screens/admin_services/selectedexpensetypeclaimexpense.dart';
import 'package:chart_harakia/screens/admin_services/tablepaycreatescreenfetched.dart';
import 'package:chart_harakia/widgets/customedropdowntable.dart';
import 'package:chart_harakia/widgets/employeedropdown.dart';
import 'package:chart_harakia/widgets/manadatorypostingdatetable.dart';
import 'package:chart_harakia/widgets/newusedCustominputfield.dart';
import 'package:chart_harakia/widgets/paymentpaysnackbar.dart';
import 'package:chart_harakia/widgets/snackbarpaymentpaysucessful.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:chart_harakia/widgets/customdynamicdropdown.dart';
import 'package:chart_harakia/widgets/readonlyfield.dart';
import 'package:flutter/material.dart';

class ExpenseClaimListemployee extends StatefulWidget {
  final dynamic paymentItem;
  const ExpenseClaimListemployee({Key? key, this.paymentItem}) : super(key: key);

  @override
  _ExpenseClaimListemployeeState createState() => _ExpenseClaimListemployeeState();
}

class _ExpenseClaimListemployeeState extends State<ExpenseClaimListemployee> {
  String? _selectedstatus;
  String? _selectedModeOfPayment;
  List<String> _modeOfPaymentOptions = [];
  bool _isModeOfPaymentLoading = true;

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
    _fetchModeofPayment();
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

          final selected = _employeeList.firstWhere(
            (emp) => emp['name'] == widget.paymentItem?['employee_name'],
            orElse: () => {},
          );
          if (selected.isNotEmpty) {
            _selectedEmployeeId = selected['id'];
          }

          _isEmployeeLoading = false;
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

  Future<void> _fetchModeofPayment() async {
    try {
      final service = modeofpaymentServiceGet();
      final result = await service.fetchmodeofpaymentservice();
      if (result != null && result.isNotEmpty) {
        setState(() {
          _modeOfPaymentOptions = result.map<String>((item) => item['name'].toString()).toList();
          _isModeOfPaymentLoading = false;
        });
      } else {
        setState(() {
          _modeOfPaymentOptions = [];
          _isModeOfPaymentLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching mode of payment: $e");
      setState(() {
        _modeOfPaymentOptions = [];
        _isModeOfPaymentLoading = false;
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
    if (_selectedEmployeeId == null || _selectedstatus == null || _selectedModeOfPayment == null) {
      showpaymentCustomSnackbar(context, "من فضلك أكمل جميع الحقول المطلوبة (*)", backgroundColor: Colors.red);
      return;
    }

    if (_expenseTableEntries.isEmpty ||
        _expenseTableEntries.any((entry) =>
            entry.selectedDate == null ||
            entry.selectedExpenseClaimType == null ||
            entry._secondAmountController?.text.isEmpty == true)) {
      showpaymentCustomSnackbar(context, "من فضلك أدخل بيانات التاريخ، النوع، والمبلغ في جدول المصاريف", backgroundColor: Colors.red);
      return;
    }

    final formData = {
      "approval_status": _selectedstatus,
      "employee": _selectedEmployeeId,
      "mode_of_payment": _selectedModeOfPayment,
      "expenses": _expenseTableEntries.map((entry) {
        return {
          "expense_date": entry.selectedDate?.toIso8601String() ?? "",
          "amount": double.tryParse(entry._secondAmountController?.text ?? "0"),
          "sanctioned_amount": double.tryParse(entry._secondAmountController?.text ?? "0"),
          "expense_type": entry.selectedExpenseClaimType,
          "description": entry._descriptionController?.text ?? "",
        };
      }).toList(),
      "advances": [
        {
          "employee_advance": widget.paymentItem?['name'],
          "posting_date": widget.paymentItem?['posting_date'],
          "advance_paid": widget.paymentItem?['advance_amount'] ?? 0.0,
          "unclaimed_amount": widget.paymentItem?['advance_amount'] ?? 0.0,
          "allocated_amount": widget.paymentItem?['paid_amount'] ?? 0.0,
        }
      ]
    };

    try {
      final service = ClaimExpenseSubmit();
      bool success = await service.submitData(formData);
      if (success) {
        showpaymentsuccessfulCustomSnackbar(context, "تم إرسال البيانات بنجاح", backgroundColor: MyColors.color);
        setState(() {
          _selectedstatus = null;
          _selectedEmployeeId = null;
          _selectedModeOfPayment = null;
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
                CustomDatePickertablemanadatory(
                  labelText: 'تاريخ المصروف *',
                  selectedDate: entry.selectedDate,
                  onDateChanged: (newDate) {
                    setState(() {
                      entry.selectedDate = newDate;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
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
    final paymentItem = widget.paymentItem;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.color,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'قسيمة مطالبة بالمصاريف',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ReadOnlyInputField(labelText: "*رقم المستند", value: paymentItem['document_name'] ?? ''),
              ReadOnlyInputField(labelText: "البريد الإلكتروني", value: paymentItem['posting_date'] ?? ''),
              ReadOnlyInputField(labelText: "المبلغ المقدم", value: paymentItem['advance_amount']?.toString() ?? ''),
             
              ReadOnlyInputField(labelText: "المبلغ المدفوع", value: paymentItem['paid_amount']?.toString() ?? ''),

              SizedBox(height: 20),
              _isModeOfPaymentLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomDropdownDynamic(
                      labelText: "طريقة الدفع *",
                      value: _selectedModeOfPayment,
                      items: _modeOfPaymentOptions,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedModeOfPayment = newValue;
                        });
                      },
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
                      _expenseTableEntries.add(ExpenseTableEntry());
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
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: MyColors.color,
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 120.0),
                    ),
                    child: Text(
                      'إرسال',
                      style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 14),
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
