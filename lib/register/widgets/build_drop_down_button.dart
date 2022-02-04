import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';

class BuildDropDown extends StatelessWidget {
 

  final String selectedItem;
  final String category;
  final String assetPrefixIcon;
  final Widget dropDownWidget;
  const  BuildDropDown({Key key, 
  
  this.selectedItem, this.category, this.assetPrefixIcon, this.dropDownWidget}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      // color: Colors.red,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 0, right: 4),
        alignment: Alignment.center,
       
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                 
                  children: [
                     Padding(
                       padding: const EdgeInsets.all(7 ),
                       child: new Image.asset(
                        assetPrefixIcon,
                         width: 30.0,
                         height: 30,
                         // fit: BoxFit.cover,
                       ),
                     ),
                    // SizedBox(width:8),
                  
                    selectedItem == null
                    ? Flexible(
                        fit: FlexFit.loose,
                        child: Text(category,
                        style: TextStyle(
                          fontSize: 13,
                          color: MyTheme.grey,
                          fontWeight: FontWeight.bold)
                        ),
                      )
                    : Flexible(
                        fit: FlexFit.loose,
                        child: Text(selectedItem,
                          style: TextStyle(
                          fontSize: 13,
                          color: MyTheme.black,
                          fontWeight: FontWeight.bold)
                          ),
                      ),
                    ],
                ),
              ),dropDownWidget
              
          ],
        ),
      ),
    );
  }

  
}


