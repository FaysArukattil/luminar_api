import 'package:flutter/material.dart';
import 'package:luminar_api/models/productsall/resp_productsall.dart';
import 'package:luminar_api/services/apiservice.dart';
import 'package:luminar_api/services/userservice.dart';
import 'package:luminar_api/views/productseditpage.dart';

class Myproducts extends StatefulWidget {
  const Myproducts({super.key});

  @override
  State<Myproducts> createState() => _MyproductsState();
}

class _MyproductsState extends State<Myproducts> {
  Apiservice apiService = Apiservice();
  List<Data>? productlist;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    final user = await UserService.getUser();
    if (user?.access != null) {
      productlist = await Apiservice().myproducts(user!.access!);
    } else {
      productlist = [];
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
    });
    await _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),
      body: _body(),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (productlist == null || productlist!.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Center(child: Text('No products yet')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: productlist!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final p = productlist![index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              onTap: () async {
                // Navigate to edit page when card is tapped
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProduct(product: p),
                  ),
                );
                if (result == true) {
                  _refresh();
                }
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: p.imageUrl != null
                      ? Image.network(p.imageUrl.toString(), fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported),
                        ),
                ),
              ),
              title: Text(
                p.name ?? 'No Name',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                p.description ?? 'No Description',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.price != null ? '\u20B9${p.price}' : 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      // Navigate to edit page
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProduct(product: p),
                        ),
                      );
                      if (result == true) {
                        _refresh();
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: const Text(
                            'Are you sure you want to delete this product?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        final success = await apiService.deleteProduct(
                          id: p.id.toString(),
                        );
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Product deleted successfully'
                                    : 'Failed to delete product',
                              ),
                              backgroundColor: success
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                          if (success) {
                            _refresh();
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
