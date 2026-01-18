import 'package:blooddonation/core/string_utils.dart';
import 'package:blooddonation/widget/custom_button.dart';
import 'package:blooddonation/widget/custom_text_formfield.dart';
import 'package:blooddonation/widget/customdropdownbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class BookRequestPage extends StatefulWidget {
  BookRequestPage({super.key});

  @override
  State<BookRequestPage> createState() => _BookRequestPageState();
}

class _BookRequestPageState extends State<BookRequestPage> {
  final _formKey = GlobalKey<FormState>();
  String? patientName, hospitalName, contactPerson, contactNumber, dob, remarks;
  String? gender, urgency;

  bool isTermsAndConditionedAgreed = false;

  bool loader = false;

  final bloodType = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  String? selectedBloodType;
  final genderList = ['Male', 'Female', 'Other'];
  final urgentList = ['Low', 'Medium', 'High', 'Critical'];
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: const ColorScheme.light(
  //             primary: Colors.redAccent,
  //             onPrimary: Colors.white,
  //           ),
  //           dialogBackgroundColor: Colors.white,
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       dob = DateFormat('MM/dd/yyyy').format(picked);
  //       _dobController.text = dob!;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Blood Request",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Text("Select blood group",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 18,
                children: bloodType.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: selectedBloodType == type,
                    onSelected: (bool selected) {
                      if (bloodType == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please select a blood type")),
                        );
                        return;
                      }
                      setState(() {
                        selectedBloodType = selected ? type : null;
                      });
                    },
                  );
                }).toList(),
              ),
              CustomTextformfield(
                labelText: "Patient Name",
                onChanged: (value) {
                  patientName = value;
                },
                validator: (value) {
                  return value!.trim().isEmpty ? patientvalidation : null;
                },
              ),
              CustomTextformfield(
                labelText: "Hospital Name",
                onChanged: (value) {
                  hospitalName = value;
                },
                validator: (value) {
                  return value!.trim().isEmpty ? hospitalvalidation : null;
                },
              ),
              CustomTextformfield(
                labelText: "Contact person Name",
                onChanged: (value) {
                  contactPerson = value;
                },
                validator: (value) {
                  return value!.trim().isEmpty ? contactvalidationstr : null;
                },
              ),
              CustomTextformfield(
                labelText: "Contact Number",
                // keyboardType: TextInputType.phone,
                onChanged: (value) {
                  contactNumber = value;
                },
                validator: (value) {
                  return value!.trim().isEmpty ? contactvalidation : null;
                },
              ),
              CustomTextformfield(
                labelText: "Date of Birth",
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  dob = value;
                },
                validator: (value) {
                  return value!.trim().isEmpty ? dobvalidation : null;
                },
              ),
              CustomDropDownButton(
                labelText: genderStr,
                items: genderList,
                validator: (value) =>
                    value == null ? gendervalidationStr : null,
                onChanged: (value) => gender = value,
              ),
              CustomDropDownButton(
                labelText: urgencyStr,
                items: urgentList,
                validator: (value) =>
                    value == null ? urgencyvalidationStr : null,
                onChanged: (value) => urgency = value,
              ),
              CustomTextformfield(
                labelText: "Remarks",
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  remarks = value;
                },
              ),
              SizedBox(height: 25),
              CustomButton(
                width: MediaQuery.of(context).size.width * 0.95,
                backgroundColor: const Color(0xFFFF5A5F),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loader = true);

                    try {
                      await FirebaseFirestore.instance
                          .collection('blood_requests')
                          .add({
                        'patientName': patientName,
                        'hospitalName': hospitalName,
                        'bloodType': selectedBloodType,
                        'gender': gender,
                        'urgency': urgency,
                        'dob': dob,
                        'contactPerson': contactPerson,
                        'contactNumber': contactNumber,
                        'status': 'pending', // initial status
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      setState(() => loader = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Request submitted successfully!")),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields.")),
                    );
                  }
                },
                child: const Text(
                  "Book Request",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}





// // GestureDetector
// // Detects when the user taps the field.
// // On tap, we show a calendar using showDatePicker().

// // 2. AbsorbPointer
// // Prevents any touch interaction inside the CustomTextformfield (like the keyboard popping up).
// // We still show the field, but block editing directly.

// // 3. CustomTextformfield
// // Shows a text-like field.
// // Displays the selected date via a hintText.
// // The user cannot type into it — they must select from the calendar.






