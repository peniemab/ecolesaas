import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import 'network_connectivity_provider.dart';
import 'network_connectivity_status.dart';

/// Bandeau global quand aucune interface utilisable (L-03 minimal).
class OfflineBannerHost extends ConsumerWidget {
  const OfflineBannerHost({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final net = ref.watch(networkConnectivityProvider);
    final offline = net.maybeWhen(
      data: (s) => s == NetworkConnectivityStatus.offline,
      orElse: () => false,
    );

    final body = child ?? const SizedBox.shrink();

    if (!offline) {
      return body;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.orange.shade800,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Hors ligne — les données affichées peuvent être anciennes. '
                'Les modifications seront envoyées dès que la connexion reviendra.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                  fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: AppColors.background,
            child: body,
          ),
        ),
      ],
    );
  }
}
