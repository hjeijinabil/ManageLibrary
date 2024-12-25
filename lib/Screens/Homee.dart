import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/SignInScreen.dart';
import 'package:flutterproject/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homee extends StatefulWidget {
  const Homee({super.key});

  @override
  State<Homee> createState() => _HomeeState();
}

class _HomeeState extends State<Homee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Stream? postsStream;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  getontheload() async {
    postsStream = await DatabaseMethods().getUserBook(userId);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allCommandDetails() {
    return StreamBuilder(
        stream: postsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name: ${ds['name']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.white),
                                          onPressed: () {
                                            EditPostDetails(ds.id, ds);
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.white),
                                          onPressed: () {
                                            DatabaseMethods().deleteBook(ds.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "Number: ${ds['number']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  "Content: ${ds['content']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "CheckYour",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Text(
              "Book",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Image(
            //   image: AssetImage('assets/images/fooddelivery.png'),
            //   height: 50,
            // ),
          ],
        ),
        
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: allCommandDetails()),
            
            
          ],
        ),
      ),
    );
  }

  Future<void> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la déconnexion : ${e.toString()}"),
        ),
      );
    }
  }

  Future<void> EditPostDetails(String id, DocumentSnapshot ds) {
    nameController.text = ds['name'];
    numberController.text = ds['number'];
    contentController.text = ds['content'];

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Edit Details",
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.cancel, color: Colors.red),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Enter new name'),
            ),
            TextFormField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Enter new  Number'),
            ),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Enter new content'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> updateInfo = {
                "name": nameController.text,
                "number":numberController.text,
                "content": contentController.text,
              };
              await DatabaseMethods().updateBookDetails(id, updateInfo).then((value) {
                Navigator.pop(context);
              });
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
