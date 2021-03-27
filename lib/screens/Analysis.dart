import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  var user;
  String URL1;
  Color final_color;
  var color1 =  Color(0xFFD50000);

  @override
  void initState() {

  getshopdata();

    super.initState();
  }
  getshopdata()async{
    //user = await FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").where("StoreName",isEqualTo:"Nike").get();
    FirebaseFirestore.instance.collection("Vendors").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.id == "SRMT"){
          FirebaseFirestore.instance
              .collection("Vendors")
              .doc("SRMT")
              .collection("SRMT")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              setState(() {
                if(result["StoreName"]=="Nike"){
                  user = result.data();
                  print(user);
                }

              });
            });
          });
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user["Current_strength"] <=
        user["Total_strength"] * 0.25) {
      final_color = Colors.lightGreenAccent;
    }
    else if (user["Total_strength"] * 0.25 <
        user["Current_strength"] &&
        user["Current_strength"] <=
            user["Total_strength"] * 0.75) {
      final_color = Colors.orange;
    }
    else if (user["Total_strength"] * 0.75 <
        user["Current_strength"] &&
        user["Current_strength"] <=
            user["Total_strength"]) {
      final_color = color1;
    }
    if(user["StoreName"]=="KFC")
      URL1 ="images/kfc.png";
    else if(user["StoreName"]=="Nike")
      URL1 ="images/nike1.png";

    return Scaffold(
      body: Column(
        children: [
          ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(URL1),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text(user["StoreName"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              subtitle: Text("Open Time: ${user["Timings"][0]}\nClose Time: ${user["Timings"][1]}",
                style: TextStyle(fontSize: 10),),

              trailing: Column(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: final_color,
                        borderRadius: BorderRadius.all(
                            Radius.circular(20))
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "${user["Current_strength"]}/${user["Total_strength"]}")
                ],
              )
          ),
        ],
      ),
    );
  }
}