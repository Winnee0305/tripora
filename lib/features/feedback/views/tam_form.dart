import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/feedback/viewmodels/tam_viewmodel.dart';
import 'package:tripora/features/feedback/views/tam_invitation_screen.dart';
import 'package:tripora/features/feedback/views/tam_questions_screen.dart';
import 'package:tripora/features/feedback/views/tam_completion_screen.dart';

class TAMForm extends StatefulWidget {
  final String userId;
  final VoidCallback? onComplete; // Called after successful submission

  const TAMForm({super.key, required this.userId, this.onComplete});

  @override
  State<TAMForm> createState() => _TAMFormState();
}

class _TAMFormState extends State<TAMForm> {
  late TAMViewModel _tamVm;
  int _screenState = 0; // 0: Invitation, 1: Questions, 2: Completion
  int _lastQuestionIndex = -1; // Track if we've already submitted
  bool _hasInitialized = false; // Track if we've reset the form

  @override
  void initState() {
    super.initState();
    _tamVm = context.read<TAMViewModel>();
    // Reset after frame completes to avoid notifyListeners during build
    if (!_hasInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _tamVm.reset();
          _hasInitialized = true;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    final success = await _tamVm.submitTAM(widget.userId);

    if (!mounted) return;

    if (success) {
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Feedback submitted successfully, thank you for your time!',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Pop the form after snackbar is shown
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.onComplete?.call();
          Navigator.pop(context);
        }
      });
    } else {
      // Defer error display to after current frame completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_tamVm.error ?? 'Error submitting feedback'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _screenState == 0, // Only allow pop from invitation screen
      onPopInvoked: (didPop) {
        if (!didPop && _screenState == 1) {
          // On questions screen, go back to invitation
          setState(() => _screenState = 0);
        }
      },
      child: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    switch (_screenState) {
      case 0:
        return TAMInvitationScreen(
          onStart: () => setState(() => _screenState = 1),
          onSkip: () => Navigator.pop(context),
        );
      case 1:
        return Consumer<TAMViewModel>(
          builder: (context, tamVm, _) {
            // Only check submission once when reaching the last question
            if (tamVm.currentQuestion == TAMViewModel.totalQuestions - 1 &&
                tamVm.isCurrentQuestionAnswered() &&
                _lastQuestionIndex != TAMViewModel.totalQuestions - 1) {
              _lastQuestionIndex = TAMViewModel.totalQuestions - 1;
              // Schedule submit after build completes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleSubmit();
              });
            }

            return Stack(
              children: [
                const TAMQuestionsScreen(),
                if (tamVm.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        );
      case 2:
        return TAMCompletionScreen(onDone: () => Navigator.pop(context));
      default:
        return const SizedBox.shrink();
    }
  }
}
