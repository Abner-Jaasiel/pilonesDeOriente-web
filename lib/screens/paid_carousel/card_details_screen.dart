import 'package:carkett/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:carkett/providers/payment_controller.dart';
import 'package:carkett/widgets/custom_textfield_widget.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  _CardDetailsScreenState createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '4242 4242 4242 4242';
  String expiryDate = '12/25';
  String cardHolderName = 'Abner Jaasiel Irias';
  String cvvCode = '123';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    PaymentController paymentController =
        Provider.of<PaymentController>(context);
    TextEditingController legalNameController = TextEditingController();
    TextEditingController cardNumberController = TextEditingController();
    legalNameController.text = paymentController.legalName;
    cardNumberController.text = paymentController.cardNumber;
    cardNumber = cardNumberController.text;
    cardHolderName = legalNameController.text;

    return Scaffold(
      appBar: AppBar(title: const Text("Información de Tarjeta")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monto a pagar: \$${paymentController.amountToPay}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                CreditCardWidget(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  cardBgColor: Colors.deepPurple,
                  glassmorphismConfig: Glassmorphism.defaultConfig(),
                  isHolderNameVisible: true,
                  onCreditCardWidgetChange: (CreditCardBrand brand) {},
                ),
                const SizedBox(height: 20),
                Text(
                  "Datos de la tarjeta",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: legalNameController,
                  hintText: "Nombre del titular",
                  filled: true,
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      cardHolderName = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: cardNumberController,
                  hintText: "Número de tarjeta",
                  filled: true,
                  prefixIcon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      cardNumber = value.replaceAll(' ', '');
                    });
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: "MM/AA",
                        prefixIcon: Icons.date_range,
                        filled: true,
                        keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          setState(() {
                            expiryDate = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        hintText: "CVV",
                        filled: true,
                        prefixIcon: Icons.lock,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            cvvCode = value;
                          });
                        },
                        onTap: () {
                          setState(() {
                            isCvvFocused = true;
                          });
                        },
                        /*   onEditingComplete: () {
                          setState(() {
                            isCvvFocused = false;
                          });
                        },*/
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    //!EL PROCESO DE PAGO AUN NO ESTA ACTIVO
                    //## aqui se realiza un proceso no funcional
                    final User? user = FirebaseAuth.instance.currentUser;
                    String firebaseUid = "";
                    if (user != null) {
                      firebaseUid = user.uid;
                      final bool result = await APIService()
                          .uploadPurchasedProducts(
                              legalName: paymentController.legalName,
                              location: paymentController.location,
                              userId: paymentController.userId,
                              locationDescription:
                                  paymentController.locationDescription,
                              provider: paymentController.provider,
                              identityId: paymentController.identityId,
                              cardNumber: paymentController.cardNumber,
                              amountToPay: paymentController.amountToPay,
                              subtotal: paymentController.subtotal,
                              shipping: paymentController.shipping,
                              productIds: paymentController.productIds,
                              lat: paymentController.latitude,
                              long: paymentController.longitude,
                              firebaseUid: firebaseUid,
                              paymentToken: "valid_token");
                      if (result) {
                        GoRouter.of(context).go('/buyer_info', extra: true);
                      } else {
                        GoRouter.of(context).go('/buyer_info', extra: false);
                        print("Hubo un problema al procesar la compra.");
                      }
                      if (_formKey.currentState!.validate()) {
                        print("Procesando pago...");
                      }
                    }
                  },
                  child: const Text(
                    "Pagar",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
