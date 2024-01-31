import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propsync_system/const.dart';
import 'package:propsync_system/models/housing_model.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/text_field_style.dart';
import 'package:propsync_system/services/firestore.dart';
import 'package:propsync_system/services/keys.dart';

class ViewHousingPage extends StatefulWidget {
  final Housing logement;
  final Member member;
  const ViewHousingPage({super.key, required this.member, required this.logement});
  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<ViewHousingPage> {
  int _currentPage = 0;
  late PageController _pageController;
  late List<String> typeOptions;
  late String typeController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController adressController;
  late TextEditingController zipController;
  late TextEditingController cityController;
  late TextEditingController rentController;
  late TextEditingController chargeController;
  late TextEditingController purchasePriceController;
  late TextEditingController monthlyLoanPaymentController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    typeOptions = Const.logementTypes;
    typeController = widget.logement.type;
    nameController = TextEditingController(text: widget.logement.name);
    rentController = TextEditingController(text: widget.logement.rent);
    chargeController = TextEditingController(text: widget.logement.charge);
    widget.logement.description.isNotEmpty
        ? descriptionController = TextEditingController(text: widget.logement.description)
        : descriptionController = TextEditingController();
    widget.logement.adress.isNotEmpty
        ? adressController = TextEditingController(text: widget.logement.adress)
        : adressController = TextEditingController();
    widget.logement.zip.isNotEmpty
        ? zipController = TextEditingController(text: widget.logement.zip)
        : zipController = TextEditingController();
    widget.logement.city.isNotEmpty
        ? cityController = TextEditingController(text: widget.logement.city)
        : cityController = TextEditingController();
    widget.logement.purchasePrice != null
        ? purchasePriceController = TextEditingController(text: widget.logement.purchasePrice.toString())
        : purchasePriceController = TextEditingController();
    widget.logement.monthlyLoanPayment != null
        ? monthlyLoanPaymentController = TextEditingController(text: widget.logement.monthlyLoanPayment.toString())
        : monthlyLoanPaymentController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    adressController.dispose();
    zipController.dispose();
    cityController.dispose();
    rentController.dispose();
    chargeController.dispose();
    purchasePriceController.dispose();
    monthlyLoanPaymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Modifier le logement"),
        actions: [
          IconButton(
            onPressed: () {
              _onValidate();
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
              onPressed: () {
                _onValidate();
                Navigator.pop(context);
              },
              icon: Icon(Icons.update),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _buildNavigationButtons(),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildCard1(),
                      _buildCard2(),
                      _buildCard3(),
                      // ... (add more cards if needed)
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Etes vous sur de vouloir supprimer le logement"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    FirestoreService().deleteHousing(memberId: widget.member.id, housingId: widget.logement.id).then((value) => Navigator.pop(context));
                                  },
                                  child: const Text("OUI")
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("NON")
                              ),
                            ],
                          );
                        }
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Couleur de fond du bouton
                  ),
                  child: const Text(
                    style: TextStyle(
                      color: Colors.white
                    ),
                      "Supprimer le logement"
                  )
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCard1() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
            children:[
              DropdownButtonFormField<String>(
                value: typeController,
                onChanged: (String? newValue) {
                  setState(() {
                    typeController = newValue!;
                  });
                },
                items: typeOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const ColumnSpacing(),
              TextField(
                controller: nameController,
                decoration: const TextFieldStyle(hint: "Nom"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: adressController,
                decoration: const TextFieldStyle(hint: "Adresse"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: zipController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const TextFieldStyle(hint: "Code postal"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: cityController,
                decoration: const TextFieldStyle(hint: "Vile"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: rentController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const TextFieldStyle(hint: "Loyer hors charges").copyWith(
                  suffixIcon: const Icon(Icons.euro_symbol),
                ),
              ),
              const ColumnSpacing(),
              TextField(
                controller: chargeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const TextFieldStyle(hint: "charges").copyWith(
                  suffixIcon: const Icon(Icons.euro_symbol),
                ),
              ),
              const ColumnSpacing(),
            ]
        )
    );
  }

  Widget _buildCard2() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
            children:[
              TextField(
                controller: descriptionController,
                decoration: const TextFieldStyle(hint: "Description"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: purchasePriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const TextFieldStyle(hint: "Prix d'achat").copyWith(
                  suffixIcon: const Icon(Icons.euro_symbol),
                ),
              ),
              const ColumnSpacing(),
              TextField(
                controller: monthlyLoanPaymentController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const TextFieldStyle(hint: "Mensualité du crédit").copyWith(
                  suffixIcon: const Icon(Icons.euro_symbol),
                ),
              )
            ]
        )
    );
  }

  Widget _buildCard3() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
            children:[
              TextField(
                controller: descriptionController,
                decoration: const TextFieldStyle(hint: "Description"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: purchasePriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const TextFieldStyle(hint: "Prix d'achat").copyWith(
                  suffixIcon: const Icon(Icons.euro_symbol),
                ),
              ),
              const ColumnSpacing(),
              TextField(
                controller: monthlyLoanPaymentController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const TextFieldStyle(hint: "Mensualité du crédit").copyWith(
                  suffixIcon: const Icon(Icons.euro_symbol),
                ),
              )
            ]
        )
    );
  }

  List title = [
    'Information générales',
    'Information locative',
    'Information financière',
  ];
  int get _totalPages => 3;

  Widget _buildNavigationButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < _totalPages; i++)
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                style: TextButton.styleFrom(
                  primary: _currentPage == i ? Colors.amber : null,
                ),
                child: Text(title[i]),
              ),
            ),
        ],
      ),
    );
  }

  _onValidate() {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> map = {};
    final logement = widget.logement;
    if (nameController.text.isNotEmpty && nameController.text != logement.name) {
      map[nameKey] = nameController.text;
    }
    if (descriptionController.text.isNotEmpty && descriptionController.text != logement.description) {
      map[descriptionKey] = descriptionController.text;
    }
    if (adressController.text.isNotEmpty && adressController.text != logement.adress) {
      map[adressKey] = adressController.text;
    }
    if (zipController.text.isNotEmpty && zipController.text != logement.zip) {
      map[zipKey] = zipController.text;
    }
    if (cityController.text.isNotEmpty && cityController.text != logement.city) {
      map[cityKey] = cityController.text;
    }
    if (rentController.text.isNotEmpty && rentController.text != logement.rent) {
      map[rentKey] = rentController.text;
    }
    if (chargeController.text.isNotEmpty && chargeController.text != logement.charge) {
      map[chargeKey] = chargeController.text;
    }
    if (purchasePriceController.text.isNotEmpty && purchasePriceController.text != logement.purchasePrice) {
      map[purchasePricekey] = purchasePriceController.text;
    }
    if (monthlyLoanPaymentController.text.isNotEmpty && monthlyLoanPaymentController.text != logement.monthlyLoanPayment) {
      map[monthlyLoanPaymentkey] = monthlyLoanPaymentController.text;
    }
    map[typeKey] = typeController;
    FirestoreService().updateHousing(memberId: widget.member.id, housingId: logement.id, data: map);
  }
}