/*import 'package:flutter/material.dart';

class HtmlPageScreen extends StatelessWidget {
  const HtmlPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String htmlContent = """
       <!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tienda Abner Jaasiel Irias</title>
    <style>
        /* Estilos generales */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        /* Barra de navegación */
        nav {
            background-color: #333;
            color: white;
            padding: 10px;
            text-align: center;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        nav a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
            font-size: 18px;
        }

        nav a:hover {
            text-decoration: underline;
        }

        /* Título de la página */
        header {
            background-color: #444;
            color: white;
            text-align: center;
            padding: 20px;
        }

        header h1 {
            margin: 0;
            font-size: 36px;
        }

        /* Secciones */
        section {
            padding: 20px;
            margin-top: 40px;
        }

        section h2 {
            font-size: 28px;
            margin-bottom: 15px;
        }

        /* Carruseles y productos */
        .carousel {
            display: flex;
            overflow-x: auto;
            gap: 15px; /* Reducir espacio entre los items */
            padding-bottom: 20px;
        }

        .carousel-item {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 250px; /* Tamaño reducido de las tarjetas */
            padding: 15px;
            text-align: center;
            flex-shrink: 0;
        }

        .carousel-item img {
            width: 100%;
            border-radius: 8px;
        }

        .carousel-item h3 {
            font-size: 18px;
            margin: 10px 0;
        }

        .carousel-item p {
            font-size: 16px;
            color: #555;
        }

        .carousel-item button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            border-radius: 5px;
        }

        .carousel-item button:hover {
            background-color: #45a049;
        }

        /* Estilo del footer */
        footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 20px;
            position: relative;
            bottom: 0;
            width: 100%;
        }

        footer a {
            color: white;
            text-decoration: none;
        }

        /* Media Queries para Responsividad */
        @media (max-width: 768px) {
            nav a {
                font-size: 16px;
            }

            section h2 {
                font-size: 24px;
            }

            .carousel-item {
                width: 200px;
            }
        }

        @media (max-width: 480px) {
            header h1 {
                font-size: 28px;
            }

            nav a {
                font-size: 14px;
                margin: 0 10px;
            }

            .carousel-item {
                width: 150px;
            }

            footer {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

    <!-- Barra de navegación -->
    <nav>
        <a href="#carousel1">Electronics</a>
        <a href="#carousel2">Home & Kitchen</a>
        <a href="#carousel3">Clothing & Accessories</a>
        <a href="#carousel4">Health & Wellness</a>
    </nav>

    <!-- Título de la página -->
    <header>
        <h1>Tienda Abner Jaasiel Irias</h1>
    </header>

    <!-- Contenedor de productos (Carruseles generados dinámicamente) -->
    <div id="product-container"></div>

    <!-- Footer -->
    <footer>
        <p>&copy; 2024 Todos los derechos reservados</p>
        <a href="#">Política de privacidad</a> | <a href="#">Términos y condiciones</a>
    </footer>

    <script>
        // Datos de ejemplo (array de productos)
        const maps = [
            {
                category: "Electronics",
                items: [
                    {
                        title: "ACEMAGIC Computadora portátil",
                        imageUrl: "https://m.media-amazon.com/images/I/71331gmRd1L.__AC_SX300_SY300_QL70_FMwebp_.jpg",
                        price: "L699.99"
                    },
                    {
                        title: "Best Choice Products - Sofá modular de lino",
                        imageUrl: "https://m.media-amazon.com/images/I/71m+LxORpfL._AC_SX679_.jpg",
                        price: "L499.99"
                    }
                ]
            },
            {
                category: "Home & Kitchen",
                items: [
                    {
                        title: "Guantes de grunge de hadas, accesorios de grunge",
                        imageUrl: "https://m.media-amazon.com/images/I/51ZUsKDYKYL._AC_SX679_.jpg",
                        price: "L12.99"
                    },
                    {
                        title: "6 piezas de bufanda de seda con clip para camiseta",
                        imageUrl: "https://m.media-amazon.com/images/I/71NVgkuyvnL._AC_SY675_.jpg",
                        price: "L19.99"
                    }
                ]
            },
            {
                category: "Clothing & Accessories",
                items: [
                    {
                        title: "Eigso 3 pulseras punk de cuero para hombres y mujeres",
                        imageUrl: "https://m.media-amazon.com/images/I/71xqKOuZqDL._AC_SY535_.jpg",
                        price: "L14.99"
                    },
                    {
                        title: "Nicwell - Irrigador dental inalámbrico",
                        imageUrl: "https://m.media-amazon.com/images/I/71lUZIKlpML.__AC_SX300_SY300_QL70_FMwebp_.jpg",
                        price: "L39.99"
                    }
                ]
            },
            {
                category: "Health & Wellness",
                items: [
                    {
                        title: "Runstar Báscula inteligente para peso corporal",
                        imageUrl: "https://m.media-amazon.com/images/I/61qLw0zI3qL._SX522_.jpg",
                        price: "L29.99"
                    }
                ]
            }
        ];

        // Función para generar los carruseles dinámicamente
        function generateCarousels() {
            const container = document.getElementById('product-container');
            
            maps.forEach((map, index) => {
                // Crear la sección para el carrusel
                const section = document.createElement('section');
                serousel.classList.add('carousel');

                // Generar los productos dentro del carrusel
                map.items.forEach(item => {
                    const itemElement = document.createElement('div');
                    itemElement.classList.add('carousel-item');
       ction.id = `carousel{index + 1}`;
                
                // Crear el título de la sección
                const title = document.createElement('h2');
                title.textContent = map.category;
                section.appendChild(title);
                
                // Crear el contenedor del carrusel
                const carousel = document.createElement('div');
                ca             
                    // Crear el contenido de cada producto
                    const img = document.createElement('img');
                    img.src = item.imageUrl;
                    img.alt = item.title;
                    
                    const itemTitle = document.createElement('h3');
                    itemTitle.textContent = item.title;

                    const price = document.createElement('p');
                    price.textContent = item.price;

                    const button = document.createElement('button');
                    button.textContent = 'Añadir al carrito';

                    // Agregar los elementos al carrusel
                    itemElement.appendChild(img);
                    itemElement.appendChild(itemTitle);
                    itemElement.appendChild(price);
                    itemElement.appendChild(button);

                    carousel.appendChild(itemElement);
                });

                // Agregar el carrusel a la sección
                section.appendChild(carousel);
                
                // Agregar la sección al contenedor
                container.appendChild(section);
            });
        }

        // Llamar a la función para generar los carruseles
        generateCarousels();
    </script>

</body>
</html>

   """;

    return Scaffold(
      appBar: AppBar(title: const Text("Tienda Abner Jaasiel Irias")),
      body: SingleChildScrollView(
        child: Container(
          child: Text(htmlContent),
        ),
      ),
    );
  }
}

*/
import 'package:flutter/material.dart';
import 'package:card_loading/card_loading.dart'; // Importa el paquete card_loading

class HtmlPageScreen extends StatefulWidget {
  const HtmlPageScreen({super.key});

  @override
  State<HtmlPageScreen> createState() => _HtmlPageScreenState();
}

class _HtmlPageScreenState extends State<HtmlPageScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulamos la carga durante 10 segundos
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String htmlContent = """
       <!DOCTYPE html>
       ... (tu HTML completo aquí) ...
    """;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tienda Abner Jaasiel Irias"),
      ),
      body: _isLoading
          ? _buildSkeleton()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("Preview: ",
                          style: Theme.of(context).textTheme.titleLarge)),
                  const SizedBox(height: 24.0),
                  // Imagen extendida hacia abajo
                  Image.asset(
                    'assets/images/example_shop.jpg', // Imagen final
                    height: 900.0, // Imagen más grande
                    width: double.infinity,
                    fit: BoxFit
                        .cover, // Imagen extendida para cubrir todo el espacio
                  ),
                  const SizedBox(height: 44.0),
                  Center(
                      child: Text("Code: ",
                          style: Theme.of(context).textTheme.titleLarge)),
                  const SizedBox(height: 24.0),
                  // Contenido de la página
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(htmlContent),
                  ),
                ],
              ),
            ),
    );
  }

  // Widget que simula un cargador usando card_loading
  Widget _buildSkeleton() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CardLoading(
              height: 30.0,
              width: double.infinity,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) => const Expanded(
                  child: CardLoading(
                    height: 150.0,
                    width: double.infinity, // Ajustar a 100% de ancho
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const CardLoading(
              height: 20.0,
              width: double.infinity,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: List.generate(
                2,
                (index) => const Expanded(
                  child: CardLoading(
                    height: 120.0,
                    width: double.infinity, // Ajustar a 100% de ancho
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Center(
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 16.0),
            const CardLoading(
              height: 100.0,
              width: double.infinity,
            ),
            const SizedBox(height: 16.0),
            const CardLoading(
              height: 100.0,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
