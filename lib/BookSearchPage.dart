import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> searchResults = [];
  bool isLoading = false;

  // Perform search based on the input query
  void performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Book')
          .where('authorId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      final List<QueryDocumentSnapshot> filteredResults = snapshot.docs.where((doc) {
        String name = (doc['name'] ?? '').toString();
        String number = (doc['number'] ?? '').toString();
        String content = (doc['content'] ?? '').toString();

        return name.toLowerCase().contains(query.toLowerCase()) ||
            number.toLowerCase().contains(query.toLowerCase()) ||
            content.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        searchResults = filteredResults;
      });
    } catch (e) {
      showErrorSnackBar(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Display an error message
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Erreur lors de la recherche : $message"),
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "🔍 Rechercher par nom, number ou contenu...",
          hintStyle: TextStyle(color: Colors.purple.shade300),
          filled: true,
          fillColor: Colors.purple.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Icon(Icons.search, color: Colors.purple),
        ),
        onChanged: performSearch,
      ),
    );
  }

  // Result card widget
  Widget _buildResultCard(DocumentSnapshot ds) {
    return Card(
      elevation: 6.0,
      shadowColor: Colors.purple.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ds['name'] ?? 'Nom non disponible',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Number : ${ds['number'] ?? 'Non disponible'}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "📋 Contenu : ${ds['content'] ?? 'Non disponible'}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Rechercher des book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: searchResults.isEmpty
                      ? Center(
                          child: Text(
                            "Aucun résultat trouvé.",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) =>
                              _buildResultCard(searchResults[index]),
                        ),
                ),
        ],
      ),
    );
  }
}
