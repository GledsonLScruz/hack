import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              totalSteps,
              (index) => Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStepCircle(context, index),
                    ),
                    if (index < totalSteps - 1)
                      Expanded(
                        child: _buildStepLine(context, index),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              totalSteps,
              (index) => Expanded(
                child: Text(
                  stepLabels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: index == currentStep
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: index <= currentStep
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(BuildContext context, int index) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;

    return Center(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted
              ? Theme.of(context).colorScheme.primary
              : isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300],
        ),
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(BuildContext context, int index) {
    final isCompleted = index < currentStep;

    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300],
      ),
    );
  }
}

