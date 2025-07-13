import 'package:flutter/material.dart';
import 'package:oha_sdk_plugin/oha_sdk_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _ohaStatus = 'OHA SDK hazır değil';
  bool _isLoading = false;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String? platformVersion = await OhaSdkPlugin.platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion ?? 'Unknown platform version';
    });
  }

  Future<void> _initializeOHA() async {
    setState(() {
      _isLoading = true;
      _ohaStatus = 'OHA SDK başlatılıyor...';
    });

    try {
      // OHA SDK'yı başlat
      final String? result = await OhaSdkPlugin.initializeOHA(
        ohaBaseUrl:
            'https://your-oha-base-url.com', // Kendi URL'nizi buraya ekleyin
        primaryColor: '#FF6B6B',
        secondaryColor: '#4ECDC4',
        appLogoPath: 'your_base64_logo_here', // Base64 logo veya URL
        isForTesting: true,
        isCloseOnExit: true,
      );

      setState(() {
        _ohaStatus =
            result != null ? 'OHA SDK başlatıldı' : 'OHA SDK başlatılamadı';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _ohaStatus = 'OHA SDK hata: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _startAxOnbService() async {
    if (_idController.text.isEmpty || _smsCodeController.text.isEmpty) {
      _showSnackBar('ID ve SMS kodu gerekli!');
      return;
    }

    setState(() {
      _isLoading = true;
      _ohaStatus = 'AxOnboard servisi başlatılıyor...';
    });

    try {
      final OHAServiceResult? result = await OhaSdkPlugin.startAxOnbService(
        id: _idController.text,
        smsCode: _smsCodeController.text,
        isForTesting: true,
      );

      setState(() {
        if (result != null) {
          _ohaStatus =
              'Servis tamamlandı - Başarı: ${result.success}\nYanıt: ${result.response}';
        } else {
          _ohaStatus = 'Servis başlatılamadı';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _ohaStatus = 'Servis hata: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _closeOHASDK() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String? result = await OhaSdkPlugin.closeOHASDK();
      setState(() {
        _ohaStatus = result ?? 'OHA SDK kapatma hatası';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _ohaStatus = 'Kapatma hata: $e';
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OHA SDK Plugin Example'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Platform: $_platformVersion',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _ohaStatus,
                        style: TextStyle(
                          color: _ohaStatus.contains('hata')
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OHA SDK Başlatma
              ElevatedButton(
                onPressed: _isLoading ? null : _initializeOHA,
                child: _isLoading && _ohaStatus.contains('başlatılıyor')
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('OHA SDK\'yı Başlat'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }
}
