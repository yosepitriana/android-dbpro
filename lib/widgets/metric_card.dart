import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title,value,subtitle;
  final double progress;
  const MetricCard({super.key,required this.title,required this.value,required this.subtitle,this.progress=0});

  factory MetricCard.fromData({required String title,required Map<String,dynamic> data}){
    final raw=(data['value'] as num?)?.toDouble();
    final max=((data['max'] as num?)?.toDouble()??100).clamp(1,double.infinity);
    final unit=data['unit']?.toString()??'%';
    return MetricCard(title:title,value:raw==null?'—':'${raw.toStringAsFixed(raw>=100?0:1)}$unit',subtitle:data['subtitle']?.toString()??'Realtime',progress:raw==null?0:(raw/max).clamp(0,1));
  }

  @override Widget build(BuildContext context)=>Container(height:246,margin:const EdgeInsets.only(top:12),padding:const EdgeInsets.all(17),decoration:BoxDecoration(color:Theme.of(context).cardColor,border:Border.all(color:const Color(0xFFE2E8F0)),borderRadius:BorderRadius.circular(15),boxShadow:const[BoxShadow(blurRadius:8,offset:Offset(0,2),color:Color(0x140F172A))]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(title,style:const TextStyle(fontSize:11,fontWeight:FontWeight.bold)),const SizedBox(height:6),
    Text(value,style:const TextStyle(fontSize:27,fontWeight:FontWeight.bold)),Text(subtitle,style:const TextStyle(fontSize:11)),const SizedBox(height:12),
    LinearProgressIndicator(value:progress),const Expanded(child:Center(child:Text('Grafik realtime akan mengikuti data series'))),
  ]));
}
