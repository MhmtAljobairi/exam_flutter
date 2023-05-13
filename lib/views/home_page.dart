import 'package:exam_project_flutter/controllers/product_controller.dart';
import 'package:exam_project_flutter/controllers/product_provider.dart';
import 'package:exam_project_flutter/models/product.dart';
import 'package:exam_project_flutter/views/add_to_cart_widget.dart';
import 'package:exam_project_flutter/views/dummy_page.dart';
import 'package:exam_project_flutter/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
              onPressed: () async {
                await FlutterSecureStorage().delete(key: "token");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              icon: Icon(Icons.logout)),
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DummyPage(),
                    ));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
              future: ProductController().getAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return ListTile(
                        onTap: () {
                          _handleViewProduct(product);
                        },
                        leading: Image.network(
                          product.image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.category.name),
                        trailing: Text(
                          product.finalPrice.toStringAsFixed(2),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            )),
            AddToCartWidget()
          ],
        ),
      ),
    );
  }

  _handleViewProduct(Product product) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 230,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.category.name,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  product.selectedQty++;
                                });
                              },
                              icon: Icon(Icons.add)),
                          const SizedBox(width: 30),
                          Text(
                            "${product.selectedQty}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 18),
                          ),
                          const SizedBox(width: 30),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  product.selectedQty--;
                                });
                              },
                              icon: Icon(Icons.remove)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        child: const Text('Add to cart'),
                        onPressed: () {
                          var productProvider = Provider.of<ProductProvier>(
                              context,
                              listen: false);

                          productProvider.addToCart(product);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
