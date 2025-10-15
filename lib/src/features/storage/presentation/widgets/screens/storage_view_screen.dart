import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageViewScreen extends ConsumerStatefulWidget {
  const StorageViewScreen({
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StorageViewScreenState();
}

class StorageViewScreenState extends ConsumerState<StorageViewScreen>{

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}