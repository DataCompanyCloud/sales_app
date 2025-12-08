import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DownloadStatus {
  idle,
  downloading,
  completed,
  cancelled,
}

class DownloadState {
  final DownloadStatus status;
  final int total;
  final int downloaded;

  const DownloadState({
    required this.status,
    required this.total,
    required this.downloaded,
  });

  double get progress =>
      total == 0 ? 0 : downloaded / total;

  factory DownloadState.initial() =>
      const DownloadState(status: DownloadStatus.idle, total: 100, downloaded: 0);

  DownloadState copyWith({
    DownloadStatus? status,
    int? total,
    int? downloaded,
  }) {
    return DownloadState(
      status: status ?? this.status,
      total: total ?? this.total,
      downloaded: downloaded ?? this.downloaded,
    );
  }
}

class DownloadController extends StateNotifier<DownloadState> {
  DownloadController() : super(DownloadState.initial());

  bool _cancelRequested = false;

  Future<void> startDownload() async {
    if (state.status == DownloadStatus.downloading) return;

    _cancelRequested = false;

    state = state.copyWith(
      status: DownloadStatus.downloading,
      downloaded: 0,
    );

    for (int i = 1; i <= state.total; i++) {
      if (_cancelRequested) {
        state = state.copyWith(
          status: DownloadStatus.cancelled,
        );
        return;
      }

      await Future.delayed(const Duration(milliseconds: 40));

      state = state.copyWith(downloaded: i);
    }

    state = state.copyWith(status: DownloadStatus.completed);
  }

  void cancel() {
    if (state.status == DownloadStatus.downloading) {
      _cancelRequested = true;
    }
  }

  void reset() {
    _cancelRequested = false;
    state = DownloadState.initial();
  }
}

final downloadProvider =
StateNotifierProvider<DownloadController, DownloadState>(
      (ref) => DownloadController(),
);


// Esse é o card em si
class DownloadCard extends ConsumerWidget {
  const DownloadCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(downloadProvider);
    final controller = ref.read(downloadProvider.notifier);

    final isDownloading = state.status == DownloadStatus.downloading;
    final isCompleted = state.status == DownloadStatus.completed;
    final isCancelled = state.status == DownloadStatus.cancelled;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
          ? Colors.green.shade50
          : isCancelled
          ? Colors.red.shade50
          : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
        border: Border.all(
          color: isCompleted
            ? Colors.green.shade300
            : isCancelled
            ? Colors.red.shade300
            : Colors.grey.shade200,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone animado
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
            child: isCompleted
                ? Icon(
              Icons.check_circle,
              key: const ValueKey('done'),
              color: Colors.green.shade400,
              size: 40,
            )
                : isCancelled
                ? Icon(
              Icons.cancel,
              key: const ValueKey('cancelled'),
              color: Colors.red.shade400,
              size: 40,
            )
                : Icon(
              Icons.cloud_download,
              key: const ValueKey('download'),
              color: Colors.indigo.shade400,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Download de produtos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Baixar 100 produtos para uso offline.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Barra de progresso animada
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: state.progress),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isCompleted
                            ? 'Concluído'
                            : isCancelled
                            ? 'Cancelado'
                            : isDownloading
                            ? 'Baixando...'
                            : 'Pronto para iniciar',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${state.downloaded}/${state.total}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          // 🔹 Botão de cancelar no MEIO, visível só durante o download
          if (isDownloading)
            Center(
              child: TextButton.icon(
                onPressed: () => controller.cancel(),
                icon: const Icon(Icons.close),
                label: const Text('Cancelar'),
              ),
            ),

          const SizedBox(height: 12),

          // Botão principal embaixo
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isDownloading
                      ? null
                      : () {
                    if (isCompleted || isCancelled) {
                      controller.reset();
                    } else {
                      controller.startDownload();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isDownloading
                          ? Row(
                        key: const ValueKey('downloading'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Baixando...'),
                        ],
                      )
                        : Text(
                        isCompleted
                            ? 'Baixar novamente'
                            : isCancelled
                            ? 'Tentar novamente'
                            : 'Baixar 100 produtos',
                        key: ValueKey(state.status),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}