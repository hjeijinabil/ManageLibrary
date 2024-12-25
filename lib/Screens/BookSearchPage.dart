import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Homee.dart';
import 'package:flutterproject/services/database.dart';
import 'package:random_string/random_string.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("AddBook",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body:Container(
        margin: EdgeInsets.only(left:20.0, top:30.0,right:20.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(
          "Name",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24
            ,fontWeight: FontWeight.bold),
            ),
        SizedBox(
          height:10.0
          ),
        Container(
          padding:EdgeInsets.only(left:10.0),
          decoration:BoxDecoration(
            color:Colors.blueGrey[100],
            borderRadius:BorderRadius.circular(10),
          ),
          child: TextField(
          controller :nameController,
decoration:InputDecoration(border:InputBorder.none),
          )
        ),
        SizedBox(height : 20.0,),
          Text(
          "Number",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24
            ,fontWeight: FontWeight.bold),
            ),
        SizedBox(
          height:10.0
          ),
        Container(
          padding:EdgeInsets.only(left:10.0),
          decoration:BoxDecoration(
            color:Colors.blueGrey[100],
            borderRadius:BorderRadius.circular(10),
          ),
          child: TextField(
            controller:numberController,
decoration:InputDecoration(border:InputBorder.none),
          )
        ),
        SizedBox(height : 20.0,),
          Text(
          "Content",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24
            ,fontWeight: FontWeight.bold),
            ),
        SizedBox(
          height:10.0
          ),
        Container(
          padding:EdgeInsets.only(left:10.0),
          decoration:BoxDecoration(
            color:Colors.blueGrey[100],
            borderRadius:BorderRadius.circular(10),
          ),
          child: TextField(
            controller:contentController,
decoration:InputDecoration(border:InputBorder.none),
          )
        ),
        SizedBox(height:60.0),
        Center(
          child: ElevatedButton(onPressed: () async {
          String Id = randomAlphaNumeric(10);
          Map<String,dynamic> postInfoMap = {

            "name":nameController.text,
            "number":numberController.text,
            "content":contentController.text,
            "BookId":Id,
            "authorId":FirebaseAuth.instance.currentUser?.uid
            
          };
          await DatabaseMethods().addBookDetails(postInfoMap, Id);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homee())
            );

          }, child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(width: 10.0),
              SizedBox(width: 10.0),
              Text(
                "Add",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,

                ),
              ),
              
            ],
          ),
          ),
        )
        
      ],
      ),
      ),

    );
  }
}
