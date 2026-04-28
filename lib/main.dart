import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.loadConfig();
  await di.initDependencies();

  runApp(const EmosenseApp());
}
