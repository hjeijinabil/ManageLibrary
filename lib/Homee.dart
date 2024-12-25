import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/AddBook.dart';
import 'package:flutterproject/BookSearchPage.dart';
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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Book available!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(
                    ds['name'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Number: ${ds['number']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Content: ${ds['content']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "Edit") {
                        EditPostDetails(ds.id, ds);
                      } else if (value == "Delete") {
                        DatabaseMethods().deleteBook(ds.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: "Edit", child: Text("Edit")),
                      const PopupMenuItem(value: "Delete", child: Text("Delete")),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Book()),
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CheckYour",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Library",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            // const Image(
            //   image: AssetImage('assets/images/fooddelivery.png'),
            //   height: 40,
            // ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookSearchPage()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(child: allCommandDetails()),
            ElevatedButton.icon(
              onPressed: () async {
                await signout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              icon: const Icon(Icons.logout, color: Colors.white, size: 24),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
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
        title: const Text(
          "Edit Details",
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
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
              decoration:
                  const InputDecoration(labelText: 'Enter new phone number'),
            ),
            TextFormField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Enter new content'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Map<String, dynamic> updateInfo = {
                "name": nameController.text,
                "number": numberController.text,
                "content": contentController.text,
              };
              await DatabaseMethods().updateBookDetails(id, updateInfo);
              Navigator.pop(context);
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
