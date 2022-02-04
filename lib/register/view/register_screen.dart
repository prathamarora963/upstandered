// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:upstanders/global/constants/asset_constants.dart';
// import 'package:upstanders/global/theme/colors.dart';

// import 'package:upstanders/register/view/view.dart';
// import 'package:upstanders/register/widgets/widgets.dart';

// class RegisterScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyTheme.secondryColor,
//       body: _RegisterForm()
//     );
//   }
// }
// class _RegisterForm extends StatefulWidget {
//   @override
//   __RegisterFormState createState() => __RegisterFormState();
// }

// class __RegisterFormState extends State<_RegisterForm> {
  
//   var _formKey = new GlobalKey<FormState>();

//   var numberController = new TextEditingController();

//   var _paymentCard = PaymentCard();

//   var _autoValidateMode = AutovalidateMode.disabled;

//   var _card = new PaymentCard();

//   @override
//   void initState() {
//     super.initState();
//     _paymentCard.type = CardType.Others;
//     numberController.addListener(_getCardTypeFrmNumber);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Column(
//     children: [
//       SizedBox(height: size.height * 0.1),
//       Container(
//         alignment: Alignment.center,
//         height: size.height * 0.2,
//         width: size.width * 0.4,
//         decoration: BoxDecoration(
//             color: MyTheme.primaryColor,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.black),
//           image:DecorationImage(
//               image:  AssetImage(LOGO_ASSET)
//             )
//         ),
        
//       ),
     
//       Expanded(
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child:Container(
//             alignment: Alignment.bottomCenter,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                    Padding(
//                      padding: const EdgeInsets.only(left:20.0),
//                      child: Text("GET STARTED",
//                       style: TextStyle(
//                         color: MyTheme.white,
//                         fontSize: 30, 
//                         fontWeight: FontWeight.bold),
//                       ),
//                    ),
//                    SizedBox(height:20),
//                    payCard(size),

//                 ],
//               ),
//             ),
//           )
//         ),
//       )
     
//     ],
//    );
//   }

//   Widget payCard(Size size){
//     return  Container(
//       decoration: BoxDecoration(
//           color: MyTheme.white,
//         borderRadius: BorderRadius.circular(30)
//       ),
//       child: new Form(
//           key: _formKey,
//           autovalidateMode: _autoValidateMode,
//           child: new Column(
//             children: <Widget>[
//              _paymentInput(),
//               new Container(
//                 alignment: Alignment.center,
//                 child: _registerButton(size),
//               )
//             ],
//           )),
//     );
//   }


//   _paymentInput(){
//     return Container(
//       padding: const EdgeInsets.all( 30.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("One Time Registration",
//             style: TextStyle(
//               color: MyTheme.secondryColor,
//               fontSize: 20, 
//               fontWeight: FontWeight.bold),
//             ),

//           SizedBox(height:20),

//           new TextFormField(
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 new LengthLimitingTextInputFormatter(16),
//                 new CardNumberInputFormatter()
//               ],
//               controller: numberController,
//               decoration: new InputDecoration(
//                   contentPadding: const EdgeInsets.all(8),
//                   focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.primaryColor, ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.grey,),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.red,),
//                 ),
//                 prefixIcon:   Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: new Image.asset(
//                     CARD_NUMBER_ASSET,
//                     width: 25.0,
//                     height: 20,
//                     // color: Colors.grey[600],
//                   ),
//                 ),
//                 // CardUtils.getCardIcon(_paymentCard.type),
//                 hintText: 'Credit Card Number',
//                hintStyle:  TextStyle(
//                   fontSize: 12,
//                   color: MyTheme.grey,
//                   fontWeight: FontWeight.bold),
                
//                   ),
//               onSaved: (String value) {
//                 print('onSaved = $value');
//                 print('Num controller has = ${numberController.text}');
//                 _paymentCard.number = CardUtils.getCleanedNumber(value);
//               },
//               validator: CardUtils.validateCardNum,
//             ),

//              new SizedBox(
//               height: 20.0,
//             ),
            
//             new TextFormField(
//               decoration:  InputDecoration(
//                 contentPadding: const EdgeInsets.all(8),
//                   focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.primaryColor, ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.grey,),
//                 ),
//                   errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.red,),
//                 ),
                
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child:  Image.asset(
//                    CARD_HOLDER_NAME_ASSET,
//                     width: 25.0,
//                     height: 20,
//                     // color: Colors.grey[600],
//                   ),
//                 ),
//                 hintText: 'CardHolder Name',
//                 hintStyle: TextStyle(
//                   fontSize: 12,
//                   color: MyTheme.grey,
                  
//                   fontWeight: FontWeight.bold),
//               ),
//               onSaved: (String value) {
//                 _card.name = value;
//               },
//               keyboardType: TextInputType.text,
//               validator: (String value) =>
//                   value.isEmpty ? "Strings.fieldReq" : null,
//             ),
//             new SizedBox(
//               height: 20.0,
//             ),
            
           
            
           
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Expanded(
//                  flex: 2,
//                  child:  new TextFormField(
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     new LengthLimitingTextInputFormatter(4),
//                     new CardMonthInputFormatter()
//                   ],
//                   decoration: new InputDecoration(
//                       contentPadding: const EdgeInsets.all(8),
//                       focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyTheme.primaryColor, ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyTheme.grey,),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: MyTheme.red,),
//                     ),
//                     prefixIcon: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child:  Image.asset(
//                          EXPIRE_DATE_ASSET,
//                           width: 25.0,
//                           height: 20,
//                           // color: Colors.grey[600],
//                         ),
//                       ),
//                     hintText: 'Expiry Date',
//                     hintStyle: TextStyle(
//                       fontSize: 12,
//                       color: MyTheme.grey,
//                       fontWeight: FontWeight.bold),
                      
//                       ),
//                   validator: CardUtils.validateDate,
//                   keyboardType: TextInputType.number,
//                   onSaved: (value) {
//                     List<int> expiryDate = CardUtils.getExpiryDate(value);
//                     _paymentCard.month = expiryDate[0];
//                     _paymentCard.year = expiryDate[1];
//                   },
//                 ),),

//               SizedBox(width:20),

//               Expanded(
                
//                 child: new TextFormField(
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 new LengthLimitingTextInputFormatter(3),
//               ],
//               decoration: new InputDecoration(
//                   contentPadding: const EdgeInsets.all(8),
//                   focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.primaryColor, ),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: MyTheme.grey,),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.red,),
//                 ),
                
//                 prefixIcon:Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child:  Image.asset(
//                    CARD_NUMBER_ASSET,
//                     width: 25.0,
//                     height: 20,
//                     // color: Colors.grey[600],
//                   ),
//                 ),
//                 hintText: 'CVV',
//                 hintStyle: TextStyle(
//                   fontSize: 12,
//                   color: MyTheme.grey,
//                   fontWeight: FontWeight.bold),
               
//               ),
//               validator: CardUtils.validateCVV,
//               keyboardType: TextInputType.number,
//               onSaved: (value) {
//                 _paymentCard.cvv = int.parse(value);
//               },
//             ),)

//              ],
//            ),
//             new SizedBox(
//               height: 10.0,
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the Widget is removed from the Widget tree
//     numberController.removeListener(_getCardTypeFrmNumber);
//     numberController.dispose();
//     super.dispose();
//   }

//   void _getCardTypeFrmNumber() {
//     String input = CardUtils.getCleanedNumber(numberController.text);
//     CardType cardType = CardUtils.getCardTypeFrmNumber(input);
//     setState(() {
//       this._paymentCard.type = cardType;
//     });
//   }

//   void _validateInputs() {
//     final FormState form = _formKey.currentState;
//     if (!form.validate()) {
//       setState(() {
//         _autoValidateMode =
//             AutovalidateMode.always; // Start validating on every change.
//       });
//       _showInSnackBar('Please fix the errors in red before submitting.');
//     } else {
//       form.save();
//       // Encrypt and send send payment details to payment gateway
//       _showInSnackBar('Payment card is valid');
//     }
//   }

//   Widget _registerButton(Size size) {
    
//     return InkWell(
//       onTap: (){
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context)
//            => CreatePasscodeScreen()));


           
//       },
//       child: Container(
//         height: size.height * 0.08 ,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: MyTheme.primaryColor,
//           // borderRadius: BorderRadius.only(
//           //   bottomLeft: Radius.circular(30) ,
//           //   bottomRight: Radius.circular(30) ,
//           // )
        

//         ),
//         child:  Text(
//            "REGISTER",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 17.0),
//           ),
//       ),
//     );
    
//   }

//   void _showInSnackBar(String value) {
//     ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
//       content: new Text(value),
//       duration: new Duration(seconds: 3),
//     ));
//   }
// }

