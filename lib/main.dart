import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DogeWalletApp());
}

class DogeWalletApp extends StatelessWidget {
  const DogeWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DogeWallet Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet, size: 100, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              'DogeWallet Pro',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
            const SizedBox(height: 10),
            const Text(
              'محفظتك المشفرة الآمنة لإدارة عملات Dogecoin',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 52),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateWalletScreen()));
              },
              child: const Text('إنشاء محفظة جديدة', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({super.key});

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final _storage = const FlutterSecureStorage();
  String _mnemonic = "";
  String _address = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    String mnemonic = bip39.generateMnemonic();
    String mockAddress = "D8x${DateTime.now().millisecondsSinceEpoch}DogeProAddress";

    await _storage.write(key: 'mnemonic', value: mnemonic);
    await _storage.write(key: 'address', value: mockAddress);

    setState(() {
      _mnemonic = mnemonic;
      _address = mockAddress;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محفظتك الجديدة')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('عنوانك الشخصي لـ Dogecoin:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  SelectableText(_address, style: const TextStyle(fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  QrImageView(
                    data: _address,
                    version: QrVersions.auto,
                    size: 160.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  const Text('عبارة الاستعادة (12 كلمة):', style: TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_mnemonic, style: const TextStyle(fontSize: 16, height: 1.5), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
    );
  }
}
