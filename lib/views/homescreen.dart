import 'package:flutter/material.dart';
import 'package:luminar_api/models/productsall/resp_productsall.dart';
import 'package:luminar_api/services/apiservice.dart';
import 'package:luminar_api/services/userservice.dart';
import 'package:luminar_api/views/loginpage.dart';
import 'package:luminar_api/views/productsaddpage.dart';

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

  Future<void> _logout() async {
    await UserService.clearUser();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Productsaddpage()),
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (productlist == null || productlist!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: productlist!.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: productlist![index].imageUrl != null
                  ? NetworkImage(productlist![index].imageUrl!)
                  : null,
              child: productlist![index].imageUrl == null
                  ? const Icon(Icons.image_not_supported)
                  : null,
            ),
            title: Text(productlist![index].name ?? 'No Name'),
            subtitle: Text(productlist![index].description ?? 'No Description'),
            trailing: Text(
              productlist![index].price != null
                  ? '\$${productlist![index].price}'
                  : 'N/A',
            ),
          );
        },
      );
    }
  }
}
