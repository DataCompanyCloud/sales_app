import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageSearchScreen extends ConsumerStatefulWidget {
  const StorageSearchScreen ({
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StorageSearchScreenState();
}

class StorageSearchScreenState extends ConsumerState<StorageSearchScreen>{
  final isSearchOpenProvider = StateProvider<bool>((_) => false);
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSubmitted: (search) {
              if (search.isEmpty) return;

              // ref.read(storageSearchProvider.notifier).state = search;
            },
          ),
        ),
      ),
    );
  }
}