import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
class SubmitComplaint extends StatefulWidget {
  const SubmitComplaint({super.key});
  @override
  State<SubmitComplaint> createState() => _SubmitComplaintState();
}
class _SubmitComplaintState extends State<SubmitComplaint> {
  late TextEditingController nameController;
  late TextEditingController jobController;
  late TextEditingController tittleController;
  late TextEditingController detailsController;
   TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); /// علشان أقدر أتحكم في حالة الـ Form وأعمل Validation للبيانات
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    jobController = TextEditingController();
    tittleController = TextEditingController();
    detailsController = TextEditingController();
  }
  @override
  void dispose() { /// بستخدمها علشان أحذف الـ Controllers من الذاكرة لما الصفحة تتقفل
    super.dispose();
    nameController.dispose();
    jobController.dispose();
    tittleController.dispose();
    detailsController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFECECEC),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        size: 30,
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF1E1E1E),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                ),
                const SizedBox(height: 60),
                /// ===== Blue Title Box =====
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff4A90E2),
                        Color(0xff5C9DED),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff3996da).withOpacity(0.9),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child:  Center(
                    child: Text(
                      context.l10n.submit_formal_complaint,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                /// ===== Form =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Customfield(
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return context.l10n.shouldnt_be_empty;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          controller: nameController,
                        hint: context.l10n.name,
                      ),
                      Gap(30),
                      Customfield(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return context.l10n.shouldnt_be_empty;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: jobController,
                        hint: context.l10n.job_department,
                      ),
                      Gap(30),
                      Customfield(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return context.l10n.shouldnt_be_empty;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        controller: tittleController,
                        hint: context.l10n.report_title,
                      ),
                      Gap(30),
                      SizedBox(
                        child: Customfield(
                          lines: 6,
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return context.l10n.shouldnt_be_empty;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          controller: detailsController,
                          hint: context.l10n.report_details,
                        ),
                      ),
                      SizedBox(height: 35),
                      /// Date Field
                      TextField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: context.l10n.date_of_complaint,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dateController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            });
                          }
                        },
                        ),
                      SizedBox(height: 35),
                      /// Send Button
                      SizedBox(
                        width: 140,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xff3e8dfb),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            context.l10n.send,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}