
import 'package:blooddonation/core/color_utils.dart';
import 'package:blooddonation/core/dialougeBox.dart';
import 'package:blooddonation/core/route.dart';
import 'package:blooddonation/core/route_generator.dart';
import 'package:blooddonation/core/string_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loader = false;
  String  ? profilePhoto;
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); 
  }

  String? role, email, contact, gender, address, bloodgroup, name;
  @override
  void initState() {

    super.initState();
    _loadData(); 
  }

  Future<void> _loadData() async {
    setState(() {
      loader = true; 
    });
    await readRoleFromSharedPreferences();
    await readValueFromFirestore();
    setState(() {
      loader = false; 
    });
  }

  readRoleFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      role = prefs.getString("role");
      email = prefs.getString("email");
    });
  }

  readValueFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("Register")
        .where("email", isEqualTo: email)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        setState(() {
          contact = value.docs[0].data()['contact'];
          bloodgroup = value.docs[0].data()['bloodType'];
          gender = value.docs[0].data()['gender'];
          address = value.docs[0].data()['address'];
          name = value.docs[0].data()['name'];
        });
      } else {
        setState(() {
          loader = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFF3F3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Profile", style: TextStyle(color: Colors.black87)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: Stack(
          children: [
            ui(),
            // loader ? Loader.backdropFilter(context) : const SizedBox(),
            loader
                ? const Center(
                    child: SpinKitCircle(
                      color: Colors.redAccent,
                      size: 50,
                    ),
                  )
                : const SizedBox(),
            
            
          ],
        ));
  }

  Widget ui() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Avatar
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     border: Border.all(color: Colors.red, width: 3),
          //   ),
          //   child: const CircleAvatar(
          //     radius: 50,
          //     backgroundImage:
          //         AssetImage('assets/images/profile.jpeg'), // replace
          //   ),
          // ),
          // Profile Avatar with Edit Button
Stack(
  alignment: Alignment.bottomRight,
  children: [
    Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red, width: 3),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: profilePhoto != null
            ? NetworkImage(profilePhoto!)
            : const AssetImage('assets/images/profile.jpeg'),
      ),
    ),
    Positioned(
      child: GestureDetector(
        onTap: () {
        
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.edit_square,
            color: primaryColor,
            size: 20,
          ),
        ),
      ),
    ),
  ],
),
          const SizedBox(height: 14),
          Text(
            name ?? "User Name",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Blood Group: $bloodgroup",
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),

          const SizedBox(height: 30),

          // Custom Info Boxes
          _InfoBox(
            icon: Icons.phone,
            title: "Phone Number",
            value: contact ?? "Not Provided",
          ),
          _InfoBox(
            icon: Icons.email,
            title: "Email",
            value: email ?? "Not Provided",
          ),
          _InfoBox(
            icon: Icons.location_on,
            title: "Location",
            value: address ?? "Not Provided",
          ),
          _InfoBox(
            icon: Icons.location_on,
            title: "Gender",
            value: gender ?? "Not Provided",
          ),
          const _InfoBox(
            icon: Icons.person_outline,
            title: "Bio",
            value: "Helping hands save lives!",
          ),
          role != null && role == "admin"
              ? GestureDetector(
                  onTap: () {
                    RouteGenerator.navigateToPage(
                        context, Routes.ViewRequestPage);
                  },
                  child: const _InfoBox(
                    icon: Icons.person_outline,
                    title: "View",
                    value: "View Blood Requests",
                  ),
                )
              : const SizedBox(),

          GestureDetector(
            onTap: () {
              // Navigate to settings if needed
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.settings, color: Colors.redAccent),
                  SizedBox(width: 16),
                  Text(
                    "Account Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          

          // CustomProfileOptionsButton(
          //   icon: Icons.exit_to_app,
          //   data: logoutStr,
          //   onPressed: () {
          //     DialogBox.showConfirmBox(
          //         context: context,
          //         title: logoutStr,
          //         message: logoutConfirmStr,
          //         onCancelPressed: () {},
          //         onOkPressed: () async {
          //           SharedPreferences prefs =
          //               await SharedPreferences.getInstance();
          //           prefs.remove("isLoggedIn");
          //           prefs.remove("role");
          //           RouteGenerator.navigateToPageWithoutStack(
          //               context, Routes.loginRoute,
          //               arguments: true);
          //         });
          //   },
          // ),

          GestureDetector(
            onTap: () {
              DialogBox.showConfirmBox(
                context: context,
                title: logoutStr,
                message: logoutConfirmStr,
                onCancelPressed: () {},
                onOkPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("isLoggedIn");
                  prefs.remove("role");
                  RouteGenerator.navigateToPageWithoutStack(
                      context, Routes.loginRoute,
                      arguments: true);
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.arrow_circle_right_outlined,
                      color: Colors.redAccent),
                  SizedBox(width: 16),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoBox({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
