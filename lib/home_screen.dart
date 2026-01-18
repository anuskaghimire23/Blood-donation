
import 'package:blooddonation/core/route.dart';
import 'package:blooddonation/core/route_generator.dart';
import 'package:blooddonation/core/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, 
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Color(0xFFFFCDD2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        welcometxt, 
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      GestureDetector(
        onTap: () {
          RouteGenerator.navigateToPage(context, Routes.ProfilePage);
        },
        child:  CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/images/profile.jpeg'), 
          backgroundColor: Colors.white,
        ),
      ),
    ],
  ),
),



Container(
  margin: const EdgeInsets.symmetric(horizontal: 16.0),
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Your Blood Donation Status",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _StatItem(label: "Total Donations", value: "4"),
          _StatItem(label: "Last Donated", value: "May 12, 2025"),
        ],
      ),
      const SizedBox(height: 16),
      const Text(
        "\"Blood Donars are the real heros\"",
        style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 131, 125, 125)),
      )
    ],
  ),
),


              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(quickAction,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white)),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _QuickActionTile(
                      icon: Icons.search,
                      label: findDonor,
                      onTap: () {
                         RouteGenerator.navigateToPage(
                                            context, Routes.FindDonorPage);
                      },
                    ),
                    _QuickActionTile(
                      icon: Icons.bloodtype,
                      label: bookRequest,
                      onTap: () {
                           RouteGenerator.navigateToPage(
                                            context, Routes.BookRequestPage);
                      
                      },
                    ),
                    _QuickActionTile(
                      icon: Icons.list_alt,
                      label: myRequests,
                      onTap: () {
                         RouteGenerator.navigateToPage(
                                            context, Routes.MyRequestPage);
                      },
                    ),
                    _QuickActionTile(
                      icon: Icons.location_on,
                      label: centers,
                      onTap: () {
                         RouteGenerator.navigateToPage(
                                            context, Routes.Center);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Nearby Centers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(nearbyCenters,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(seeAll,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_hospital, color: Colors.red),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(Hospital,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(opens, style: TextStyle(fontSize: 13)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}















class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.redAccent)),
      ],
    );
  }
}
