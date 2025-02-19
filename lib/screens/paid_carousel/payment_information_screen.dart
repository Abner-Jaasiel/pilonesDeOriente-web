import 'package:carkett/providers/payment_controller.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/custom_appbar_widget.dart';
import 'package:carkett/widgets/flutter_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PaymentInformationScreen extends StatelessWidget {
  final bool result;

  const PaymentInformationScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    PaymentController paymentController =
        Provider.of<PaymentController>(context);
    return Scaffold(
      appBar: CustomAppbarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result) ...[
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Payment Successful',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thank you for your purchase.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildDetailRow('Full Name', paymentController.legalName),
                    const SizedBox(height: 16),
                    _buildDetailRow('Identity', paymentController.identityId),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                        'Payment Method', paymentController.cardNumber),
                    const SizedBox(height: 16),
                    const Text(
                      "Purchase Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    Text(
                        "Price: ${getFormattedCurrency(paymentController.amountToPay, context)}"),
                    const SizedBox(height: 16),
                    _buildDetailRow('Shipping Company', ''),
                    const SizedBox(height: 40),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 500),
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FlutterMapWidget(
                            lat: paymentController.latitude,
                            long: paymentController.longitude,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 100,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Payment Failed',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'An error occurred during the payment. Please try again.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go("/");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
              child: const Text(
                "Home",
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (result) ...[
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Go Orders"),
                        content:
                            const Text("Your purchase has been confirmed!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).go("/orders");
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                ),
                child: const Text(
                  "Orders",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(value),
      ],
    );
  }
}
