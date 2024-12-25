import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addBookDetails(
      Map<String, dynamic> commandInfoMap, String commandId) async {
    try {
      return await FirebaseFirestore.instance
          .collection('Book')
          .doc(commandId)
          .set(commandInfoMap);
    } catch (e) {
      print("Erreur lors de l'ajout du book : $e");
      throw e;
    }
  }


  Future<Stream<QuerySnapshot>> getBook() async {
    try {
      return await FirebaseFirestore.instance.collection('Book').snapshots();
    } catch (e) {
      print("Erreur lors de la récupération des book : $e");
      throw e;
    }
  }

  Future<Stream<QuerySnapshot>> getUserBook(String uid) async {
    try {
      return await FirebaseFirestore.instance
          .collection('Book')
          .where("authorId", isEqualTo: uid)
          .snapshots();
    } catch (e) {
      print("Erreur lors de la récupération des commands : $e");
      throw e;
    }
  }

  Future updateBookDetails(String id , Map<String,dynamic>updateInfo)  async{
    return await
    FirebaseFirestore
    .instance
    .collection("Book")
    .doc(id)
    .update(updateInfo);

  }


  Future deleteBook(String id) async {
    return await FirebaseFirestore.instance.collection("Book").doc(id).delete();
  }









  


}
