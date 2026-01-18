
import 'package:blooddonation/core/color_utils.dart';
import 'package:blooddonation/core/route.dart';
import 'package:blooddonation/core/route_generator.dart';
import 'package:blooddonation/core/string_utils.dart';
import 'package:blooddonation/widget/custom_button.dart';
import 'package:flutter/material.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/donation.jpg",
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(
                        titlestr,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor),
                      ),
                    ),
                  ),
                  Container(
                    color:
                        Colors.black.withOpacity(0.2), // Light overlay effect
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      quotestr,
                      style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 99, 96, 96)),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: CustomButton(
                      backgroundColor: primaryColor,
                      child: Text(
                        registestr,
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      onPressed: () {
                        RouteGenerator.navigateToPage(
                            context, Routes.registerRoute);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Alreadystr,
                          style: TextStyle(fontSize: 15),
                        ),
                        GestureDetector(
                            onTap: () {
                              RouteGenerator.navigateToPage(
                                  context, Routes.loginRoute);
                            },
                            child: Text(
                              loginstr,
                              style: TextStyle(
                                  fontSize: 17,
                                  decorationColor: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  color: primaryColor),
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
    );
  }
}
