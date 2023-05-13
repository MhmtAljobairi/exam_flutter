import 'dart:async';

import 'package:exam_project_flutter/controllers/product_provider.dart';
import 'package:exam_project_flutter/controllers/order_controller.dart';
import 'package:exam_project_flutter/models/address.dart';
import 'package:exam_project_flutter/models/order.dart';
import 'package:exam_project_flutter/views/custom/summery_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderCheckoutPage extends StatefulWidget {
  Position location;
  OrderCheckoutPage(this.location, {super.key});

  @override
  State<OrderCheckoutPage> createState() => _OrderCheckoutPageState();
}

class _OrderCheckoutPageState extends State<OrderCheckoutPage> {
  int activeStep = 0;
  int upperBound = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            IconStepper(
              icons: [
                Icon(Icons.location_on_rounded),
                Icon(Icons.location_on_rounded),
                Icon(Icons.payment_rounded),
                Icon(Icons.summarize),
              ],
              enableNextPreviousButtons: false,
              lineLength: 35,
              activeStep: activeStep,
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            Expanded(
                child: IndexedStack(
              index: activeStep,
              children: [
                GoogleMapStep(widget.location),
                AddressFormStep(),
                PaymentMethodStep(),
                SummeryStep(),
              ],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                previousButton(),
                nextButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        var productProvider =
            Provider.of<ProductProvier>(context, listen: false);
        switch (activeStep) {
          case 0:
            setState(() {
              activeStep++;
            });
            break;
          case 1:
            if (productProvider.keyForm.currentState!.validate()) {
              setState(() {
                activeStep++;
              });
            }
            break;
          case 2:
            setState(() {
              activeStep++;
            });
            break;
          case 3:
            OrderController()
                .create(Order(
                    products: productProvider.selectedProducts,
                    address: productProvider.address!,
                    paymentMethodId: productProvider.paymentMethod,
                    total: productProvider.total,
                    taxAmount: productProvider.taxAmount,
                    subTotal: productProvider.subTotal))
                .then((value) {
              EasyLoading.dismiss();
              EasyLoading.showSuccess("Done");
            }).catchError((ex) {
              EasyLoading.dismiss();
              EasyLoading.showError(ex.toString());
            });
            break;
        }
      },
      child: Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Preface';

      case 2:
        return 'Table of Contents';

      case 3:
        return 'About the Author';

      default:
        return 'Introduction';
    }
  }
}

class GoogleMapStep extends StatefulWidget {
  Position location;

  GoogleMapStep(this.location, {super.key});

  @override
  State<GoogleMapStep> createState() => _GoogleMapStepState();
}

class _GoogleMapStepState extends State<GoogleMapStep> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late CameraPosition _initalPostion;
  late LatLng _requiredLocation;

  @override
  void initState() {
    super.initState();
    _initalPostion = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return mapWidget();
  }

  Widget mapWidget() {
    double mapWidth = MediaQuery.of(context).size.width;
    double mapHeight = MediaQuery.of(context).size.height - 215;
    return Stack(alignment: Alignment(0.0, 0.0), children: <Widget>[
      Container(
          width: mapWidth,
          height: mapHeight,
          child: GoogleMap(
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            initialCameraPosition: _initalPostion,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (CameraPosition position) {
              _requiredLocation = position.target;
            },
            onCameraIdle: () {
              _getAddressFromLatLng();
            },
          )),
      Positioned(
        top: (mapHeight - 50) / 2,
        right: (mapWidth - 50) / 2,
        child: Icon(
          Icons.location_on,
          size: 50,
          color: Colors.red,
        ),
      ),
    ]);
  }

  Future<void> _getAddressFromLatLng() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _requiredLocation.latitude, _requiredLocation.longitude);

    Placemark first = placemarks.first;

    Address address = Address();
    address.latitude = _requiredLocation.latitude;
    address.longitude = _requiredLocation.longitude;
    address.country = first.country!;
    address.city = first.locality!;
    address.area = first.subLocality!;
    address.street = first.street!;
    address.buildingNo = "";

    var productProvider = Provider.of<ProductProvier>(context, listen: false);
    productProvider.updateAddress(address);
  }
}

class AddressFormStep extends StatelessWidget {
  AddressFormStep({super.key});
  final _controllerCountry = TextEditingController();
  final _controllerCity = TextEditingController();
  final _controllerArea = TextEditingController();
  final _controllerStreet = TextEditingController();
  final _controllerBuilding = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ProductProvier productProvier, child) {
      return formWidget(productProvier);
    });
  }

  Widget formWidget(ProductProvier productProvier) {
    _controllerCountry.text = productProvier.address!.country;
    _controllerCity.text = productProvier.address!.city;
    _controllerArea.text = productProvier.address!.area;
    _controllerStreet.text = productProvier.address!.street;
    _controllerBuilding.text = productProvier.address!.buildingNo;

    return Container(
      child: Form(
          key: productProvier.keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerCountry,
                decoration: InputDecoration(hintText: "Country "),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerCity,
                decoration: InputDecoration(hintText: "City "),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerArea,
                decoration: InputDecoration(hintText: "Area "),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerStreet,
                decoration: InputDecoration(hintText: "Street "),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerBuilding,
                // onChanged: (value) {
                //   productProvier.address!.buildingNo = value;
                // },
                decoration: InputDecoration(hintText: "Building No. "),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
              ),
            ],
          )),
    );
  }
}

class PaymentMethodStep extends StatelessWidget {
  const PaymentMethodStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ProductProvier productProvier, child) {
      return Container(
        child: Column(children: [
          Card(
            child: ListTile(
                onTap: () {
                  productProvier.updatePaymentMethod(1);
                },
                leading: Icon(
                  Icons.attach_money_outlined,
                  color: Colors.green,
                ),
                title: Text("Cash On Delivery"),
                trailing: Radio<int>(
                  value: 1,
                  groupValue: productProvier.paymentMethod,
                  onChanged: (value) {
                    productProvier.updatePaymentMethod(value!);
                  },
                )),
          ),
          Card(
            child: ListTile(
                onTap: () {
                  productProvier.updatePaymentMethod(2);
                },
                leading: Icon(
                  Icons.payment,
                  color: Colors.green,
                ),
                title: Text("Debit Cart"),
                trailing: Radio<int>(
                  value: 2,
                  groupValue: productProvier.paymentMethod,
                  onChanged: (value) {
                    productProvier.updatePaymentMethod(value!);
                  },
                )),
          )
        ]),
      );
    });
  }
}

class SummeryStep extends StatelessWidget {
  const SummeryStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ProductProvier productProvier, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Summery",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _addressWidget(productProvier),
        const SizedBox(height: 20),
        SummeryWidget()
      ]);
    });
  }
}

Widget _addressWidget(ProductProvier productProvier) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Delivery Address",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 3),
      const Divider(),
      const SizedBox(height: 3),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Country",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            productProvier.address!.country,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
      const SizedBox(height: 3),
      const Divider(),
      const SizedBox(height: 3),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "City",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            productProvier.address!.city,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
      const SizedBox(height: 3),
      const Divider(),
      const SizedBox(height: 3),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Area",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            productProvier.address!.area,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
      const SizedBox(height: 3),
      const Divider(),
      const SizedBox(height: 3),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Street",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            productProvier.address!.street,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
      const SizedBox(height: 3),
      const Divider(),
      const SizedBox(height: 3),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Building No.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Text(
            productProvier.address!.buildingNo,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      )
    ],
  );
}
