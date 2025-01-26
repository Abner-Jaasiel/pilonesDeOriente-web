import 'package:carkett/providers/payment_controller.dart';
import 'package:carkett/widgets/custom_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentController paymentController =
        Provider.of<PaymentController>(context);
    return Scaffold(
      appBar: CustomAppbarWidget(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Parte desplazable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Details",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // Widget de Tarjeta de Crédito
                      //  _creditCardWidget(),

                      const SizedBox(height: 24),

                      // Métodos de pago adicionales
                      _paymentOptions(context),

                      const SizedBox(height: 32),

                      // Resumen de la compra
                      _orderSummary(
                          paymentController.amountToPay,
                          paymentController.subtotal,
                          paymentController.shipping),
                    ],
                  ),
                ),
              ),

              // Botón Fijo
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción al confirmar la compra
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Confirm Purchase",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Reemplazado por Flutter Credit Card Widget
  Widget _creditCardWidget() {
    return CreditCardWidget(
      cardNumber: '4242 4242 4242 4242',
      expiryDate: '12/25',
      cardHolderName: 'Abner Jaasiel Irias',
      cvvCode: '123',
      showBackView: false, // Cambiar a true para mostrar el reverso
      isHolderNameVisible: true,
      onCreditCardWidgetChange: (CreditCardBrand brand) {
        // Maneja cambios en la tarjeta
      },
      cardBgColor: Colors.deepPurple,
      glassmorphismConfig: Glassmorphism.defaultConfig(),
    );
  }

  // Métodos de Pago Adicionales
  Widget _paymentOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Other Payment Options",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.paypal, color: Colors.blue),
          title: const Text("PayPal"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Acción al seleccionar PayPal
            GoRouter.of(context).push("/card_details");
          },
        ),
        ListTile(
          leading:
              const Icon(Icons.account_balance_wallet, color: Colors.green),
          title: const Text("Google Pay"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Acción al seleccionar Google Pay
            GoRouter.of(context).push("/map");
          },
        ),
      ],
    );
  }

  // Resumen de la Orden
  Widget _orderSummary(double total, double subtotal, double shipping) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal"),
              Text("\$1630.00"),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Shipping"),
              Text("\$500.00"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total"),
              Text(total.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
