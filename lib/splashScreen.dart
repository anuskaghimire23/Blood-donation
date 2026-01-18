
import 'package:blooddonation/core/color_utils.dart';
import 'package:blooddonation/core/route.dart';
import 'package:blooddonation/core/route_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _version = '';

  void initState() {
    checkLoginStatus();
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    String cleanedVersion = info.version.split('+').first;
    setState(() {
      _version = 'v$cleanedVersion';
    });
  }

  Future<void> checkLoginStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      await Future.delayed(const Duration(seconds: 2));
      await FirebaseFirestore.instance.clearPersistence();
      await Future.delayed(const Duration(seconds: 2));
      if (isLoggedIn && prefs.getString('email') != null) {
        RouteGenerator.navigateToPageWithoutStack(
          context,
          Routes.bottomNavbarRoute,
        );
      } else {
        RouteGenerator.navigateToPageWithoutStack(
          context,
          Routes.OnboardingRoute,
        );
      }
    } catch (e) {
      print("Error checking login status: $e");
      RouteGenerator.navigateToPageWithoutStack(
        context,
        Routes.OnboardingRoute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Image.asset(
                          "assets/images/blood.webp",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CareConnect',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Version: Loading...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text(
                        'Version: Error',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      );
                    }
                    return Text(
                      'Version: ${snapshot.data?.version ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ]));
  }
}
