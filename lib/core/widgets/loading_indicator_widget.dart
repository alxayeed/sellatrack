import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final String? message;

  const LoadingIndicatorWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.titleMedium),
          ],
        ],
      ),
    );
  }
}
