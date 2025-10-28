import 'package:flutter/material.dart';
import 'package:luminar_api/models/productsall/resp_productsall.dart';
import 'package:luminar_api/services/apiservice.dart';
import 'package:luminar_api/services/userservice.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Data>? productlist;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    var user = await UserService.getUser();
    if (user != null && user.access != null) {
      productlist = await Apiservice().getproducts(user.access!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Widget _body() {
    if (productlist == null || productlist!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: productlist!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(productlist![index].name!),
            subtitle: Text(productlist![index].description!),
            trailing: Text('\$${productlist![index].price}'),
          );
        },
      );
    }
  }
}
