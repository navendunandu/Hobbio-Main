import 'package:flutter/material.dart';

class BookPackage extends StatefulWidget {
  @override
  _BookPackageState createState() => _BookPackageState();
}

class _BookPackageState extends State<BookPackage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _cardHolderController;
  late TextEditingController _cardNumberController;
  late TextEditingController _expiryDateController;
  late TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _cardHolderController = TextEditingController();
    _cardNumberController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Implement your payment processing logic here
      // Once payment is successful, you can navigate to the next screen or perform any other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/pic3.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Payment Gateway',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Hobbio3',
                    color: Color.fromRGBO(0, 1, 0, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Card(
                elevation: 3.0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _cardHolderController,
                          decoration: InputDecoration(
                            labelText: 'Card Holder',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter card holder name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter card number';
                            }
                            if (!RegExp(r'^\d{4} \d{4} \d{4} \d{4}$').hasMatch(value)) {
                              return 'Please enter a valid card number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryDateController,
                                decoration: InputDecoration(
                                  labelText: 'Expiry Date',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter expiry date';
                                  }
                                  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                    return 'Please enter a valid expiry date (MM/YY)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: TextFormField(
                                controller: _cvvController,
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter CVV';
                                  }
                                  if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                                    return 'Please enter a valid CVV (3 digits)';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 14, 45, 70)), // Change button color here
                          ),
                          child: Text(
                            'Pay',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
