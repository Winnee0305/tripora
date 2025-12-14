import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_sticky_header.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/feedback/viewmodels/tam_viewmodel.dart';

class TAMQuestionsScreen extends StatelessWidget {
  const TAMQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TAMViewModel>(
      builder: (context, tamVm, _) {
        final currentQuestion = tamVm.currentQuestion;
        final questionText = tamVm.getCurrentQuestionText();
        final currentResponse = tamVm.getCurrentResponse();
        final isAnswered = tamVm.isCurrentQuestionAnswered();
        final totalQuestions = TAMViewModel.totalQuestions;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const AppStickyHeader(
                  title: 'User Feedback',
                  showRightButton: false,
                ),
                const SizedBox(height: 20),

                // Progress info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${currentQuestion + 1} of $totalQuestions',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${((currentQuestion + 1) / totalQuestions * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (currentQuestion + 1) / totalQuestions,
                          minHeight: 6,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Question content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Column(
                      children: [
                        Text(
                          questionText,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),

                        // Likert Scale
                        Column(
                          children: [
                            // Scale labels
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Strongly\nDisagree',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    'Strongly\nAgree',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Scale options
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: List.generate(7, (index) {
                                    final value = index + 1;
                                    final isSelected = currentResponse == value;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: GestureDetector(
                                      onTap: () {
                                        tamVm.setResponse(value);
                                        // Auto-advance to next question if not on last question
                                        if (currentQuestion < TAMViewModel.totalQuestions - 1) {
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            tamVm.nextQuestion();
                                          });
                                        }
                                      },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Theme.of(context).colorScheme.primary
                                                      : Colors.grey[300] ?? Colors.grey,
                                                  width: isSelected ? 2 : 1.5,
                                                ),
                                                color: isSelected
                                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                                    : Colors.transparent,
                                              ),
                                              child: isSelected
                                                  ? Center(
                                                      child: Container(
                                                        width: 12,
                                                        height: 12,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '$value',
                                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: isSelected
                                                    ? Theme.of(context).colorScheme.primary
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: currentQuestion > 0 ? () => tamVm.previousQuestion() : null,
                          child: Text(
                            'Back',
                            style: TextStyle(
                              color: currentQuestion > 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[400],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton.primary(
                          onPressed: isAnswered ? () => tamVm.nextQuestion() : null,
                          text: currentQuestion == TAMViewModel.totalQuestions - 1
                              ? 'Submit'
                              : 'Next',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
