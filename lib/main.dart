import 'package:flutter/material.dart';
import 'package:scadar/core/di/injection_container.dart' as di;

import 'package:scadar/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}
