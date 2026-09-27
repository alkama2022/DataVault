import 'package:flutter/material.dart';
import 'app.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.instance;
  runApp(DataVaultApp(storage: storage));
}
