import 'package:exam_project_flutter/views/add_to_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({super.key});

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: Container(
                    child: Stack(
              children: [
                Positioned(
                    child: Icon(
                  Icons.shopify,
                  size: 100,
                )),
                Positioned(
                    right: 20,
                    top: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 15,
                    ))
              ],
            ))),
            AddToCartWidget(),
          ],
        ));
  }
}
