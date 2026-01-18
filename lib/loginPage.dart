
import 'package:blooddonation/core/color_utils.dart';
import 'package:blooddonation/core/route.dart';
import 'package:blooddonation/core/route_generator.dart';
import 'package:blooddonation/core/spin_kit.dart';
import 'package:blooddonation/core/string_utils.dart';
import 'package:blooddonation/widget/custom_text_formfield.dart';
import 'package:shared_preferences/util/legacy_to_async_migration_util.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

class loginPage extends StatefulWidget {
  loginPage({super.key});

  @override
  State<loginPage> createState() => _LoginpageState();
}

class _LoginpageState extends State<loginPage> {
  String? email, password;
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool rememberMe = false;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ui(),
            loader  
            ? Loader.backdropFilter(context)  : const SizedBox()
          ],
        ));
  }

  Widget ui() {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextformfield(
                    labelText: emailstr,
                    // prefixIcon: Icon(Icons.email),
                    onChanged: (value) {
                      email = value.trim();
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return emailvalidation;
                      }
                      return null;
                    },
                  ),
                  CustomTextformfield(
                    labelText: passwordstr,
                    // prefixIcon: Icon(Icons.lock),
                    obscureText: !showPassword,
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
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              rememberMe = value! ? true : false;
                            });
                          }),
                      Text(checkbox),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: TextButton(
                            onPressed: () {
                              // RouteGenerator.navigateToPage(
                              //     context, Routes.forget_passwordRoute);
                            },
                            child: Text(
                              forget_passwordstr,
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loader = true;
                            });
                            Future.delayed(Duration(seconds: 2), () async {
                              FirebaseFirestore firestore =
                                  FirebaseFirestore.instance;
                              await firestore
                                  .collection("Register")
                                  .where("email", isEqualTo: email)
                                  .where("password", isEqualTo: password)
                                  .get()
                                  .then((value) async {
                                if (value.docs.isNotEmpty) {
                                  String userRole =
                                      value.docs[0].data()['role'];
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('role', userRole);
                                  await prefs.setString('email', email!);

                                  if (rememberMe) {
                                    // Obtain shared preferences.
                                    const SharedPreferencesOptions
                                        sharedPreferencesOptions =
                                        SharedPreferencesOptions();

                                    await migrateLegacySharedPreferencesToSharedPreferencesAsyncIfNecessary(
                                      legacySharedPreferencesInstance: prefs,
                                      sharedPreferencesAsyncOptions:
                                          sharedPreferencesOptions,
                                      migrationCompletedKey:
                                          'migrationCompleted',
                                    );
                                    await prefs.setBool('isLoggedIn', true);
                                  }
                                  const snackBar = SnackBar(
                                      content: Text('Logged in successfully'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  RouteGenerator.navigateToPageWithoutStack(
                                      context, Routes.bottomNavbarRoute);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text("Invalid email or password"),
                                    ),
                                  );
                                }
                                setState(() {
                                  loader = false;
                                });
                              }).catchError((error) {
                                setState(() {
                                  loader = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(snackBarstr),
                                  ),
                                );
                              });
                            });
                          }
                        },
                        child: Text(loginstr,
                            style:
                                TextStyle(color: Colors.white, fontSize: 25)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("OR"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset('assets/images/google.webp',
                              height: 30),
                        ),
                      ),
                      // Spacer(),
                      SizedBox(width: 30),
                      InkWell(
                        onTap: () {
                          //  print("Google button pressed");
                        },
                        child: Container(
                          width: 85,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset('assets/images/facebook.png',
                              height: 30),
                        ),
                      ),
                    ],
                  ),
                  //  Expanded(child: SizedBox()),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(accountstr),
                          GestureDetector(
                              onTap: () {
                                RouteGenerator.navigateToPage(
                                    context, Routes.registerRoute);

                                // Navigate to SignUpPage
                              },
                              child: Text(
                                registestr,
                                style: TextStyle(
                                  decorationColor:
                                      const Color.fromARGB(255, 107, 103, 103),
                                  decoration: TextDecoration.underline,
                                  color: primaryColor,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
