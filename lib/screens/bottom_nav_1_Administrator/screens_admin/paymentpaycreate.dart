import 'package:chart_harakia/screens/admin_services/CreatescreenPartytype_fetched.dart';
import 'package:chart_harakia/screens/admin_services/HelPrequestPaymentPay.dart';
import 'package:chart_harakia/screens/admin_services/accountpaidfrompaymententry.dart';
import 'package:chart_harakia/screens/admin_services/itempaymentpayservice.dart';
import 'package:chart_harakia/screens/admin_services/partylistservice.dart';
import 'package:chart_harakia/screens/admin_services/paymentpaymodeofpayment.dart';
import 'package:chart_harakia/screens/admin_services/paymentpaysubmissionrequest.dart';
import 'package:chart_harakia/screens/admin_services/tablepaycreatescreenfetched.dart';
import 'package:chart_harakia/widgets/customdropdownnonmanadatory.dart';
import 'package:chart_harakia/widgets/customedropdowntable.dart';
import 'package:chart_harakia/widgets/drpdownnonmanadatorytable.dart';
import 'package:chart_harakia/widgets/newusedCustominputfield.dart';
import 'package:chart_harakia/widgets/notmanadadatorypostingdate.dart';
import 'package:chart_harakia/widgets/paymentpaysnackbar.dart';
import 'package:chart_harakia/widgets/snackbarpaymentpaysucessful.dart';
import 'package:chart_harakia/widgets/tablenotmanadatoryinputfield.dart';
import 'package:flutter/material.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:chart_harakia/widgets/customdynamicdropdown.dart'; // Custom dropdown for table fields
import 'package:chart_harakia/widgets/customDatepicker.dart';
import 'package:chart_harakia/widgets/inputcustomfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PaymentPayScreen extends StatefulWidget {
  @override
  _PaymentPayScreenState createState() => _PaymentPayScreenState();
}

class _PaymentPayScreenState extends State<PaymentPayScreen> {
  String? _selectedType;
  String? _selectedParty;
  DateTime? _selectedDate;
  TextEditingController _paidAmountController = TextEditingController();

  String? _selectedPaymentMode;
  List<String> _paymentModes = [];
  bool _isPaymentModesLoading = true;

  


  DateTime? _selectedStartDate;
DateTime? _selectedEndDate;


  String? _selectedAccountPaid;
  List<String> _accountpaidList = [];
  bool _isAccountpaidLoading = true;

  bool _isLoading = true;
  bool _isPartyListLoading = false;

  String? _errorMessage;
  bool _hasTriedToSelectParty = false; // Track if user has tried to select a party without selecting type

  List<String> _partyTypes = [];
  List<String> _partyListItems = [];

  // New added list to handle dynamic "جدول الحساب"
  List<AccountTableEntry> _accountTableEntries = [AccountTableEntry()];
  List<String> _accountTableOptions = [];
  bool _isAccountTableLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPartyTypes();
    _fetchPaymentModes(); // Fetch payment modes
    _fetchpaidAccounts();
    _fetchAccountTableOptions(); // Fetch account table options
  }

  // Add these variables in your state class
  List<String> _itemsList = [];
  String? _selectedItem;
  bool _isItemsLoading = true;

  // Fetch items for the dropdown (in the dialog)
  Future<void> _fetchItems() async {
    try {
      final service = itemServiceGet();
      final result = await service.fetchpaymentgetservice();

      if (result != null && result.isNotEmpty) {
        setState(() {
          _itemsList = result.map<String>((item) => item['name'].toString()).toList();
          _isItemsLoading = false;
        });
      } else {
        setState(() {
          _itemsList = [];
          _isItemsLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching items list: $e");
      setState(() {
        _itemsList = [];
        _isItemsLoading = false;
      });
    }
  }


  List<String> _helperRequests = [];
String? _selectedHelperRequest; // dynamic can be replaced with String?
bool _isHelperRequestsLoading = false;

Future<void> _fetchHelperRequests() async {
  try {
    final service = Helprequestpaymentpay();
    final result = await service.Helprequestpaymentservice();

    if (result != null && result.isNotEmpty) {
      setState(() {
        _helperRequests = result.map<String>((item) => item['name'].toString()).toList();
        _isHelperRequestsLoading = false;
      });
    } else {
      setState(() {
        _helperRequests = [];
        _isHelperRequestsLoading = false;
      });
    }
  } catch (e) {
    print("Error fetching helper requests: $e");
    setState(() {
      _helperRequests = [];
      _isHelperRequestsLoading = false;
    });
  }
}



  Future<void> _fetchpaidAccounts() async {
    try {
      final service = accountpaidfromServiceGet();
      final result = await service.fetchaccountpaidfromservice();

      if (result != null && result.isNotEmpty) {
        setState(() {
          _accountpaidList = result.map<String>((item) => item['name'].toString()).toList();
          _isAccountpaidLoading = false;
        });
      } else {
        setState(() {
          _accountpaidList = [];
          _isAccountpaidLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching account list: $e");
      setState(() {
        _accountpaidList = [];
        _isAccountpaidLoading = false;
      });
    }
  }


Future<void> _submitForm() async {
  // Validate required main fields
  if (_selectedType == null ||
      _selectedParty == null ||
      _selectedDate == null ||
      _paidAmountController.text.isEmpty) {
    showpaymentCustomSnackbar(context, "من فضلك أكمل جميع الحقول المطلوبة (*)",
        backgroundColor: Colors.red);
    return;
  }

  // Validate start and end dates if they are selected
  if (_selectedStartDate != null && _selectedEndDate != null) {
    if (_selectedStartDate!.isAfter(_selectedEndDate!)) {
      showpaymentCustomSnackbar(context, "تاريخ البداية يجب أن يكون قبل تاريخ النهاية",
          backgroundColor: Colors.red);
      return;
    }
  }

  // Validate account table entries for mandatory fields
  if (_accountTableEntries.isEmpty ||
      _accountTableEntries.any((entry) =>
          entry.selectedAccount == null ||
          entry._secondAmountController?.text.isEmpty == true)) {
    showpaymentCustomSnackbar(
        context, "من فضلك أدخل بيانات الحساب والمبلغ في جدول الحساب",
        backgroundColor: Colors.red);
    return;
  }

  final formData = {
    "party_type": _selectedType,
    "paid_amount": double.tryParse(_paidAmountController.text) ?? 0.0,
    "party": _selectedParty,
    "posting_date": _selectedDate?.toIso8601String() ?? "",
    "payment_mode": _selectedPaymentMode,
    "account_paid_from": _selectedAccountPaid,
    "start_date": _selectedStartDate?.toIso8601String() ?? "",
    "end_date": _selectedEndDate?.toIso8601String() ?? "",
    "accounts_details": _accountTableEntries.map((entry) {
      return {
        "account": entry.selectedAccount ?? "",
        "amount": double.tryParse(entry._secondAmountController?.text ?? "0") ??
            0.0,
        "help_request": entry.selectedHelperRequest ?? "",
        "item_code": entry.itemsList?.isNotEmpty == true ? entry.itemsList![0] : "",
        "qty": double.tryParse(entry.qtyController?.text ?? "0") ?? 0.0,
        "beneficiaries_name": entry.beneficiaryNameController?.text ?? "",
      };
    }).toList(),
  };

  // Print formData for debugging
  print("Form Data being submitted:");
  print(formData);

  // Assuming your service is ready to submit the data to the backend
  try {
    final service = Paymentpaysubmissionrequest();
    bool success = await service.submitData(formData);

    if (success) {
      showpaymentsuccessfulCustomSnackbar(context, "تم إرسال البيانات بنجاح",
          backgroundColor: MyColors.color);

      // Clear all fields after successful submission
      setState(() {
        _selectedType = null;
        _selectedParty = null;
        _selectedDate = null;
        _paidAmountController.clear();
        _selectedPaymentMode = null;
        _selectedAccountPaid = null;
        _selectedStartDate = null;
        _selectedEndDate = null;
        _accountTableEntries = [AccountTableEntry()]; // Reset account table rows
      });
    } else {
      showpaymentCustomSnackbar(context, "فشل إرسال البيانات",
          backgroundColor: Colors.red);
    }
  } catch (e) {
    print("Error submitting form: $e");
    showpaymentCustomSnackbar(context, "حدث خطأ أثناء إرسال البيانات",
        backgroundColor: Colors.red);
  }
}



  Future<void> _fetchPaymentModes() async {
    try {
      final service = modeofpaymentServiceGet();
      final result = await service.fetchmodeofpaymentservice();

      if (result != null && result.isNotEmpty) {
        setState(() {
          _paymentModes = result.map<String>((item) => item['name'].toString()).toList();
          _isPaymentModesLoading = false;
        });
      } else {
        setState(() {
          _paymentModes = [];
          _isPaymentModesLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching payment modes: $e");
      setState(() {
        _paymentModes = [];
        _isPaymentModesLoading = false;
      });
    }
  }

  Future<void> _fetchPartyTypes() async {
    try {
      final service = PartytypeService();
      final result = await service.fetchPartyTypes();

      if (result != null && result.isNotEmpty) {
        setState(() {
          _partyTypes = result.map<String>((item) => item['name'].toString()).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'لا توجد أنواع حزب متاحة';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل تحميل البيانات: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPartyList(String? type) async {
    if (type == null) return;

    setState(() {
      _isPartyListLoading = true;
      _selectedParty = null;
      _partyListItems = [];
    });

    try {
      final service = PartyService();
      List<Map<String, dynamic>>? result;

      // Match Arabic names from API exactly
      if (type == 'Customer') {
        result = await service.fetchParty(); // Customers
      } else if (type == 'Donor') {
        result = await service.fetchDonors(); // Donors
      } else if (type == 'Student') {
        result = await service.fetchstudents(); // Students
      }else if (type == 'Member') {
        result = await service.fetchmember(); // Students
      }else if (type == 'Employee') {
        result = await service.fetchempployee(); // Students
      }else if (type == 'Supplier') {
        result = await service.fetchsupplier(); // Students
      }else if (type == 'Puplic Party') {
        result = await service.fetchpublicparty(); // Students
      }else if (type == 'Shareholder') {
        result = await service.fetchpublicshareholder(); // Students
      }
      

      if (result != null && result.isNotEmpty) {
        setState(() {
          _partyListItems = result!
              .map<String>((item) => item['name'].toString())
              .toList();
        });
      } else {
        setState(() {
          _partyListItems = [];
        });
      }
    } catch (e) {
      print("Error fetching party list: $e");
      setState(() {
        _partyListItems = [];
      });
    } finally {
      setState(() {
        _isPartyListLoading = false;
      });
    }
  }

  Future<void> _fetchAccountTableOptions() async {
    try {
      final service = Tablepaycreatescreenfetched();
      final result = await service.fetcbAccounttable();

      if (result != null && result.isNotEmpty) {
        setState(() {
          _accountTableOptions = result.map<String>((item) => item['name'].toString()).toList();
          _isAccountTableLoading = false;
        });
      } else {
        setState(() {
          _accountTableOptions = [];
          _isAccountTableLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching account table options: $e");
      setState(() {
        _accountTableOptions = [];
        _isAccountTableLoading = false;
      });
    }
  }

  // Widget to build each account table row
  Widget _buildAccountTableRow(int index) {
    final entry = _accountTableEntries[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: _isAccountTableLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Flexible(
                  child: CustomDropdownDynamicTable(
                    labelText: 'جدول الحساب *',
                    value: entry.selectedAccount,
                    items: _accountTableOptions,
                    onChanged: (newValue) {
                      setState(() {
                        entry.selectedAccount = newValue;
                      });
                    },
                  ),
                ),

                // Right: Edit/Delete Icons in a row, top-aligned
                Padding(
                  padding: const EdgeInsets.only(top: 15.0), // Adjust vertical alignment
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
                            _accountTableEntries.removeAt(index);
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

  void _showEditDialog(int index) async {
  await _fetchItems();
  await _fetchHelperRequests();

  // Get the existing entry
  final entry = _accountTableEntries[index];

  // Initialize controllers with existing values (if any)
  final _secondAmountController = TextEditingController(text: entry.secondAmountController?.text);
  final _qtyController = TextEditingController(text: entry.qtyController?.text);
  final _beneficiariesNameController = TextEditingController(text: entry.beneficiaryNameController?.text);
  String? _dialogSelectedItem = entry.itemsList?.isNotEmpty == true ? entry.itemsList![0] : null; // Initialize with existing item if available
  String? _dialogSelectedHelperRequest = entry.selectedHelperRequest;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('تفاصيل الحساب', style: TextStyle(fontWeight: FontWeight.w800, color: MyColors.color, fontSize: 14),
        
        ),
        
        content: _isItemsLoading
            ? SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              )
            : StatefulBuilder(
                builder: (BuildContext context, StateSetter setDialogState) {
                  return SizedBox(
                    width: double.maxFinite,
                    height: 450,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 40),
                        Drpdownnonmanadatorytable(
                          labelText: "المنتجات",
                          value: _dialogSelectedItem,
                          items: _itemsList,
                          onChanged: (newValue) {
                            setDialogState(() {
                              _dialogSelectedItem = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        CustomDropdownDynamicTable(
                          labelText: "الطلبات المساعدة",
                          value: _dialogSelectedHelperRequest,
                          items: _helperRequests,
                          onChanged: (newValue) {
                            setDialogState(() {
                              _dialogSelectedHelperRequest = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        CustomNewInputField(
                          labelText: 'المبلغ*',
                          controller: _secondAmountController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                       Tablenotmanadatoryinputfield(
                          labelText: 'الكمية',
                          controller: _qtyController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        Tablenotmanadatoryinputfield(
                          labelText: 'اسم المستفيد ',
                          controller: _beneficiariesNameController,
                          keyboardType: TextInputType.text,
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
                // Update the corresponding AccountTableEntry
                _accountTableEntries[index].itemsList = [_dialogSelectedItem ?? '']; // Store as a list
                _accountTableEntries[index].selectedHelperRequest = _dialogSelectedHelperRequest;
                _accountTableEntries[index]._secondAmountController = _secondAmountController;
                _accountTableEntries[index].qtyController = _qtyController;
                _accountTableEntries[index].beneficiaryNameController = _beneficiariesNameController;
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
                child: Text(
                  "إيصال دفع ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),

              // Loading and Error Messages for Party Type Dropdown
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                CustomDropdownDynamic(
                  labelText: "نوع الحزب *",
                  value: _selectedType,
                  items: _partyTypes,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                      // Clear party selection if type is changed
                      _selectedParty = null;
                      _hasTriedToSelectParty = false; // Reset error when type is changed
                    });
                    _fetchPartyList(newValue);
                  },
                ),

              

              // Show error if user tries to select party before selecting type
              if (_selectedType == null && _hasTriedToSelectParty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "من فضلك اختر نوع الحزب أولاً",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 20),
              // Party Type Dropdown Always Visible
              CustomDropdownDynamic(
                labelText: "اسم الطرف *",
                value: _selectedParty,
                items: _partyListItems,
                onChanged: (newValue) {
                  setState(() {
                    if (_selectedType == null) {
                      // Show error if user tries to select a party before selecting a type
                      _hasTriedToSelectParty = true;
                    } else {
                      _selectedParty = newValue;
                      _hasTriedToSelectParty = false; // Reset error when party is selected
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              CustomInputField(
                labelText: 'المبلغ المدفوع *',
                controller: _paidAmountController,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),

              CustomDatePicker(
                labelText: 'تاريخ الدفع *',
                selectedDate: _selectedDate,
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              SizedBox(height: 20),

              if (_isPaymentModesLoading)
                Center(child: CircularProgressIndicator())
              else
                Customdropdownnonmanadatory(
                  labelText: "طريقة الدفع ",
                  value: _selectedPaymentMode,
                  items: _paymentModes,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPaymentMode = newValue;
                    });
                  },
                ),
              SizedBox(height: 20),

              if (_isAccountpaidLoading)
                Center(child: CircularProgressIndicator())
              else
                Customdropdownnonmanadatory(
                  labelText: "الحساب المدفوع منه",
                  value: _selectedAccountPaid,
                  items: _accountpaidList,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAccountPaid = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
                Notmanadadatorypostingdate(
  labelText: 'تاريخ البداية',
  selectedDate: _selectedStartDate,
  onDateChanged: (date) {
    setState(() {
      _selectedStartDate = date;
    });
  },
),
 SizedBox(height: 20),

Notmanadadatorypostingdate(
  labelText: 'تاريخ النهاية',
  selectedDate: _selectedEndDate,
  onDateChanged: (date) {
    setState(() {
      _selectedEndDate = date;
    });
  },
),

              SizedBox(height: 40),

              Text(
                'جداول الحساب',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: MyColors.color, ),
              ),
              SizedBox(height: 20),

              ..._accountTableEntries.asMap().entries.map((entry) {
                int index = entry.key;
                return _buildAccountTableRow(index);
              }).toList(),
               SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: MyColors.color),
                  onPressed: () {
                    setState(() {
                      _accountTableEntries.add(AccountTableEntry());
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

SizedBox(height: 60), // Vertical space after the button


            ],
          ),
        ),
      ),
    );
  }


  
}



class AccountTableEntry {
  String? selectedAccount;
  TextEditingController? _secondAmountController; // Keep private
  String? selectedHelperRequest;
  List<String>? itemsList;

  TextEditingController? qtyController;
  TextEditingController? beneficiaryNameController;

  // Getter for secondAmountController to allow access outside the class
  TextEditingController? get secondAmountController => _secondAmountController;

  AccountTableEntry({
    this.selectedAccount,
    TextEditingController? secondAmountController,
    this.selectedHelperRequest,
    this.itemsList,
    this.qtyController,
    this.beneficiaryNameController,
  }) : _secondAmountController = secondAmountController;
}



