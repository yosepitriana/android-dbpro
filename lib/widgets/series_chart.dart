import 'package:flutter/material.dart';

class SeriesChart extends StatelessWidget{
  final List<double> values; final double maxValue;
  const SeriesChart({super.key,required this.values,required this.maxValue});
  @override Widget build(BuildContext context)=>CustomPaint(painter:_SeriesPainter(values,maxValue,Theme.of(context).brightness==Brightness.dark),size:Size.infinite);
}
class _SeriesPainter extends CustomPainter{
  final List<double> values; final double maxValue; final bool dark;
  _SeriesPainter(this.values,this.maxValue,this.dark);
  @override void paint(Canvas canvas,Size size){
    final grid=Paint()..color=dark?const Color(0xFF242424):const Color(0xFFE2E8F0)..strokeWidth=1;
    for(var i=0;i<5;i++){final y=size.height*i/4;canvas.drawLine(Offset(0,y),Offset(size.width,y),grid);}
    if(values.length<2)return;
    final line=Paint()..color=const Color(0xFF2563EB)..strokeWidth=2.2..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round;
    final path=Path();
    for(var i=0;i<values.length;i++){final x=size.width*i/(values.length-1);final y=size.height-(size.height*(values[i].clamp(0,maxValue)/maxValue));if(i==0)path.moveTo(x,y);else path.lineTo(x,y);}
    canvas.drawPath(path,line);
  }
  @override bool shouldRepaint(covariant _SeriesPainter old)=>old.values!=values||old.maxValue!=maxValue||old.dark!=dark;
}
