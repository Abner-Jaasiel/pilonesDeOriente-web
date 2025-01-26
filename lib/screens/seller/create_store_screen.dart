import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateStoreScreen extends StatefulWidget {
  const CreateStoreScreen({super.key});

  @override
  _CreateStoreScreenState createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;

  late TextEditingController _storeNameController;
  late TextEditingController _storeDescriptionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _categoriesController;
  late TextEditingController _paymentMethodsController;

  final _formKey = GlobalKey<FormState>();

  List<String> categories = [
    'Electronics',
    'Fashion',
    'Groceries',
    'Books',
    'Beauty'
  ];
  List<String> paymentMethods = ['Credit Card', 'PayPal', 'Bank Transfer'];

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _storeNameController = TextEditingController();
    _storeDescriptionController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _categoriesController = TextEditingController();
    _paymentMethodsController = TextEditingController();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: -15, end: 15).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _categoriesController.dispose();
    _paymentMethodsController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Step> _steps() {
    return [
      Step(
        title: const Text('Store Info'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/store_info.png',
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            const Text('Store Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _storeNameController,
              decoration: const InputDecoration(hintText: 'Enter store name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Store name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text('Store Description',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _storeDescriptionController,
              decoration:
                  const InputDecoration(hintText: 'Describe your store'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Store description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      Step(
        title: const Text('Contact Info'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/contact_info.png',
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _emailController,
              decoration:
                  const InputDecoration(hintText: 'Enter email address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text('Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(hintText: 'Enter phone number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      Step(
        title: const Text('Location Info'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/location_info.png',
                  height: 150, // Tamaño ajustado
                  width: 150, // Tamaño ajustado
                ),
              ),
            ),
            const Text('Address',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Enter address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Address is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text('City', style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(hintText: 'Enter city'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'City is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      Step(
        title: const Text('Store Settings'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/store_settings.png',
                  height: 150, // Tamaño ajustado
                  width: 150, // Tamaño ajustado
                ),
              ),
            ),
            const Text('Categories',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _categoriesController,
              decoration: const InputDecoration(hintText: 'Enter categories'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Categories are required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text('Payment Methods',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              controller: _paymentMethodsController,
              decoration:
                  const InputDecoration(hintText: 'Enter payment methods'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Payment methods are required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Store'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() {
            _currentStep = step;
          }),
          onStepContinue: () {
            if (_currentStep == _steps().length - 1) {
              // Aquí hacemos la navegación al siguiente screen
              GoRouter.of(context).push('/html_page');
            } else {
              setState(() {
                _currentStep++;
              });
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          steps: _steps(),
        ),
      ),
    );
  }
}
