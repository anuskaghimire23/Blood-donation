
import 'package:blooddonation/core/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FindDonorPage extends StatefulWidget {
  const FindDonorPage({super.key});

  @override
  State<FindDonorPage> createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> {
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search name, blood group, or location',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
              )
            : const Text(
                "Find Donor",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          color: Colors.white,
          tooltip: "Back",
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchQuery = '';
                _searchController.clear();
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            tooltip: "Search",
            color: Colors.white,
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Register').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No donors found.'));
                  }

                  // Filter donors
                  final donors = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name']?.toString().toLowerCase() ?? '';
                    final blood = data['bloodType']?.toString().toLowerCase() ?? '';
                    final location = data['address']?.toString().toLowerCase() ?? '';
                    return name.contains(_searchQuery) ||
                        blood.contains(_searchQuery) ||
                        location.contains(_searchQuery);
                  }).toList();

                  if (donors.isEmpty) {
                    return const Center(child: Text('No matching donors found.'));
                  }

                  return ListView.builder(
                    itemCount: donors.length,
                    itemBuilder: (context, index) {
                      final donor = donors[index].data() as Map<String, dynamic>;
                      final firstLetter = (donor['name']?.isNotEmpty ?? false)
                          ? donor['name'][0].toUpperCase()
                          : '?';

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text(
                              firstLetter,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(donor['name'] ?? 'Unknown'),
                          subtitle: Text(
                            "Blood: ${donor['bloodType'] ?? 'N/A'} | Location: ${donor['address'] ?? 'N/A'}",
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              // try {
                              //   await FirebaseFirestore.instance
                              //       .collection('Requests')
                              //       .add({
                              //     'donorEmail': donor['email'] ?? '',
                              //     'requestTime': Timestamp.now(),
                              //     'status': 'pending',
                              //   });

                              //   if (context.mounted) {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content: Text('Request sent successfully!'),
                              //       ),
                              //     );
                              //   }
                              // } catch (e) {
                              //   if (context.mounted) {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(content: Text('Error: $e')),
                              //     );
                              //   }
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Request",
                              style: TextStyle(color: Colors.white),
                            ),
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
}
