import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';


class AppPermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: MyTheme.white,
      appBar: AppBar(
        elevation:0,
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text("APP PERMISSIONS", style: TextStyle(
          color: MyTheme.secondryColor,
        ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: MyTheme.secondryColor,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: AppPermissionForm(),
      
    );
  }
}


class AppPermissionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
       padding: const EdgeInsets.only(top:10),
      child: ListView(
        children: [
          ListTile(
            leading: Card(
              elevation: 8,
              color: MyTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),), 
              child: Image.asset(CAMERA_ASSET,
              height: 35, width: 35,)),
            title: Text("Camera", style:TextStyle(
              fontWeight:FontWeight.bold,
              fontSize:18)),
            trailing:
            // CustomSwitch(
            //   activeColor: MyTheme.primaryColor,
            //   value: true,
            //   onChanged: (val){},
            // )
            
             Switch(
             hoverColor: MyTheme.white,
              activeColor: MyTheme.primaryColor,
              value: true, onChanged: (val){}),
          ),
          ListTile(
            leading: Card(
              elevation: 8,
              color: MyTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),), 
              child: Image.asset(LOCATION_SECONDRY_ASSET,
              height: 35, width: 35,)),
            title: Text("Location", style:TextStyle(
              fontWeight:FontWeight.bold,
              fontSize:18)),
            trailing:
            // CustomSwitch(
            //   activeColor: MyTheme.primaryColor,
            //   value: true,
            //   onChanged: (val){},
            // )
            
             Switch(
             hoverColor: MyTheme.white,
              activeColor: MyTheme.primaryColor,
              value: true, onChanged: (val){}),
          ),
          ListTile(
            leading: Card(
              elevation: 8,
              color: MyTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),), 
              child: Image.asset(MIC_ASSET,
              height: 35, width: 35,)),
            title: Text("Microphone", style:TextStyle(
              fontWeight:FontWeight.bold,
              fontSize:18)),
            trailing:
            // CustomSwitch(
            //   activeColor: MyTheme.primaryColor,
            //   value: true,
            //   onChanged: (val){},
            // )
            
             Switch(
             hoverColor: MyTheme.white,
              activeColor: MyTheme.primaryColor,
              value: true, onChanged: (val){}),
          ),
          ListTile(
            leading: Card(
              elevation: 8,
              color: MyTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),), 
              child: Image.asset(STORAGE_ASSET,
              height: 35, width: 35,)),
            title: Text("Storage", style:TextStyle(
              fontWeight:FontWeight.bold,
              fontSize:18)),
            trailing:
            // CustomSwitch(
            //   activeColor: MyTheme.primaryColor,
            //   value: true,
            //   onChanged: (val){},
            // )
            
             Switch(
             hoverColor: MyTheme.white,
              activeColor: MyTheme.primaryColor,
              value: true, onChanged: (val){}),
          )
        ],
      )
    );
  }

  
}