// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';


// class DatePickerExample extends StatefulWidget {
//   @override
//   _DatePickerExampleState createState() => _DatePickerExampleState();
// }

// class _DatePickerExampleState extends State<DatePickerExample> {
//   DateTime? selectedDate;

//   String get formattedDate {
//     if (selectedDate == null) return 'Select Date';
//     return DateFormat('yyyy-MM-dd').format(selectedDate!);
//   }  Future<void> pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Date Picker Example")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GestureDetector(
//           onTap: () {
//             pickDate(context);
//           },
//           child: TextFormField(
//             decoration: InputDecoration(
//               labelText: "Date of Birth",
//               hintText: "Select Date",
//               suffixIcon: Icon(Icons.calendar_today),
//             ),
//             controller: TextEditingController(text: formattedDate),
//           ),
//         ),
//       ),
//     );
//   }
// }
