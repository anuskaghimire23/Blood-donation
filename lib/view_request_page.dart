import 'package:blooddonation/core/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRequestPage extends StatefulWidget {
  @override
  State<ViewRequestPage> createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<ViewRequestPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Blood Requests',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[100]!],
          ),
        ),
        
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextFormField(
                controller: _searchController,
                hintText: 'Search requests...',
                prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 71, 69, 69)),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('blood_requests')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red[700]),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No requests found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    );
                  }

                  // Filter requests based on search query
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    if (_searchQuery.isEmpty) return true;
                    return data.entries.any((entry) {
                      var value = entry.value?.toString().toLowerCase() ?? '';
                      return value.contains(_searchQuery);
                    });
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        'No matching requests found',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      var doc = filteredDocs[index];
                      var data = doc.data();
                      Map<String, dynamic> request =
                          Map<String, dynamic>.from(data as Map);

                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: Text(
                            'Patient: ${request['patientName'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              _buildInfoRow('Blood Group', request['bloodType']),
                              _buildInfoRow('Hospital', request['hospitalName']),
                              _buildInfoRow('Contact', request['contactNumber']),
                              _buildInfoRow('Contact Person', request['contactPerson']),
                              _buildInfoRow('DOB', request['dob']),
                              _buildInfoRow('Gender', request['gender']),
                              _buildInfoRow('Urgency', request['urgency']),
                              _buildInfoRow('Status', request['status']),
                              _buildInfoRow('Date Needed', request['dateNeeded']),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: request['status'] == 'pending'
                                        ? () {
                                            _updateRequestStatus(
                                                context, doc.id, 'Accepted');
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: request['status'] == 'pending'
                                        ? () {
                                            _updateRequestStatus(
                                                context, doc.id, 'Rejected');
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateRequestStatus(
      BuildContext context, String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('blood_requests')
          .doc(docId)
          .update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request $newStatus successfully'),
          backgroundColor: newStatus == 'Accepted' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating request: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Custom TextFormField widget
class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        hintStyle: TextStyle(color: Colors.grey[700]),
      ),
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 16,
        color: const Color.fromARGB(221, 37, 28, 28),
      ),
    );
  }
}