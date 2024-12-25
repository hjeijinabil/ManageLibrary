import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutterproject/Screens/PayPalData.dart';  // Importation des identifiants PayPal

class PaypalPayment extends StatefulWidget {
  const PaypalPayment({super.key});

  @override
  State<PaypalPayment> createState() => PaypalPaymentState();
}

class PaypalPaymentState extends State<PaypalPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Image.asset(
          'assets/images/dollar.png',
          height: 40.0,
          width: 40.0,
          color: Colors.white,
        ),
        title: const Text(
          'Complete Your Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderDetailRow("Item Name", "Price"),
                    const Divider(),
                    _buildOrderDetailRow("Total", "\$50.00", isBold: true, fontSize: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/paypal.png',
                  height: 40.0,
                  width: 40.0,
                ),
                title: const Text(
                  "Pay with PayPal",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logique pour initier le paiement
                  _startPaymentProcess();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Proceed to Pay",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(String title, String value, {bool isBold = false, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

void _startPaymentProcess() {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Suppression des commandes de Firestore
  firestore.collection('commands').get().then((snapshot) {
    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
    }
  });

  // Générer un invoice number unique
  String invoiceNumber = DateTime.now().millisecondsSinceEpoch.toString();  

  // Lancer le processus de paiement PayPal
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: PayPalData.client_id,  // Remplace par ton client ID PayPal
        secretKey: PayPalData.secret_id, // Remplace par ton secret ID PayPal
        transactions: [
          {
            "amount": {
              "total": "5.00",  
              "currency": "USD",  
            },
            "description": "Paiement pour votre commande",
            "invoice_number": invoiceNumber,  // Utiliser le numéro de facture unique
            "item_list": {
              "items": [
                {
                  "name": "Articlee 1", 
                  "description": "Description de l'article 1",
                  "quantity": "1",
                  "price": "5.00",
                  "currency": "USD",
                },
              ]
            }
          }
        ],
        note: "Merci pour votre commande !",
        onSuccess: (Map params) {
          print("Paiement réussi: $params");
          // Afficher un message ou effectuer d'autres actions après un paiement réussi
          Navigator.pop(context);
        },
        onError: (error) {
          print("Erreur lors du paiement: $error");
          
          // Affichage de l'erreur dans un AlertDialog
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Erreur de paiement"),
              content: Text("Détails de l'erreur: $error"),  // Afficher l'erreur ici
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);  // Fermer la boîte de dialogue
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        },
        onCancel: () {
          print("Paiement annulé");
          Navigator.pop(context);
        },
      ),
    ),
  );
}

}
