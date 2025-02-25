import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'HashStudios App',
        theme: AppTheme.themeData,
        initialRoute: '/',
        routes: AppRouter.routes,
      ),
    );
  }
}