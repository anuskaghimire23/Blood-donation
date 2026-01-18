
import 'package:blooddonation/core/color_utils.dart';
import 'package:blooddonation/core/route.dart';
import 'package:blooddonation/core/route_generator.dart';
import 'package:blooddonation/core/string_utils.dart';
import 'package:blooddonation/widget/custom_button.dart';
import 'package:blooddonation/widget/custom_text_formfield.dart';
import 'package:blooddonation/widget/customdropdownbutton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class registerPage extends StatefulWidget {
  registerPage({super.key});

  @override
  State<registerPage> createState() => _SignupState();
}

class _SignupState extends State<registerPage> {
  final _formKey = GlobalKey<FormState>();

  String? email, password, name, contact, address, gender;

  final genderList = ['Male', 'Female', 'Other'];
  final bloodType = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  String? selectedBloodType;

  bool showPassword = false;
  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titletxt,
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      CustomTextformfield(
                        labelText: namestr,
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? namevalidation : null;
                        },
                      ),
                      CustomTextformfield(
                        labelText: emailstr,
                        onChanged: (value) {
                          email = value.trim();
                        },
                        validator: (value) {
                          return value!.trim().isEmpty ? emailvalidation : null;
                        },
                      ),
                      CustomTextformfield(
                        labelText: passwordstr,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return passwordvalidation;
                          }
                          if (value.length < 6) {
                            return passwordvalidationstr;
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      CustomDropDownButton(
                        labelText: genderStr,
                        items: genderList,
                        validator: (value) =>
                            value == null ? gendervalidationStr : null,
                        onChanged: (value) => gender = value,
                      ),
                      CustomDropDownButton(
                        labelText: "Blood Group",
                        items: bloodType,
                        validator: (value) =>
                            value == null ? bloodGroupValidationStr : null,
                        onChanged: (value) => selectedBloodType = value,
                      ),
                      CustomTextformfield(
                        labelText: "Contact Number",
                        // keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          contact = value;
                        },
                        validator: (value) {
                          return value!.trim().isEmpty
                              ? contactvalidation
                              : null;
                        },
                      ),
                      CustomTextformfield(
                        labelText: "Address",
                        onChanged: (value) {
                          address = value;
                        },
                        validator: (value) {
                          return value!.trim().isEmpty
                              ? addressvalidation
                              : null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                agreeToTerms = value!;
                              });
                            },
                          ),
                          const Text(acceptancestr),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              acceptance,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: CustomButton(
                              backgroundColor: primaryColor,
                              child: Text(
                                registestr,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var data = {
                                    "name": name,
                                    "email": email,
                                    "password": password,
                                    "role": "user",
                                    "contact": contact,
                                    "address": address,
                                    "gender": gender,
                                    "bloodType": selectedBloodType,
                                  };

                                  try {
                                    FirebaseFirestore firestore =
                                        FirebaseFirestore.instance;
                                    firestore
                                        .collection("Register")
                                        .where("email", isEqualTo: email)
                                        .get()
                                        .then((value) async {
                                      if (value.docs.isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Email already exists!")),
                                        );
                                      } else {
                                        // If email does not exist, add the new user

                                        await firestore
                                            .collection("Register")
                                            .add(data);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text("Signup successful!")),
                                        );

                                        RouteGenerator.navigateToPage(
                                            context, Routes.loginRoute);
                                      }
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Failed !")),
                                    );
                                  }
                                }
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text("Or"),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset('assets/images/google.webp',
                                height: 30),
                          ),
                          SizedBox(width: 30),
                          Container(
                            width: 85,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset('assets/images/facebook.png',
                                height: 30),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Alreadystr),
                            GestureDetector(
                                onTap: () {
                                  RouteGenerator.navigateToPage(
                                      context, Routes.loginRoute);
                                },
                                child: Text(
                                  loginstr,
                                  style: TextStyle(
                                    decorationColor:
                                        const Color.fromARGB(255, 67, 66, 66),
                                    decoration: TextDecoration.underline,
                                    color: blueColor,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
