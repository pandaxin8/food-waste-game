import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final Widget child;
  final Color color;

  SpeechBubble({required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: child,
  //   );
  // }



// import 'package:flutter/material.dart';

// class SpeechBubble extends StatelessWidget {
//   final Widget child;
//   final Color color;
//   final Color borderColor;
//   final double borderWidth;
//   final double nipHeight;

//   SpeechBubble({
//     Key? key,
//     required this.child,
//     this.color = Colors.white,
//     this.borderColor = Colors.black,
//     this.borderWidth = 2.0,
//     this.nipHeight = 10.0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.only(bottom: nipHeight),
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(12.0),
//               border: Border.all(color: borderColor, width: borderWidth),
//             ),
//             child: child,
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           child: CustomPaint(
//             painter: SpeechBubbleNipPainter(
//               color: color,
//               borderColor: borderColor,
//               borderWidth: borderWidth,
//             ),
//             child: SizedBox(
//               width: 20, // Nip width
//               height: nipHeight,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SpeechBubbleNipPainter extends CustomPainter {
//   final Color color;
//   final Color borderColor;
//   final double borderWidth;

//   SpeechBubbleNipPainter({
//     required this.color,
//     required this.borderColor,
//     required this.borderWidth,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     final borderPaint = Paint()
//       ..color = borderColor
//       ..strokeWidth = borderWidth
//       ..style = PaintingStyle.stroke;

//     // Draw the nip
//     final path = Path();
//     path.moveTo(0, size.height);
//     path.lineTo(size.width / 2, 0);
//     path.lineTo(size.width, size.height);
//     path.close();

//     canvas.drawPath(path, paint);
//     canvas.drawPath(path, borderPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
