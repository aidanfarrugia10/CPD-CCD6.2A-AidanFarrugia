import 'package:flutter_web_plugins/flutter_web_plugins.dart';
// ignore: depend_on_referenced_packages
import 'package:push_notifications/main.dart' as app;

void main() {
  setUrlStrategy(PathUrlStrategy());
  app.main();
}
