class BloodRequest {
  final String patientName;
  final String hospitalName;
  final String bloodType;
  final String gender;
  final String urgency;
  final String dob;
  final String contactPerson;
  final String contactNumber;
  final String status;
  // final Timestamp timestamp;

  BloodRequest({
    required this.patientName,
    required this.hospitalName,
    required this.bloodType,
    required this.gender,
    required this.urgency,
    required this.dob,
    required this.contactPerson,
    required this.contactNumber,
    required this.status,
    // required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'hospitalName': hospitalName,
      'bloodType': bloodType,
      'gender': gender,
      'urgency': urgency,
      'dob': dob,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'status': status,
      // 'timestamp': timestamp,
    };
  }
}
