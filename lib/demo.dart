// if (showField())
//   TextFormField(
//     controller: lostitemlistcontroller,
//     keyboardType: selectedLossType == "Mobile"
//         ? TextInputType.phone
//         : TextInputType.text,

//     maxLength: selectedLossType == "Mobile" ? 10 : null,

//     decoration: InputDecoration(
//       label: RichText(
//         text: TextSpan(
//           text: getDynamicLabel(),
//           style: TextStyle(color: Colors.black),
//           children: [
//             TextSpan(text: " *", style: TextStyle(color: Colors.red)),
//           ],
//         ),
//       ),
//     ),

//     validator: (v) {
//       if (v == null || v.isEmpty) return getDynamicLabel();

//       if (selectedLossType == "Mobile" && v.length != 10) {
//         return "Enter valid 10-digit mobile number";
//       }

//       return null;
//     },
//   ),
