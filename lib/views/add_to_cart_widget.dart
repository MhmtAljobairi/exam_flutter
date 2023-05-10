import 'package:exam_project_flutter/controllers/product_provider.dart';
import 'package:exam_project_flutter/views/view_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartWidget extends StatelessWidget {
  const AddToCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ProductProvier productProvider, child) =>
          productProvider.selectedProducts.isEmpty
              ? Container()
              : InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ViewCart()));
                  },
                  child: Container(
                      height: 50,
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                "${productProvider.selectedProducts.length}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Text(
                            "View Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              productProvider.total.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                ),
    );
  }
}
