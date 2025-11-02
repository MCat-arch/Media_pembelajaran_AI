import 'package:flutter/material.dart';

class QuizNavigator extends StatelessWidget {
  final int currentIndex;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;

  const QuizNavigator({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.onPrev,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentIndex == total - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          // Tombol Prev
          ElevatedButton.icon(
            onPressed: currentIndex > 0 ? onPrev : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text("Prev"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const Spacer(),

          // Tombol Next / Submit
          if (!isLast)
            ElevatedButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Next"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class QuizNavigator extends StatelessWidget {
//   final int currentIndex;
//   final int total;
//   final VoidCallback onPrev;
//   final VoidCallback onNext;
//   final VoidCallback onSubmit;

//   const QuizNavigator({
//     super.key,
//     required this.currentIndex,
//     required this.total,
//     required this.onPrev,
//     required this.onNext,
//     required this.onSubmit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         ElevatedButton(
//           onPressed: currentIndex > 0 ? onPrev : null,
//           child: const Text("Prev"),
//         ),
//         const Spacer(),
//         if (currentIndex < total - 1)
//           ElevatedButton(
//             onPressed: onNext,
//             child: const Text("Next"),
//           )
//         else
//           ElevatedButton.icon(
//             onPressed: onSubmit,
//             icon: const Icon(Icons.check),
//             label: const Text("Submit"),
//           ),
//       ],
//     );
//   }
// }
