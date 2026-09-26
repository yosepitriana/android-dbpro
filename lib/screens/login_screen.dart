import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final api = ApiService();
  final auth = AuthService();
  bool obscure = true, loading = false, biometric = false;

  @override
  void initState() { super.initState(); _checkBiometric(); }

  Future<void> _checkBiometric() async {
    final token = await auth.readToken();
    final available = token != null && await auth.canUseBiometrics();
    if (!mounted) return;
    setState(() => biometric = available);
  }

  Future<void> _login() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      _message('Email dan password wajib diisi'); return;
    }
    setState(() => loading = true);
    try {
      final token = await api.login(email.text, password.text);
      await auth.saveToken(token);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(token: token)));
    } catch (e) {
      _message(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _biometricLogin() async {
    if (!await auth.authenticateBiometric()) return;
    final token = await auth.readToken();
    if (!mounted || token == null) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(token: token)));
  }

  void _message(String text) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        const SizedBox(height: 58),
        const SizedBox(height: 180, child: Center(child: Text('DBpro', style: TextStyle(fontSize: 44,fontWeight: FontWeight.w800,color: Color(0xFF0E53BE))))),
        const SizedBox(height: 22),
        const Text('CENTRAL DASHBOARD',style: TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Color(0xFF0F172A))),
        const SizedBox(height:24),
        TextField(controller:email,keyboardType:TextInputType.emailAddress,decoration:input('Email')),
        const SizedBox(height:12),
        TextField(controller:password,obscureText:obscure,onSubmitted:(_)=>_login(),decoration:input('Password').copyWith(suffixIcon:IconButton(onPressed:()=>setState(()=>obscure=!obscure),icon:Icon(obscure?Icons.visibility_outlined:Icons.visibility_off_outlined)))),
        const SizedBox(height:18),
        SizedBox(width:double.infinity,height:54,child:FilledButton(onPressed:loading?null:_login,child:Text(loading?'Memeriksa…':'Masuk',style:const TextStyle(fontWeight:FontWeight.bold)))),
        if(biometric)...[
          const SizedBox(height:16),
          IconButton(iconSize:42,onPressed:_biometricLogin,tooltip:'Masuk dengan biometrik',icon:const Icon(Icons.fingerprint)),
          const Text('Masuk dengan biometrik',style:TextStyle(color:Color(0xFF64748B))),
        ],
      ]),
    )),
  );

  InputDecoration input(String hint)=>InputDecoration(hintText:hint,filled:true,fillColor:const Color(0xFFF1F5F9),border:OutlineInputBorder(borderRadius:BorderRadius.circular(12),borderSide:BorderSide.none));
}
