import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetService with ChangeNotifier {
  static final InternetService _instance = InternetService._internal();
  factory InternetService() => _instance;
  InternetService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  void startMonitoring() {
    _subscription?.cancel();

    checkConnection();

    _subscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      await _handleConnectivityChange(results);
    });
  }

  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _handleConnectivityChange(
    List<ConnectivityResult> results,
  ) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      _updateConnectionStatus(false);
    } else {
      bool hasRealInternet = await performRealInternetCheck();
      _updateConnectionStatus(hasRealInternet);
    }
  }

  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      _updateConnectionStatus(false);
      return false;
    } else {
      bool hasRealInternet = await performRealInternetCheck();
      _updateConnectionStatus(hasRealInternet);
      return hasRealInternet;
    }
  }

  Future<bool> performRealInternetCheck() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  void _updateConnectionStatus(bool status) {
    if (_isConnected != status) {
      _isConnected = status;
      notifyListeners();
    }
  }
}

class InternetConnectionWrapper extends StatefulWidget {
  final Widget child;
  const InternetConnectionWrapper({super.key, required this.child});

  @override
  State<InternetConnectionWrapper> createState() =>
      _InternetConnectionWrapperState();
}

class _InternetConnectionWrapperState extends State<InternetConnectionWrapper> {
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      InternetService().addListener(_onConnectionChanged);

      if (!InternetService().isConnected) {
        _showOfflineSnackBar();
        _wasOffline = true;
      }
    });
  }

  @override
  void dispose() {
    InternetService().removeListener(_onConnectionChanged);
    super.dispose();
  }

  void _onConnectionChanged() {
    final isConnected = InternetService().isConnected;
    if (!isConnected) {
      _showOfflineSnackBar();
      _wasOffline = true;
    } else {
      if (_wasOffline) {
        _showOnlineSnackBar();
        _wasOffline = false;
      } else {
        _dismissSnackBar();
      }
    }
  }

  void _showOfflineSnackBar() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi_off_rounded, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Please check your internet connection.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(days: 365),
      ),
    );
  }

  void _showOnlineSnackBar() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi_rounded, color: Colors.white, size: 22),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Back online!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _dismissSnackBar() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
