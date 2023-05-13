import 'package:exam_project_flutter/controllers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummeryWidget extends StatelessWidget {
  const SummeryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ProductProvier productProvier, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Billing Summery",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            const Divider(),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "# of Products",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  productProvier.selectedProducts.length.toString(),
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
                  "Sub Total",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  productProvier.subTotal.toStringAsFixed(2),
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
                  "Tax",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  productProvier.taxAmount.toStringAsFixed(2),
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
                  "Total",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  productProvier.total.toStringAsFixed(2),
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
