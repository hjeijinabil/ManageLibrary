import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Home.dart';
import 'package:flutterproject/services/database.dart';
import 'package:random_string/random_string.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _CommandState();
}

class _CommandState extends State<Book> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "AddBook",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              _buildTextField(
                controller: nameController,
                label: "Name",
                icon: Icons.person,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: numberController,
                label: " Number",
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: contentController,
                label: "Content",
                icon: Icons.shopping_cart,
                maxLines: 4,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> postInfoMap = {
                    "name": nameController.text,
                    "number": numberController.text,
                    "content": contentController.text,
                    "commandId": id,
                    "authorId": FirebaseAuth.instance.currentUser?.uid,
                  };
                  await DatabaseMethods().addBookDetails(postInfoMap, id);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 28, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Image.asset(
              //   'assets/images/commandfood.png',
              //   height: 150,
              //   width: 150,
              //   fit: BoxFit.contain,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.deepPurple[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }
}
