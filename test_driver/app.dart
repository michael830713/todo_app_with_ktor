import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:todo_app_with_ktor/main.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();
//test
  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  runApp(MyApp());
}
