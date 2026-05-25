import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// --- a. API SERVICE (SIMULASI) ---
// Kelas ini untuk mensimulasikan panggilan API
class ApiService {
  // Simulasi delay jaringan
  static Future<List<Map<String, dynamic>>> _fetchData(
      List<Map<String, dynamic>> data) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    return data;
  }

  static Future<List<Map<String, dynamic>>> fetchHospitals() async {
    final hospitals = [
      {
        "name": "RSUP Dr. Sardjito",
        "address": "Jl. Kesehatan No. 1, Yogyakarta",
        "phone": "(0274) 561333",
        "rating": 4.8
      },
      {
        "name": "RS PKU Muhammadiyah",
        "address": "Jl. KH. Ahmad Dahlan No. 9, Yogyakarta",
        "phone": "(0274) 511833",
        "rating": 4.6
      },
      {
        "name": "RS Bethesda",
        "address": "Jl. Jend. Sudirman No. 70, Yogyakarta",
        "phone": "(0274) 563333",
        "rating": 4.7
      },
    ];
    return _fetchData(hospitals);
  }

  static Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final doctors = [
      {
        "name": "Dr. Budi Santoso, Sp.PD",
        "specialization": "Penyakit Dalam",
        "hospital": "RSUP Dr. Sardjito",
        "rating": 4.9
      },
      {
        "name": "Dr. Siti Nurhaliza, Sp.OG",
        "specialization": "Obstetri & Ginekologi",
        "hospital": "RS PKU Muhammadiyah",
        "rating": 4.8
      },
      {
        "name": "Dr. Ahmad Fauzi, Sp.A",
        "specialization": "Anak",
        "hospital": "RS Bethesda",
        "rating": 4.9
      },
      {
        "name": "Dr. Rina Andriani, Sp.JP",
        "specialization": "Jantung & Pembuluh Darah",
        "hospital": "RSUP Dr. Sardjito",
        "rating": 4.7
      },
    ];
    return _fetchData(doctors);
  }

  static Future<List<Map<String, dynamic>>> fetchVaccines() async {
    final vaccines = [
      {
        "name": "Influenza",
        "description": "Melindungi dari virus flu musiman.",
        "price": "Rp 250.000"
      },
      {
        "name": "Hepatitis B",
        "description": "Mencegah infeksi virus Hepatitis B.",
        "price": "Rp 350.000"
      },
      {
        "name": "MMR",
        "description": "Mencegah Campak, Gondongan, dan Rubella.",
        "price": "Rp 450.000"
      },
      {
        "name": "COVID-19 (Booster)",
        "description": "Dosis penguat untuk vaksin COVID-19.",
        "price": "Gratis"
      },
    ];
    return _fetchData(vaccines);
  }

  static Future<List<Map<String, dynamic>>> fetchLabs() async {
    final labs = [
      {
        "name": "Lab Klinik CITO",
        "services": "Hematologi, Kimia Klinik, dll.",
        "phone": "(0274) 550000"
      },
      {
        "name": "Prodia",
        "services": "Patologi Anatomi, Mikrobiologi, dll.",
        "phone": "(0274) 517777"
      },
      {
        "name": "Lab Klinik Parahita",
        "services": "Pemeriksaan Narkoba, dll.",
        "phone": "(0274) 887799"
      },
    ];
    return _fetchData(labs);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ECommerceApp());
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Koneksi timeout, coba lagi.'),
          );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return 'Email tidak ditemukan.';
      if (e.code == 'wrong-password') return 'Password salah.';
      if (e.code == 'invalid-credential') return 'Email atau password salah.';
      return 'Login gagal: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  static Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return 'Password terlalu lemah.';
      if (e.code == 'email-already-in-use') return 'Email sudah digunakan.';
      return 'Register gagal: ${e.message}';
    }
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Obat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/beranda': (context) => const BerandaScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/rumah_sakit': (context) => const RumahSakitScreen(),
        '/dokter': (context) => const DokterScreen(),
        '/vaksin': (context) => const VaksinScreen(),
        '/lab': (context) => const LabScreen(),
        '/janji_temu': (context) => const JanjiTemuScreen(),
        '/artikel': (context) => const ArtikelScreen(),
        // b. Tambahkan rute untuk admin dan pembayaran
        '/admin': (context) => const AdminScreen(),
        '/payment': (context) => const PaymentScreen(),
        // e. Tambahkan rute untuk profil
        '/profile': (context) => const ProfileScreen(),
        // Tambahkan rute baru untuk riwayat pesanan
        '/riwayat_pesanan': (context) => const RiwayatPesananScreen(),
      },
    );
  }
}

// --- Halaman SplashScreen ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/Logo.jpeg'),
              ),
            const SizedBox(height: 20),
            Text(
              'Manajemen Obat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// --- Halaman Login ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  static const String _adminEmail = 'admin@manajemenobat.com';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password harus diisi.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await AuthService.login(email, password);

    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    final isAdmin = email == _adminEmail;
    if (isAdmin) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      Navigator.pushReplacementNamed(context, '/beranda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/Logo.jpeg'),
              ),
              const SizedBox(height: 20),
              Text(
                'HALAMAN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot_password');
                          },
                          child: Text(
                            'Lupa Password?',
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              'Daftar',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Halaman Lupa Password ---
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Lupa Password'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_reset,
                    size: 80,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Masukkan email Anda. Kami akan mengirimkan link untuk reset password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Link reset password telah dikirim ke email Anda.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Kirim Link Reset',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Kembali ke Login',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Halaman Register ---
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (_nameController.text.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan konfirmasi password tidak sama.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await AuthService.register(email, password);

    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacementNamed(context, '/beranda');
  }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/Logo.jpeg'),
              ), //harus ganti
              const SizedBox(height: 20),
              Text(
                'HALAMAN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'REGISTRASI',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[700],
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah punya akun?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Halaman Beranda (Icon Beranda) ---
class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Beranda"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          // e. Fungsikan tombol notifikasi
          IconButton(
            icon: const Icon(Icons.notifications, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada notifikasi baru.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 24),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Temukan obat yang Anda butuhkan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.medication,
                    size: 50,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ],
              ),
            ),

            // Grid Menu
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              crossAxisCount: 4,
              children: [
                _buildMenuIcon(
                  icon: Icons.medication,
                  label: 'Obat',
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
                _buildMenuIcon(
                  icon: Icons.local_hospital,
                  label: 'Rumah Sakit',
                  onTap: () => Navigator.pushNamed(context, '/rumah_sakit'),
                ),
                _buildMenuIcon(
                  icon: Icons.health_and_safety,
                  label: 'Vaksin',
                  onTap: () => Navigator.pushNamed(context, '/vaksin'),
                ),
                _buildMenuIcon(
                  icon: Icons.science,
                  label: 'Lab',
                  onTap: () => Navigator.pushNamed(context, '/lab'),
                ),
                _buildMenuIcon(
                  icon: Icons.person,
                  label: 'Dokter',
                  onTap: () => Navigator.pushNamed(context, '/dokter'),
                ),
                _buildMenuIcon(
                  icon: Icons.calendar_month,
                  label: 'Janji Temu',
                  onTap: () => Navigator.pushNamed(context, '/janji_temu'),
                ),
                _buildMenuIcon(
                  icon: Icons.article,
                  label: 'Artikel',
                  onTap: () => Navigator.pushNamed(context, '/artikel'),
                ),
                // e. Fungsikan tombol Lainnya
                _buildMenuIcon(
                  icon: Icons.more_horiz,
                  label: 'Lainnya',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Menu Lainnya"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.logout, color: Colors.red),
                                title: const Text("Keluar", style: TextStyle(color: Colors.red)),
                                onTap: () async {
                                  await AuthService.logout();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (Route<dynamic> route) => false,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            // Promo Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promo Hari Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DealSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on Beranda
              break;
            case 1:
              Navigator.pushNamed(context, '/home');
              break;
            case 2:
              Navigator.pushNamed(context, '/cart');
              break;
            // e. Fungsikan tab profil
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Obat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// --- HALAMAN BARU & YANG DIUBAH ---

// b. Halaman Admin
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await AuthService.logout();
            Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Selamat Datang, Admin!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                await AuthService.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Halaman Rumah Sakit (Menggunakan API) ---
class RumahSakitScreen extends StatefulWidget {
  const RumahSakitScreen({super.key});

  @override
  State<RumahSakitScreen> createState() => _RumahSakitScreenState();
}

class _RumahSakitScreenState extends State<RumahSakitScreen> {
  int? _selectedHospitalIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Pilih Rumah Sakit"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      // a. Menggunakan FutureBuilder untuk API
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchHospitals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data rumah sakit.'));
          }

          final hospitals = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selectedHospitalIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedHospitalIndex = value;
                    });
                  },
                  title: Text(hospital["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hospital["address"]),
                      Text(hospital["phone"]),
                    ],
                  ),
                  secondary:
                      Icon(Icons.local_hospital, color: Colors.blue[700]),
                ),
              );
            },
          );
        },
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedHospitalIndex != null
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rumah Sakit berhasil dipilih!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              "Pilih Rumah Sakit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Halaman Dokter (Menggunakan API) ---
class DokterScreen extends StatefulWidget {
  const DokterScreen({super.key});

  @override
  State<DokterScreen> createState() => _DokterScreenState();
}

class _DokterScreenState extends State<DokterScreen> {
  int? _selectedDoctorIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Pilih Dokter"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data dokter.'));
          }

          final doctors = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selectedDoctorIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedDoctorIndex = value;
                    });
                  },
                  title: Text(doctor["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor["specialization"],
                          style: const TextStyle(color: Colors.grey)),
                      Text(doctor["hospital"],
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  secondary: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/obat.jpg"),
                  ),
                ),
              );
            },
          );
        },
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedDoctorIndex != null
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dokter berhasil dipilih!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              "Pilih Dokter",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Halaman Vaksin (Menggunakan API) ---
class VaksinScreen extends StatefulWidget {
  const VaksinScreen({super.key});

  @override
  State<VaksinScreen> createState() => _VaksinScreenState();
}

class _VaksinScreenState extends State<VaksinScreen> {
  int? _selectedVaccineIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Pilih Vaksin"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchVaccines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data vaksin.'));
          }

          final vaccines = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vaccines.length,
            itemBuilder: (context, index) {
              final vaccine = vaccines[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selectedVaccineIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedVaccineIndex = value;
                    });
                  },
                  title: Text(vaccine["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(vaccine["description"]),
                  secondary: Icon(Icons.vaccines, color: Colors.blue[700]),
                ),
              );
            },
          );
        },
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedVaccineIndex != null
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vaksin berhasil dipilih!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              "Pilih Vaksin",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Halaman Lab (Menggunakan API) ---
class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  int? _selectedLabIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Pilih Lab"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchLabs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data lab.'));
          }

          final labs = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: labs.length,
            itemBuilder: (context, index) {
              final lab = labs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: RadioListTile<int>(
                  value: index,
                  groupValue: _selectedLabIndex,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedLabIndex = value;
                    });
                  },
                  title: Text(lab["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(lab["services"]),
                  secondary: Icon(Icons.science, color: Colors.blue[700]),
                ),
              );
            },
          );
        },
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedLabIndex != null
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lab berhasil dipilih!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              "Pilih Lab",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Halaman Janji Temu (TIDAK DIUBAH) ---
class JanjiTemuScreen extends StatelessWidget {
  const JanjiTemuScreen({super.key});

  final List<Map<String, dynamic>> appointments = const [
    {
      "doctor": "Dr. Budi Santoso, Sp.PD",
      "date": "15 Nov 2023",
      "time": "10:00 WIB",
      "status": "Dikonfirmasi"
    },
    {
      "doctor": "Dr. Siti Nurhaliza, Sp.OG",
      "date": "20 Nov 2023",
      "time": "14:00 WIB",
      "status": "Menunggu"
    },
    {
      "doctor": "Dr. Ahmad Fauzi, Sp.A",
      "date": "05 Nov 2023",
      "time": "09:00 WIB",
      "status": "Selesai"
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Dikonfirmasi":
        return Colors.green;
      case "Menunggu":
        return Colors.orange;
      case "Selesai":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Janji Temu"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.calendar_today,
                  color: Colors.blueAccent, size: 40),
              title: Text(appointment["doctor"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${appointment["date"]} - ${appointment["time"]}'),
              trailing: Text(appointment["status"],
                  style: TextStyle(
                      color: getStatusColor(appointment["status"]),
                      fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}

// --- Halaman Artikel (TIDAK DIUBAH) ---
class ArtikelScreen extends StatelessWidget {
  const ArtikelScreen({super.key});

  final List<Map<String, dynamic>> articles = const [
    {
      "title": "Manfaat Olahraga Rutin untuk Kesehatan Jantung",
      "snippet": "Olahraga tidak hanya baik untuk bentuk tubuh, tetapi juga...",
      "image": "assets/images/obat5.jpg"
    },
    {
      "title": "5 Makanan yang Tinggi Vitamin C",
      "snippet": "Selain jeruk, masih banyak buah dan sayuran lain yang...",
      "image": "assets/images/obat6.jpg"
    },
    {
      "title": "Cara Mengatasi Insomnia Secara Alami",
      "snippet": "Kesulitan tidur dapat mengganggu aktivitas Anda. Cobalah...",
      "image": "assets/images/obat7.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Artikel Kesehatan"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Membuka artikel: ${article["title"]}')),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.asset(article["image"],
                        height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article["title"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(article["snippet"],
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// c. Halaman Pembayaran
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detail Pembayaran",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    // Data dummy, seharusnya didapat dari cart
                    const Text("Total Pembelian: 3 item"),
                    const Text("Subtotal: \$886.00"),
                    const Text("Diskon: -\$4.00"),
                    const Text("Pengiriman: \$2.00"),
                    const Divider(),
                    Text("Total: \$884.00",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Informasi Kartu",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nomor Kartu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'MM/YY',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pembayaran Berhasil!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Kembali ke halaman utama setelah pembayaran
                  Navigator.popUntil(
                      context,
                      (route) =>
                          route.isFirst || route.settings.name == '/beranda');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Bayar Sekarang",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// e. Halaman Profil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/obat.jpg"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Nama Pengguna",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text("user@example.com"),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Riwayat Pesanan"),
              onTap: () {
                // Navigasi ke halaman riwayat pesanan
                Navigator.pushNamed(context, '/riwayat_pesanan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Alamat Pengiriman"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menuju ke Alamat Pengiriman')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- Halaman Riwayat Pesanan (BARU) ---
class RiwayatPesananScreen extends StatelessWidget {
  const RiwayatPesananScreen({super.key});

  // Data dummy riwayat pesanan
  final List<Map<String, dynamic>> _orderHistory = const [
    {
      "orderId": "#ORD001",
      "date": "10 November 2023",
      "status": "Selesai",
      "total": 884.00,
      "items": [
        {"name": "Paracetamol", "quantity": 2, "price": 40.0},
        {"name": "Amoxicillin", "quantity": 2, "price": 333.0},
        {"name": "Vitamin C", "quantity": 2, "price": 60.0},
      ]
    },
    {
      "orderId": "#ORD002",
      "date": "05 November 2023",
      "status": "Dikirim",
      "total": 120.00,
      "items": [
        {"name": "Vitamin C", "quantity": 2, "price": 60.0},
      ]
    },
    {
      "orderId": "#ORD003",
      "date": "28 Oktober 2023",
      "status": "Diproses",
      "total": 80.00,
      "items": [
        {"name": "Paracetamol", "quantity": 2, "price": 40.0},
      ]
    },
  ];

  // Fungsi untuk mendapatkan warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case "Selesai":
        return Colors.green;
      case "Dikirim":
        return Colors.blue;
      case "Diproses":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orderHistory.length,
        itemBuilder: (context, index) {
          final order = _orderHistory[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris atas: ID Pesanan dan Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order["orderId"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              _getStatusColor(order["status"]).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order["status"],
                          style: TextStyle(
                            color: _getStatusColor(order["status"]),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tanggal
                  Text(
                    "Tanggal: ${order["date"]}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  // Daftar Item
                  const Text(
                    "Item Pesanan:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...order["items"].map<Widget>((item) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                      child: Text(
                        "${item["quantity"]}x ${item["name"]}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    );
                  }).toList(),
                  const Divider(height: 20),
                  // Total Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "Rp ${order["total"].toStringAsFixed(2).replaceAll('.', ',')}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- Halaman Home (Asli) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Manajemen Obat"),
        actions: [
          const Icon(Icons.notifications, size: 24),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.shopping_cart, size: 24),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBar(),
            const DealSection(),
            SectionTitle(
                title: "Top Rated Freelancers",
                onViewAll: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Melihat semua Top Rated Freelancers')),
                  );
                }),
            FreelancerList(),
            SectionTitle(
                title: "Top Services",
                onViewAll: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Melihat semua Top Services')),
                  );
                }),
            const ServiceList(),
            const SizedBox(height: 10),
            SectionHeader(
                title: "Best Bookings",
                onViewAll: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Melihat semua Best Bookings')),
                  );
                }),
            const PromoCard(),
            const SizedBox(height: 10),
            const BookingCard(
              name: "Miss Zachary Will",
              subtitle: "Discount consultation with doctor",
              image: "assets/images/obat5.jpg",
              rating: 4.9,
            ),
            const BookingCard(
              name: "Miss Zachary Will",
              subtitle: "Discover your personal style with expert advice",
              image: "assets/images/obat6.jpg",
              rating: 4.8,
            ),
            SectionHeader(
                title: "Recommended Workshops",
                onViewAll: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Melihat semua Recommended Workshops')),
                  );
                }),
            const WorkshopGrid(),
          ],
        ),
      ),
    );
  }
}

// --- Halaman Cart (Keranjang) ---
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {'id': 1, 'name': 'Paracetamol', 'price': 40.0, 'quantity': 2},
    {'id': 2, 'name': 'Amoxicillin', 'price': 333.0, 'quantity': 2},
    {'id': 3, 'name': 'Vitamin C', 'price': 60.0, 'quantity': 2},
    {'id': 4, 'name': 'Ibuprofen', 'price': 80.0, 'quantity': 1},
  ];

  final _formKey = GlobalKey<FormState>();
  String? _name;
  double? _price;
  int? _quantity;

  double get subtotal {
    double total = 0.0;
    for (var item in cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  double get discount => 4.0;
  double get shipping => 2.0;
  double get total => subtotal - discount + shipping;

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void _clearForm() {
    _name = null;
    _price = null;
    _quantity = null;
  }

  void _showAddMedicineDialog() {
    _clearForm();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Obat Baru'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: 220,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nama Obat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama obat harus diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Harga Obat'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga obat harus diisi';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Harga harus berupa angka positif';
                      }
                      return null;
                    },
                    onSaved: (value) => _price = double.tryParse(value ?? ''),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah harus diisi';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Jumlah harus berupa angka positif';
                      }
                      return null;
                    },
                    onSaved: (value) => _quantity = int.tryParse(value ?? ''),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    cartItems.add({
                      'id': cartItems.isEmpty
                          ? 1
                          : cartItems.map((e) => e['id'] as int).reduce(
                                  (value, element) =>
                                      value > element ? value : element) +
                              1,
                      'name': _name,
                      'price': _price,
                      'quantity': _quantity,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMedicineDialog(Map<String, dynamic> item, int index) {
    _name = item['name'];
    _price = item['price'];
    _quantity = item['quantity'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Obat'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: 220,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: 'Nama Obat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama obat harus diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value,
                  ),
                  TextFormField(
                    initialValue: _price?.toString(),
                    decoration: const InputDecoration(labelText: 'Harga Obat'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga obat harus diisi';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Harga harus berupa angka positif';
                      }
                      return null;
                    },
                    onSaved: (value) => _price = double.tryParse(value ?? ''),
                  ),
                  TextFormField(
                    initialValue: _quantity?.toString(),
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah harus diisi';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Jumlah harus berupa angka positif';
                      }
                      return null;
                    },
                    onSaved: (value) => _quantity = int.tryParse(value ?? ''),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    cartItems[index] = {
                      'id': item['id'],
                      'name': _name,
                      'price': _price,
                      'quantity': _quantity,
                    };
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMedicine(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Obat'),
          content: const Text('Apakah Anda yakin ingin menghapus obat ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cartItems.removeAt(index);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("memilih obat"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.medication,
                            size: 40, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                                '\$${(item['price'] as double).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => decreaseQuantity(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.remove, size: 16),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Text('${item['quantity']}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                                InkWell(
                                  onTap: () => increaseQuantity(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.add, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showEditMedicineDialog(item, index),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteMedicine(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order Summary",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildSummaryRow("Items", "${cartItems.length}"),
                _buildSummaryRow(
                    "Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                _buildSummaryRow(
                    "Discount", "-\$${discount.toStringAsFixed(2)}"),
                _buildSummaryRow(
                    "Shipping", "\$${shipping.toStringAsFixed(2)}"),
                const Divider(height: 24),
                _buildSummaryRow("Total", "\$${total.toStringAsFixed(2)}",
                    isTotal: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // c. Navigasi ke halaman pembayaran
                    onPressed: () {
                      Navigator.pushNamed(context, '/payment');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text("Check Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicineDialog,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

// --- Komponen UI Lainnya ---

// --- Medicine Management Screen (CRUD manual, in-memory) ---
class MedicineManagementScreen extends StatefulWidget {
  const MedicineManagementScreen({super.key});

  @override
  State<MedicineManagementScreen> createState() =>
      _MedicineManagementScreenState();
}

class _MedicineManagementScreenState extends State<MedicineManagementScreen> {
  List<Map<String, dynamic>> _medicines = [];
  int _nextId = 1;

  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  int? _quantity;

  void _clearForm() {
    _name = null;
    _description = null;
    _quantity = null;
  }

  void _showAddMedicineDialog() {
    _clearForm();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Obat Baru'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: 220,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nama Obat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama obat harus diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    onSaved: (value) => _description = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah harus diisi';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Jumlah harus berupa angka positif';
                      }
                      return null;
                    },
                    onSaved: (value) => _quantity = int.tryParse(value ?? ''),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    _medicines.add({
                      'id': _nextId++,
                      'name': _name,
                      'description': _description ?? '',
                      'quantity': _quantity ?? 0,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMedicineDialog(Map<String, dynamic> medicine) {
    _name = medicine['name'];
    _description = medicine['description'];
    _quantity = medicine['quantity'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Obat'),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: 220,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _name,
                    decoration: const InputDecoration(labelText: 'Nama Obat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama obat harus diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value,
                  ),
                  TextFormField(
                    initialValue: _description,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    onSaved: (value) => _description = value,
                  ),
                  TextFormField(
                    initialValue: _quantity?.toString(),
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah harus diisi';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Jumlah harus berupa angka positif';
                      }
                      return null;
                    },
                    onSaved: (value) => _quantity = int.tryParse(value ?? ''),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    final index =
                        _medicines.indexWhere((m) => m['id'] == medicine['id']);
                    if (index != -1) {
                      _medicines[index] = {
                        'id': medicine['id'],
                        'name': _name,
                        'description': _description ?? '',
                        'quantity': _quantity ?? 0,
                      };
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMedicine(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Obat'),
          content: const Text('Apakah Anda yakin ingin menghapus obat ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _medicines.removeWhere((m) => m['id'] == id);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Obat'),
        backgroundColor: Colors.blue[700],
      ),
      body: _medicines.isEmpty
          ? const Center(child: Text('Tidak ada data obat.'))
          : ListView.builder(
              itemCount: _medicines.length,
              itemBuilder: (context, index) {
                final medicine = _medicines[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(medicine['name']),
                    subtitle: Text(
                        '${medicine['description']} (Jumlah: ${medicine['quantity']})'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showEditMedicineDialog(medicine),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMedicine(medicine['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMedicineDialog,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search here",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.filter_alt, size: 24),
        ],
      ),
    );
  }
}

class DealSection extends StatelessWidget {
  const DealSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hanya Hari Ini",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("50% OFF",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const Text(
                    "Dapatkan diskon spesial sebesar 50% dengan cara belanja sekarang.",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                // d. Fungsikan tombol BUY IT NOW
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Menuju ke halaman promo')),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text("BUY IT NOW",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/images/obat5.jpg",
                  width: 100, height: 100, fit: BoxFit.cover)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const SectionTitle({super.key, required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.blue[100]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          // e. Fungsikan tombol View All
          TextButton(
              onPressed: onViewAll,
              child: const Text("View All",
                  style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }
}

class FreelancerCard extends StatelessWidget {
  final String name, profession, assetImage;
  final double rating;
  const FreelancerCard(
      {super.key,
      required this.name,
      required this.profession,
      required this.rating,
      required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(backgroundImage: AssetImage(assetImage), radius: 30),
          const SizedBox(height: 5),
          Text(name,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          Text(profession,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(rating.toString(), style: const TextStyle(fontSize: 12))
          ]),
        ],
      ),
    );
  }
}

class FreelancerList extends StatelessWidget {
  final List<Map<String, dynamic>> freelancers = [
    {
      "name": "rizal",
      "profession": "Dokter Umum",
      "rating": 4.9,
      "image": "assets/images/obat.jpg"
    },
    {
      "name": "reza",
      "profession": "Dokter Gizi",
      "rating": 4.9,
      "image": "assets/images/obat2.jpg"
    },
    {
      "name": "adrian",
      "profession": "Dokter Spesialis",
      "rating": 4.9,
      "image": "assets/images/obat3.jpg"
    },
    {
      "name": "budi",
      "profession": "Dokter Anak",
      "rating": 4.9,
      "image": "assets/images/obat4.jpg"
    },
  ];
  FreelancerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: freelancers.length,
        itemBuilder: (context, index) {
          final freelancer = freelancers[index];
          return FreelancerCard(
              name: freelancer["name"],
              profession: freelancer["profession"],
              rating: freelancer["rating"],
              assetImage: freelancer["image"]);
        },
      ),
    );
  }
}

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ServiceCard(
            imageUrl: 'assets/images/obat5.jpg',
            name: 'Reza',
            role: 'Dokter Gigi',
            description: 'Ahli Bidang Gigi.',
            rating: 4.9),
        ServiceCard(
            imageUrl: 'assets/images/obat6.jpg',
            name: 'adrian',
            role: 'Dokter Spesialis Jantung',
            description: 'Ahli Bidang Jantung',
            rating: 4.8),
        ServiceCard(
            imageUrl: 'assets/images/obat7.jpg',
            name: 'Budi',
            role: 'Dokter Anak',
            description: 'Ahli Bidang Anak-anak',
            rating: 4.8),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String imageUrl, name, role, description;
  final double rating;
  const ServiceCard(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.role,
      required this.description,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imageUrl,
                    width: 80, height: 80, fit: BoxFit.cover)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(role,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        Text(rating.toString(),
                            style: const TextStyle(fontSize: 14))
                      ]),
                      // d. Fungsikan tombol Book Now
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Memesan layanan dari $name')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 81, 89, 185)),
                        child: const Text("Book Now",
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const SectionHeader(
      {super.key, required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueAccent)),
          // e. Fungsikan tombol View All
          GestureDetector(
            onTap: onViewAll,
            child: const Text("View All",
                style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color(0xFFEDF2FF),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("End of Year Promo",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const Text("Flat 60% OFF",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("On all fashion & beauty items",
                      style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Menuju ke halaman promo End of Year')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 18)),
                    child: const Text("Shop Now"),
                  ),
                ],
              ),
            ),
            Image.asset("assets/images/obat8.jpg", height: 100),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String name, subtitle, image;
  final double rating;
  const BookingCard(
      {super.key,
      required this.name,
      required this.subtitle,
      required this.image,
      required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(image,
                  height: 150, width: double.infinity, fit: BoxFit.cover)),
          ListTile(
            leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/obat8.jpg")),
            title: Text(name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(rating.toString())
            ]),
          ),
        ],
      ),
    );
  }
}

class WorkshopGrid extends StatelessWidget {
  const WorkshopGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final workshops = [
      {
        "name": "Workshop A",
        "desc": "Learn nail art and beauty tips",
        "image": "assets/images/obat8.jpg"
      },
      {
        "name": "Workshop B",
        "desc": "Learn creative photography",
        "image": "assets/images/obat9.jpg"
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 230,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8),
      itemCount: workshops.length,
      itemBuilder: (context, index) {
        final item = workshops[index];
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(item["image"]!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover)),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item["name"]!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(item["desc"]!,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 6),
                      // d. Fungsikan tombol Book Workshop
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Mendaftar ke ${item["name"]}')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Colors.blueAccent)),
                        child: const Text("Book Workshop",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}
