import 'package:carkett/generated/l10n.dart';
import 'package:carkett/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SellerSelectionScreen extends StatefulWidget {
  const SellerSelectionScreen({super.key});

  @override
  _SellerSelectionScreenState createState() => _SellerSelectionScreenState();
}

class _SellerSelectionScreenState extends State<SellerSelectionScreen> {
  late Future<String> generalData;
  late Future<String> premiumData;
  late Future<String> enterpriseData;

  @override
  void initState() {
    super.initState();
    generalData = _fetchSellerData('General');
    premiumData = _fetchSellerData('Premium');
    enterpriseData = _fetchSellerData('Enterprise');
  }

  Future<String> _fetchSellerData(String type) async {
    await Future.delayed(const Duration(seconds: 1));

    switch (type) {
      case 'General':
        return '''
Plan **$type**: Gratuito.

**Ventajas:**  
- **Gratuito para siempre**: Sin costos.   
- **Acceso básico**: Prueba la plataforma sin compromiso.  

**Desventajas:**  
- **Funcionalidades limitadas**: Sin características avanzadas.  
- **Sin beneficios**: No incluye premios ni recomendaciones.''';

      case 'Premium':
        return '''
**Descripción:**  
Este es el vendedor de tipo **$type**. Incluye características avanzadas como verificación de cuenta, recomendaciones de productos y un algoritmo que favorece tus publicaciones. Además, otorga premios y beneficios exclusivos.

**Ventajas:**  
- **Verificación de cuenta**: Aumenta la confianza de tus clientes.  
- **Recomendaciones personalizadas**: El algoritmo sugiere tus productos a más usuarios.  
- **Premios y beneficios**: Acceso a recompensas exclusivas.  
- **Mayor visibilidad**: Tus productos tienen prioridad en los resultados de búsqueda.  

**Desventajas:**  
- **Costo mensual**: Tiene un precio de \$99.99 al mes.  
- **Compromiso**: Requiere un pago recurrente para mantener los beneficios.  
      ''';

      case 'Enterprise':
        return '''
**Descripción:**  
Este es el vendedor de tipo **$type**. Diseñado para grandes empresas, ofrece herramientas avanzadas de gestión, soporte prioritario y análisis detallados para maximizar tus ventas.

**Ventajas:**  
- **Herramientas avanzadas**: Gestión de inventario, pedidos y clientes.  
- **Soporte prioritario**: Atención rápida y dedicada.  
- **Análisis detallados**: Informes personalizados para tomar decisiones estratégicas.  
- **Escalabilidad**: Ideal para empresas en crecimiento.  

**Desventajas:**  
- Absolutamente ninguna.
      ''';

      default:
        return '''
**Descripción:**  
Este es el vendedor de tipo **$type**.

**Ventajas:**  
- Ventaja 1  
- Ventaja 2  
- Ventaja 3  

**Desventajas:**  
- Desventaja 1  
- Desventaja 2  
      ''';
    }
  }

  void _navigateToLogin(BuildContext context, String accountType) {
    context.push('/login_seller', extra: accountType);
  }

  Widget _buildSellerCard(
      BuildContext context,
      String title,
      Future<String> markdownContentFuture,
      List<Color> colors,
      String type,
      IconData icon,
      String price) {
    return GestureDetector(
      onTap: () => _navigateToLogin(context, type),
      child: Container(
        width: MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width - 32
            : 300, // Ajusta el ancho en pantallas pequeñas
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
              future: markdownContentFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error al cargar el contenido"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No hay contenido disponible"));
                } else {
                  return MarkdownBody(
                    data: snapshot.data!,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: TextStyle(color: Colors.white.withOpacity(0.9)),
                      a: const TextStyle(color: Colors.white),
                      h1: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      h2: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona el tipo de vendedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 86,
                child: Text("${S.current.selectfromOurSellerPlans}:",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              isLargeScreen
                  ? Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: [
                          _buildSellerCard(
                            context,
                            'Vendedor General',
                            generalData,
                            [Colors.blue.shade800, Colors.blue.shade600],
                            "general",
                            Icons.business,
                            '${getFormattedCurrency(0, context)} al mes',
                          ),
                          _buildSellerCard(
                            context,
                            'Vendedor Premium',
                            premiumData,
                            [Colors.deepOrangeAccent, Colors.orange.shade700],
                            "premium",
                            Icons.star,
                            '${getFormattedCurrency(10, context)} al mes',
                          ),
                          _buildSellerCard(
                            context,
                            'Vendedor Empresarial',
                            enterpriseData,
                            [Colors.black, Colors.grey.shade800],
                            "enterprise",
                            Icons.store,
                            '\$(Mediante acuerdo) al mes',
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        _buildSellerCard(
                          context,
                          'Vendedor General',
                          generalData,
                          [Colors.blue.shade800, Colors.blue.shade600],
                          "general",
                          Icons.business,
                          '\$49.99 al mes',
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          context,
                          'Vendedor Premium',
                          premiumData,
                          [Colors.deepOrangeAccent, Colors.orange.shade700],
                          "premium",
                          Icons.star,
                          '\$99.99 al mes',
                        ),
                        const SizedBox(height: 16),
                        _buildSellerCard(
                          context,
                          'Vendedor Empresarial',
                          enterpriseData,
                          [Colors.black, Colors.grey.shade800],
                          "enterprise",
                          Icons.store,
                          '\$199.99 al mes',
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
