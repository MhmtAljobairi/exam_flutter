import 'package:exam_project_flutter/controllers/product_provider.dart';
import 'package:exam_project_flutter/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ViewCart extends StatelessWidget {
  const ViewCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Consumer(
        builder: (context, ProductProvier productProvier, child) {
          if (productProvier.selectedProducts.isEmpty) {
            return Center(child: Text("Your cart is empty"));
          }
          return ListView.builder(
            itemCount: productProvier.selectedProducts.length,
            itemBuilder: (context, index) {
              Product product = productProvier.selectedProducts[index];
              return Dismissible(
                key: Key(index.toString()),
                background: Container(
                  color: Colors.red,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    )
                  ]),
                ),
                onDismissed: (direction) {
                  productProvier.removeProduct(index);
                },
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.total.toStringAsFixed(2)),
                  trailing: Container(
                      width: 155,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  try {
                                    productProvier.updateQty(
                                        product, product.selectedQty + 1);
                                  } catch (ex) {
                                    print(ex);
                                  }
                                },
                                child: Text("+")),
                            Text("${product.selectedQty}"),
                            TextButton(
                                onPressed: () {
                                  if (product.selectedQty == 1) {
                                    productProvier.removeProduct(index);
                                    return;
                                  }
                                  productProvier.updateQty(
                                      product, product.selectedQty - 1);
                                },
                                child: product.selectedQty == 1
                                    ? Icon(Icons.delete)
                                    : Text("-"))
                          ])),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
