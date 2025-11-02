import 'package:SangKala/src/pages/kuis/result.dart';
import 'package:SangKala/src/providers/progress_provider.dart';
import 'package:SangKala/src/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final String materialId;
  const QuizPage({super.key, required this.materialId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  bool _isSubmitting = false;
  late Future<void> _quizFuture;

  @override
  void initState() {
    super.initState();
    _quizFuture = Provider.of<QuizProvider>(
      context,
      listen: false,
    ).fetchQuiz(widget.materialId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: const Color(0xFF92B4EC), // biru pastel
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _quizFuture,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          // final quizProvider = Provider.of<QuizProvider>(context);
          // final progressProvider = context.read<ProgressProvider>();
          // final quiz = quizProvider.quiz;

          // if (quiz == null) {
          //   return const Center(child: Text("Quiz tidak tersedia"));
          // }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // Ambil provider setelah future selesai
          final quizProvider = context.watch<QuizProvider>();
          // final progressProvider = context.read<ProgressProvider>();
          final quiz = quizProvider.quiz;

          // Jika quiz masih null, tampilkan pesan
          if (quiz == null || quiz.questions.isEmpty) {
            return const Center(child: Text("Quiz tidak tersedia"));
          }
          final question = quiz.questions[_currentIndex];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar + indikator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Soal ${_currentIndex + 1}/${quiz.questions.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${((_currentIndex + 1) / quiz.questions.length * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / quiz.questions.length,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFF92B4EC),
                  ),
                ),
                const SizedBox(height: 20),

                // Pertanyaan dalam card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Pilihan jawaban
                Expanded(
                  child: ListView(
                    children: question.options.map((opt) {
                      final selected =
                          quizProvider.answers[_currentIndex] == opt.label;

                      return GestureDetector(
                        onTap: () {
                          quizProvider.selectAnswer(_currentIndex, opt.label);
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selected
                                ? const Color(0xFF92B4EC).withOpacity(0.15)
                                : Colors.white,
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF92B4EC)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: selected
                                    ? const Color(0xFF92B4EC)
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "${opt.label}. ${opt.text}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                // Navigasi
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _currentIndex > 0
                          ? () => setState(() => _currentIndex--)
                          : null,
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      label: const Text(
                        "Prev",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    const Spacer(),
                    if (_currentIndex < quiz.questions.length - 1)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF92B4EC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        // onPressed: () => setState(() => _currentIndex++),
                        onPressed: () {
                          if (quizProvider.answers[_currentIndex] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Silakan pilih jawaban terlebih dahulu.",
                                ),
                              ),
                            );
                          } else {
                            setState(() => _currentIndex++);
                          }
                        },

                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Next"),
                      )
                    else
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9DC08B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onPressed: _isSubmitting
                            ? null
                            : () async {
                                setState(() => _isSubmitting = true);
                                try {
                                  final quizProvider = context
                                      .read<QuizProvider>();
                                  final progressProvider = context
                                      .read<ProgressProvider>();

                                  final localScore = quizProvider
                                      .calculateScore();
                                  final score = await quizProvider.submitQuiz(
                                    materialId: widget.materialId,
                                  );

                                  if (!mounted) return;
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => QuizResultPage(
                                  //       score: score!,
                                  //       materialId: widget.materialId,
                                  //     ),
                                  //   ),
                                  // );

                                  if (score == null) {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text(
                                    //       "Gagal Submit ke servel, menampilkan skor lokal",
                                    //     ),
                                    //   ),
                                    // );
                                    final progress =
                                        progressProvider.activeProgress;
                                    if (progress != null && progress.done) {
                                      await progressProvider.markAsDone(
                                        progress.id,
                                      );
                                      await progressProvider.goToNextMaterial(
                                        progress.id,
                                      );
                                    }
                                    print(
                                      "gagal submit ke server, menampilkan score loka",
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QuizResultPage(
                                          score: localScore,
                                          materialId: widget.materialId,
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final progress =
                                      progressProvider.activeProgress;
                                  if (progress != null && progress.done) {
                                    await progressProvider.markAsDone(
                                      progress.id,
                                    );
                                    await progressProvider.goToNextMaterial(
                                      progress.id,
                                    );
                                  }
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuizResultPage(
                                        score: score,
                                        materialId: widget.materialId,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Gagal submit quiz: $e"),
                                    ),
                                  );
                                } finally {
                                  setState(() => _isSubmitting = false);
                                }
                              },
                        icon: const Icon(Icons.check_circle),
                        label: Text(_isSubmitting ? "Submitting..." : "Submit"),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:SangKala/src/pages/kuis/quiz_navigator.dart';
// import 'package:SangKala/src/pages/kuis/result.dart';
// import 'package:SangKala/src/providers/progress_provider.dart';
// import 'package:SangKala/src/providers/quiz_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class QuizPage extends StatefulWidget {
//   final String materialId;
//   const QuizPage({super.key, required this.materialId});

//   @override
//   State<QuizPage> createState() => _QuizPageState();
// }

// class _QuizPageState extends State<QuizPage> {
//   int _currentIndex = 0;
//   bool _isSubmitting = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Quiz")),
//       body: FutureBuilder(
//         future: Provider.of<QuizProvider>(
//           context,
//           listen: false,
//         ).fetchQuiz(widget.materialId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final quizProvider = Provider.of<QuizProvider>(context);
//           final progressProvider = context.read<ProgressProvider>();
//           final quiz = quizProvider.quiz;

//           if (quiz == null) {
//             return const Center(child: Text("Quiz tidak tersedia"));
//           }

//           final question = quiz.questions[_currentIndex];

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Progress bar
//                 LinearProgressIndicator(
//                   value: (_currentIndex + 1) / quiz.questions.length,
//                   minHeight: 6,
//                   backgroundColor: Colors.grey.shade300,
//                   color: Colors.blueAccent,
//                 ),
//                 const SizedBox(height: 16),
//                 // Nomor & Pertanyaan
//                 // Nomor & Pertanyaan
//                 Text(
//                   "Q${_currentIndex + 1}/${quiz.questions.length}",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   question.questionText,
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 12),

//                 // Pilihan Jawaban
//                 Expanded(
//                   child: ListView(
//                     children: question.options.map((opt) {
//                       final selected =
//                           quizProvider.answers[_currentIndex] == opt.label;

//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 6),
//                         child: RadioListTile<String>(
//                           value: opt.label,
//                           groupValue: quizProvider.answers[_currentIndex],
//                           onChanged: (val) {
//                             quizProvider.selectAnswer(_currentIndex, val!);
//                           },
//                           title: Text("${opt.label}. ${opt.text}"),
//                           activeColor: Colors.blueAccent,
//                           selected: selected,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),

//                 // Navigasi Next / Prev / Submit
//                 // Navigasi Next / Prev / Submit
//                 QuizNavigator(
//                   currentIndex: _currentIndex,
//                   total: quiz.questions.length,
//                   onPrev: () {
//                     _currentIndex > 0
//                         ? () => setState(() => _currentIndex--)
//                         : null;
//                   },
//                   onNext: () {
//                     _currentIndex < quiz.questions.length - 1
//                         ? () => setState(() => _currentIndex++)
//                         : null;
//                   },
//                   onSubmit: () async {
//                     if (_isSubmitting) return;
//                     setState(() => _isSubmitting = true);

//                     try {
//                       final answersPayload = quizProvider.answers.entries.map((
//                         entry,
//                       ) {
//                         final q = quizProvider.quiz!.questions[entry.key];
//                         return {
//                           "questionId": q.id,
//                           "selectedOption": entry.value,
//                         };
//                       }).toList();

//                       debugPrint(">>> onSubmit answers: $answersPayload");

//                       await progressProvider.submitQuiz(
//                         progressProvider.activeProgress!.id, // progressId
//                         quizProvider.quiz!.id, // quizId
//                         answersPayload,
//                       );

//                       if (!mounted) return;
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               QuizResultPage(score: progressProvider.activeProgress!.score ?? 0),
//                         ),
//                       );
//                     } catch (e) {
//                       if (!mounted) return;
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Gagal submit quiz: $e")),
//                       );
//                     } finally {
//                       setState(() => _isSubmitting = false);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
