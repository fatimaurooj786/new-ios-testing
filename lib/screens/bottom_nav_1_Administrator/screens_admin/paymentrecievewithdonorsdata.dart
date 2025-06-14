import 'package:chart_harakia/screens/admin_services/paymentrecievedonorsubmission.dart';
import 'package:chart_harakia/widgets/paymentpaysnackbar.dart';
import 'package:chart_harakia/widgets/snackbarpaymentpaysucessful.dart';
import 'package:flutter/material.dart';
import 'package:chart_harakia/widgets/readonlyfield.dart';
import 'package:chart_harakia/widgets/colors.dart';

class Paymentrecievewithdonorsdata extends StatelessWidget {
  final Map<String, dynamic> data;

  const Paymentrecievewithdonorsdata({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Helper to build non-empty read-only fields
    Widget buildField(String label, String key) {
      var value = data[key];
      if (value == null || value.toString().isEmpty || value == 'N/A') {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ReadOnlyInputField(labelText: label, value: value.toString()),
      );
    }

    // Submission function to ERP
    Future<void> _submitToERP() async {
      print("Preparing to submit data: $data");

      try {
        final service = Paymentrecievedonorsubmission();

        final double amount = double.tryParse(data["amount"].toString()) ?? 0;

        final submissionData = {
          "party_type": "Donor",
          "party": data["donor"],
          "posting_date": data["date"],
          "paid_amount": amount,
          "remarks": data["remarks"],
          "donation": data["name"],
          "accounts_details": [
            {
              "account": data["account_for_amount"],
              "amount": amount,
            }
          ]
        };

        print("Submitting to ERP: $submissionData");

        bool success = await service.submitData(submissionData);

        if (success) {
      showpaymentsuccessfulCustomSnackbar(context, "تم إرسال البيانات بنجاح",
          backgroundColor: MyColors.color);

      // Clear all fields after successful submission
      
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

    return Scaffold(
      appBar: AppBar(
  title: const Text(
    "إنشاء إيصال دفع",
    style: TextStyle(
      color: Colors.black, // ✅ Make title text black
      fontWeight: FontWeight.bold,
    ),
    textDirection: TextDirection.rtl,
  ),
  backgroundColor: Colors.white,
  automaticallyImplyLeading: false,
  actions: [
    IconButton(
      icon: const Icon(Icons.arrow_forward, color: Colors.black), // ✅ Black icon
      onPressed: () => Navigator.pop(context),
    ),
  ],
  iconTheme: const IconThemeData(color: Colors.black), // ✅ Ensures icon theme is black
),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    buildField("*رقم المستند", 'name'),
                    buildField("*نوع التبرع", 'donation_type'),
                    buildField("*رمز المتبرع", 'donor'),
                    buildField("*اسم المتبرع", 'donor_name'),
                    buildField("الموظف", 'employee'),
                    buildField("*المشروع", 'project'),
                    buildField("*الشركة", 'company'),
                    buildField("*التاريخ", 'date'),
                    buildField("الملاحظات", 'remarks'),
                    buildField("*الحساب", 'account_for_amount'),
                    buildField("المبلغ", 'amount'),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitToERP, // ✅ FIXED: Correct method name
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
          ],
        ),
      ),
    );
  }
}
