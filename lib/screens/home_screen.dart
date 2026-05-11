import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'no_internet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _baseUrl = 'https://www.mavin-wear.com';

  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _setupWebView();
    _listenToConnectivity();
  }

  void _setupWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onProgress: (progress) {
            setState(() => _loadingProgress = progress / 100.0);
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame ?? true) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.contains('mavin-wear.com')) {
              return NavigationDecision.navigate;
            }
            _launchExternalUrl(url);
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_baseUrl));
  }

  void _launchExternalUrl(String url) {}

  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
      if (results.contains(ConnectivityResult.none) && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NoInternetScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          _controller.goBack();
        } else {
          final shouldExit = await _showExitDialog();
          if (shouldExit && context.mounted) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              RefreshIndicator(
                color: Colors.black,
                strokeWidth: 2.5,
                onRefresh: () async {
                  _controller.reload();
                },
                child: _hasError
                    ? _buildErrorView()
                    : WebViewWidget(controller: _controller),
              ),

              if (_isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _loadingProgress > 0 ? _loadingProgress : null,
                    minHeight: 2.5,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            const Text(
              'Failed to load page',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _controller.reload(),
                child: const Text(
                  'TRY AGAIN',
                  style: TextStyle(letterSpacing: 1.2, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: const Text(
              'Exit Mavin Wear?',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            content: const Text(
              'Are you sure you want to exit the app?',
              style: TextStyle(color: Colors.black54),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'STAY',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'EXIT',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
