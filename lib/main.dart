import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main()=>runApp(const DBproApp());

class DBproApp extends StatefulWidget {
  const DBproApp({super.key});
  static _DBproAppState of(BuildContext context)=>context.findAncestorStateOfType<_DBproAppState>()!;
  @override State<DBproApp> createState()=>_DBproAppState();
}
class _DBproAppState extends State<DBproApp>{
  ThemeMode mode=ThemeMode.light;
  void toggleTheme()=>setState(()=>mode=mode==ThemeMode.dark?ThemeMode.light:ThemeMode.dark);
  @override Widget build(BuildContext context)=>MaterialApp(
    debugShowCheckedModeBanner:false,title:'DBpro Central',themeMode:mode,
    theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF2563EB)),scaffoldBackgroundColor:const Color(0xFFF8FAFC),cardColor:Colors.white),
    darkTheme:ThemeData(useMaterial3:true,brightness:Brightness.dark,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF2563EB),brightness:Brightness.dark),scaffoldBackgroundColor:const Color(0xFF0B1120),cardColor:const Color(0xFF111827)),
    home:const LoginScreen());
}
