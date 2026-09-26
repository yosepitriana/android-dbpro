import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/metric_card.dart';
import '../main.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String token;
  const DashboardScreen({super.key, required this.token});
  @override State<DashboardScreen> createState()=>_DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final api=ApiService(); final auth=AuthService();
  Timer? timer; Map<String,dynamic>? data; bool loading=false, online=true;

  @override void initState(){super.initState();_load();timer=Timer.periodic(const Duration(seconds:2),(_)=>_load());}
  @override void dispose(){timer?.cancel();super.dispose();}

  Future<void> _load() async {
    if(loading)return; loading=true;
    try { final next=await api.dashboard(widget.token); if(mounted)setState((){data=next;online=true;}); }
    on UnauthorizedException { await _logout(); }
    catch(_){if(mounted)setState(()=>online=false);}
    finally{loading=false;}
  }

  Future<void> _logout() async {
    timer?.cancel(); await auth.clearToken();
    if(!mounted)return;
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginScreen()),(_)=>false);
  }

  Map<String,dynamic> metric(String key)=>(data?[key] as Map?)?.cast<String,dynamic>()??{};
  List<dynamic> list(String key)=>data?[key] is List ? data![key] as List<dynamic> : const [];

  @override Widget build(BuildContext context)=>Scaffold(
    body:SafeArea(child:Column(children:[
      Padding(padding:const EdgeInsets.symmetric(horizontal:20,vertical:4),child:Row(children:[
        IconButton(onPressed:()=>DBproApp.of(context).toggleTheme(),icon:Icon(Theme.of(context).brightness==Brightness.dark?Icons.light_mode_outlined:Icons.dark_mode_outlined)),
        const Expanded(child:Center(child:Text('DBpro',style:TextStyle(fontSize:28,fontWeight:FontWeight.w800)))),
        IconButton(onPressed:_load,icon:loading?const SizedBox(width:22,height:22,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.refresh)),
      ])),
      Expanded(child:ListView(padding:const EdgeInsets.fromLTRB(20,4,20,30),children:[
        _status(),
        MetricCard.fromData(title:'CPU Usage',data:metric('cpu')),
        MetricCard.fromData(title:'Memory Usage',data:metric('memory')),
        MetricCard.fromData(title:'Disk Space',data:metric('disk')),
        MetricCard.fromData(title:'Network I/O',data:metric('network')),
        _Section(title:'SERVICE & CONTAINER',children:_rows(list('services'),false)),
        _Section(title:'RIWAYAT GANGGUAN',children:_rows(list('incidents'),true)),
        TextButton(onPressed:_logout,child:const Text('Keluar dari akun')),
      ])),
    ])),
  );

  Widget _status()=>Padding(padding:const EdgeInsets.only(top:14,bottom:6),child:Row(children:[
    Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(data?['serverName']?.toString()??'DBpro Server',style:const TextStyle(fontSize:21,fontWeight:FontWeight.bold)),
      Text(online?'Diperbarui ${data?['updatedAt']??'sekarang'}':'Tidak dapat mengambil data',style:const TextStyle(fontSize:12)),
    ])),
    Container(padding:const EdgeInsets.symmetric(horizontal:11,vertical:7),decoration:BoxDecoration(color:online?const Color(0xFFDCFCE7):const Color(0xFFFEE2E2),borderRadius:BorderRadius.circular(30)),child:Text(online?'● LIVE':'● OFFLINE',style:TextStyle(color:online?const Color(0xFF16A34A):const Color(0xFFDC2626),fontSize:12,fontWeight:FontWeight.bold))),
  ]));

  List<Widget> _rows(List<dynamic> items,bool incidents){
    if(items.isEmpty)return [Text(incidents?'Tidak ada gangguan':'Menunggu data server…')];
    return items.whereType<Map>().map((raw){final o=raw.cast<String,dynamic>();final name=(incidents?o['title']:o['name'])?.toString()??'-';final detail=(incidents?o['time']:o['detail'])?.toString()??'';final status=o['status']?.toString()??'';final ok=status=='running'||status=='healthy';return Padding(padding:const EdgeInsets.symmetric(vertical:10),child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(name,style:const TextStyle(fontWeight:FontWeight.bold)),Text(detail,style:const TextStyle(fontSize:12))])),if(!incidents)Text(status.toUpperCase(),style:TextStyle(fontSize:10,fontWeight:FontWeight.bold,color:ok?const Color(0xFF16A34A):const Color(0xFFDC2626))) ]));}).toList();
  }
}

class _Section extends StatelessWidget {
  final String title; final List<Widget> children;
  const _Section({required this.title,required this.children});
  @override Widget build(BuildContext context)=>Container(margin:const EdgeInsets.only(top:18),padding:const EdgeInsets.all(15),decoration:BoxDecoration(border:Border.all(color:const Color(0xFFE2E8F0)),borderRadius:BorderRadius.circular(15)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:15,fontWeight:FontWeight.bold)),const SizedBox(height:8),...children]));
}
