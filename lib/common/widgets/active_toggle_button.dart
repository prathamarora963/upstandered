import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';

class ActiveToggleButton extends StatelessWidget {
  final void Function()onChange;

  const ActiveToggleButton({Key key, this.onChange}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child:InkWell(
          onTap: onChange,
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 5),
            alignment: Alignment.center,
            height: size.height * 0.06,
            width: size.width * 0.34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
                color: MyTheme.primaryColor,
              border: Border.all(color:MyTheme.primaryColor, width: 3)

            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                
                Text("ACTIVE",
                  style: TextStyle(
                      color: MyTheme.black,
                     fontSize:  size.height * 0.025,//18
                      fontWeight: FontWeight.bold)),
                
                 Container(
                  
                  alignment: Alignment.center,
                  height: size.height * 0.04, //30
                  width: size.height * 0.04, //30
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyTheme.white,
                      border: Border.all(color:MyTheme.primaryColor, width: 3)),
                      child: Container(
                     height:size.height * 0.02, //15,
                     width: size.height * 0.02,//15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyTheme.primaryColor,
                        
                          )
                    ),
                ),

              ],
            ),
          ),
        )
      ),
    );
  }
}
