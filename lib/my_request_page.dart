
import 'package:blooddonation/core/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
        title: Text("My Requests",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('blood_requests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data?.docs ?? [];

          if (requests.isEmpty) {
            return Center(child: Text("No requests found."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var data = requests[index].data() as Map<String, dynamic>;
              String name = data['patientName'] ?? 'No Name';
              String bloodType= data['bloodType'] ?? 'Unknown';
              String status = data['status'] ?? 'Pending';

              Color statusColor;
              if (status == 'Accepted') {
                statusColor = Colors.green;
              } else if (status == 'Rejected') {
                statusColor = Colors.red;
              } else {
                statusColor = Colors.orange;
              }

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text("$name  ($bloodType)"),
                  subtitle: Text("Status: $status", style: TextStyle(color: statusColor)),
                  leading: Icon(Icons.bloodtype, color: statusColor),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
