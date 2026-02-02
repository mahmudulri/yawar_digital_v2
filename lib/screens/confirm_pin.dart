// import 'package:arzan_digital/routes/routes.dart';
// import 'package:arzan_digital/screens/result_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:arzan_digital/controllers/language_controller.dart';
// import '../controllers/confirm_pin_controller.dart';
// import '../global_controller/languages_controller.dart';

// class ConfirmPinScreen extends StatefulWidget {
//   ConfirmPinScreen({super.key});

//   @override
//   State<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
// }

// class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
//   final ConfirmPinController confirmPinController = Get.put(
//     ConfirmPinController(),
//   );

//   final languageController = Get.find<LanguagesController>();

//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();

//     // Step 2: Request focus when the page loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).requestFocus(_focusNode);
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose(); // Don't forget to dispose the FocusNode
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     // ignore: deprecated_member_use
//     return WillPopScope(
//       onWillPop: () async {
//         confirmPinController.pinController.clear();
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           body: Container(
//             height: screenHeight,
//             width: screenWidth,
//             child: Obx(
//               () =>
//                   confirmPinController.isLoading.value == false &&
//                       confirmPinController.loadsuccess.value == false
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             print(
//                               confirmPinController.loadsuccess.value.toString(),
//                             );
//                           },
//                           child: Lottie.asset('assets/loties/pin.json'),
//                         ),
//                         Container(
//                           height: 50,
//                           child: Obx(
//                             () => Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   confirmPinController.isLoading.value ==
//                                               false &&
//                                           confirmPinController
//                                                   .loadsuccess
//                                                   .value ==
//                                               false
//                                       ? languageController.tr(
//                                           "CONFIRM_YOUR_PIN",
//                                         )
//                                       : languageController.tr("PLEASE_WAIT"),

//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 confirmPinController.isLoading.value == true &&
//                                         confirmPinController
//                                                 .loadsuccess
//                                                 .value ==
//                                             true
//                                     ? Center(
//                                         child: CircularProgressIndicator(
//                                           color: Colors.black,
//                                         ),
//                                       )
//                                     : SizedBox(),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // OTPInput(),
//                         Container(
//                           height: 40,
//                           width: 100,
//                           // color: Colors.red,
//                           child: TextField(
//                             focusNode: _focusNode,
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                             controller: confirmPinController.pinController,
//                             maxLength: 4,
//                             textAlign: TextAlign.center,
//                             keyboardType: TextInputType.phone,
//                             decoration: InputDecoration(
//                               counterText: '',
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.grey,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.grey,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               errorBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.grey,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               focusedErrorBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.grey,
//                                   width: 2.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                         SizedBox(height: 15),

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 confirmPinController.pinController.clear();
//                               },
//                               child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.grey,
//                                   ),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     languageController.tr("CANCEL"),

//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () async {
//                                 if (!confirmPinController.isLoading.value) {
//                                   if (confirmPinController
//                                           .pinController
//                                           .text
//                                           .isEmpty ||
//                                       confirmPinController
//                                               .pinController
//                                               .text
//                                               .length !=
//                                           4) {
//                                     Fluttertoast.showToast(
//                                       msg: "Enter your pin",
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.BOTTOM,
//                                       timeInSecForIosWeb: 1,
//                                       backgroundColor: Colors.black,
//                                       textColor: Colors.white,
//                                       fontSize: 16.0,
//                                     );
//                                   } else {
//                                     bool success = await confirmPinController
//                                         .verify();
//                                     if (success) {
//                                       Get.toNamed(resultscreen);
//                                     }
//                                   }
//                                 }
//                               },
//                               child: Container(
//                                 height: 60,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   border: Border.all(
//                                     width: 1,
//                                     color: Colors.grey,
//                                   ),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     languageController.tr("VERIFY"),

//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   : Center(
//                       child: Container(
//                         height: 250,
//                         width: 250,
//                         child: Lottie.asset('assets/loties/recharge.json'),
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OTPInput extends StatefulWidget {
//   @override
//   _OTPInputState createState() => _OTPInputState();
// }

// class _OTPInputState extends State<OTPInput> {
//   // Define controllers and focus nodes for each OTP box
//   late List<TextEditingController> _controllers;
//   late List<FocusNode> _focusNodes;

//   final ConfirmPinController confirmPinController = Get.put(
//     ConfirmPinController(),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _controllers = List.generate(4, (_) => TextEditingController());
//     _focusNodes = List.generate(4, (_) => FocusNode());
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }

//   // Function to handle text change and move focus
//   void _handleChange(String value, int index) {
//     if (value.length == 1) {
//       if (index < 3) {
//         FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//       } else {
//         FocusScope.of(context).unfocus();
//       }
//     }
//     _updatePinController();
//   }

//   void _updatePinController() {
//     String pin = _controllers.map((controller) => controller.text).join();

//     confirmPinController.pinController.text = pin;
//   }

//   // Function to reset all input fields
//   void _resetFields() {
//     confirmPinController.pinController.clear();
//     for (var controller in _controllers) {
//       controller.clear();
//     }
//     FocusScope.of(context).requestFocus(_focusNodes[0]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(4, (index) {
//               return SizedBox(
//                 width: 50,
//                 child: TextFormField(
//                   controller: _controllers[index],
//                   focusNode: _focusNodes[index],
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   maxLength: 1,
//                   decoration: InputDecoration(
//                     counterText: '',
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (value) => _handleChange(value, index),
//                 ),
//               );
//             }),
//           ),
//           SizedBox(height: 10),
//           GestureDetector(
//             onTap: _resetFields,
//             child: Icon(FontAwesomeIcons.rotateRight),
//           ),
//         ],
//       ),
//     );
//   }
// }
