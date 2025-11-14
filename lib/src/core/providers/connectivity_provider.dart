import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus {
  online,
  offline,
}

final networkStatusProvider = StreamProvider.autoDispose<NetworkStatus>((ref) async* {
  final connectivity = Connectivity();

  // estado inicial
  final initial = await connectivity.checkConnectivity();
  yield _mapConnectivityResult(initial);

  // atualizações em tempo real
  yield* connectivity.onConnectivityChanged.map(_mapConnectivityResult);
});

NetworkStatus _mapConnectivityResult(List<ConnectivityResult> results) {
  if (results.isEmpty || results.contains(ConnectivityResult.none)) {
    return NetworkStatus.offline;
  }

  final hasNetwork = results.contains(ConnectivityResult.mobile) ||
      results.contains(ConnectivityResult.wifi) ||
      results.contains(ConnectivityResult.ethernet);

  return hasNetwork ? NetworkStatus.online : NetworkStatus.offline;
}


final isConnectedProvider = Provider.autoDispose<bool>((ref) {
  final asyncStatus = ref.watch(networkStatusProvider);

  // Se ainda estiver carregando / erro, considera offline por segurança
  return asyncStatus.maybeWhen(
    data: (status) => status == NetworkStatus.online,
    orElse: () => false,
  );
});
