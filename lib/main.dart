import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MktiaApp());
}

class MktiaApp extends StatelessWidget {
  const MktiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MktIA Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040507),
        primaryColor: const Color(0xFF00F0FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F0FF),
          secondary: Color(0xFF8B5CF6),
        ),
      ),
      home: const TechLoginScreen(),
    );
  }
}

// ---------------- FONDO TECNOLÓGICO MATRIZ ----------------
class CyberMatrixPainter extends CustomPainter {
  final double progress;
  CyberMatrixPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF00F0FF).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFF8B5CF6).withOpacity(0.08)
      ..strokeWidth = 0.8;

    const spacing = 36.0;
    final waveOffset = progress * 2 * pi;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final double distortion = sin((x / 60) + waveOffset) * cos((y / 60) + waveOffset) * 6;
        final point = Offset(x + distortion, y + distortion);
        
        canvas.drawCircle(point, 1.2, dotPaint);

        if (x + spacing < size.width && (x.toInt() % 72 == 0)) {
          canvas.drawLine(point, Offset(x + spacing + distortion, y + distortion), linePaint);
        }
      }
    }

    final centerGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00F0FF).withOpacity(0.12),
          const Color(0xFF8B5CF6).withOpacity(0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.35), radius: 300));

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.35), 300, centerGlow);
  }

  @override
  bool shouldRepaint(covariant CyberMatrixPainter oldDelegate) => true;
}

// ---------------- LOGIN CON LOGO CENTRADO ----------------
class TechLoginScreen extends StatefulWidget {
  const TechLoginScreen({super.key});

  @override
  State<TechLoginScreen> createState() => _TechLoginScreenState();
}

class _TechLoginScreenState extends State<TechLoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _login() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _error = "Ingresa tu código de proyecto");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    Future.delayed(const Duration(milliseconds: 1300), () {
      setState(() => _isLoading = false);

      final project = ClientProject(
        clientName: code == "EQUI-2026" ? "EQUI Salud SAC" : "Corporación Global SAC",
        projectName: code == "EQUI-2026" ? "Plataforma Médica & Apps" : "Sistema ERP & App Logística",
        activeVersion: "v1.4.2-staging",
        progress: code == "EQUI-2026" ? 0.92 : 0.74,
        nextDelivery: "Próxima entrega prevista en 4 días.",
        demoUrl: "https://mktia.pe",
        phases: [
          SprintPhase("1. Arquitectura & UI/UX Figma", 1.0, "Completado y Aprobado", const Color(0xFF10B981)),
          SprintPhase("2. Backend, Base de Datos & APIs", 1.0, "100% Funcional", const Color(0xFF10B981)),
          SprintPhase("3. Frontend WebGL & App Móvil", 0.75, "En desarrollo activo (Sprint 3)", const Color(0xFF00F0FF)),
          SprintPhase("4. Pruebas QA & Seguridad Zero-Trust", 0.20, "Pendiente de integración final", Colors.amber),
          SprintPhase("5. Despliegue en Servidores Cloud", 0.0, "Programado", Colors.white30),
        ],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen(project: project)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040507),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: CyberMatrixPainter(_controller.value),
              size: Size.infinite,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Mkt", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36, color: Colors.white)),
                          const Text("ÎA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36, color: Color(0xFF00F0FF))),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00F0FF).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.4)),
                            ),
                            child: const Text("CLIENT HUB", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00F0FF))),
                          ),
                        ],
                      );
                    },
                  ).animate().fade(duration: 500.ms).slideY(begin: -0.1),

                  const SizedBox(height: 10),

                  const Text(
                    "PORTAL DE SEGUIMIENTO EN TIEMPO REAL",
                    style: TextStyle(
                      color: Color(0xFF00F0FF),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 36),

                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: const Color(0xFF080A0F).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF00F0FF).withOpacity(0.08), blurRadius: 40, spreadRadius: 2),
                        BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 30, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CÓDIGO DE PROYECTO",
                          style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF040507),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.4)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          child: TextField(
                            controller: _codeController,
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: 2),
                            decoration: const InputDecoration(
                              icon: Icon(Icons.vpn_key_rounded, color: Color(0xFF00F0FF), size: 20),
                              hintText: "EJ. EQUI-2026",
                              hintStyle: TextStyle(color: Colors.white24, letterSpacing: 1, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        if (_error != null) ...[
                          const SizedBox(height: 10),
                          Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
                        ],

                        const SizedBox(height: 22),

                        GestureDetector(
                          onTap: _isLoading ? null : _login,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF00F0FF), Color(0xFF2563EB)]),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFF00F0FF).withOpacity(0.35), blurRadius: 25, offset: const Offset(0, 4)),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("INGRESAR A MI PROYECTO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.8)),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 18),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 150.ms).slideY(begin: 0.1),

                  const SizedBox(height: 32),
                  const Text("Desarrollado por MktIA Studio • soporte@mktia.pe", style: TextStyle(color: Colors.white24, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- DASHBOARD ----------------
class ClientProject {
  final String clientName;
  final String projectName;
  final String activeVersion;
  final double progress;
  final String nextDelivery;
  final String demoUrl;
  final List<SprintPhase> phases;

  ClientProject({
    required this.clientName,
    required this.projectName,
    required this.activeVersion,
    required this.progress,
    required this.nextDelivery,
    required this.demoUrl,
    required this.phases,
  });
}

class SprintPhase {
  final String title;
  final double progress;
  final String status;
  final Color color;
  SprintPhase(this.title, this.progress, this.status, this.color);
}

class DashboardScreen extends StatefulWidget {
  final ClientProject project;
  const DashboardScreen({super.key, required this.project});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final proj = widget.project;

    return Scaffold(
      backgroundColor: const Color(0xFF040507),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080A0F),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 28,
              errorBuilder: (context, error, stackTrace) => const Text("MktIA", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.3)),
              ),
              child: const Text("CLIENT HUB", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00F0FF), letterSpacing: 1.2)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white54, size: 20),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TechLoginScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F1117), Color(0xFF161922)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(proj.clientName, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(proj.projectName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.4)),
                        ),
                        child: Text(proj.activeVersion, style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                            SizedBox(width: 5),
                            Text("En Desarrollo Activo", style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0C10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 8.0,
                    percent: proj.progress,
                    center: Text("${(proj.progress * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                    progressColor: const Color(0xFF00F0FF),
                    backgroundColor: Colors.white10,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1000,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Avance General", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(proj.nextDelivery, style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            GestureDetector(
              onTap: () async {
                final uri = Uri.parse(proj.demoUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF00F0FF), Color(0xFF2563EB)]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF00F0FF).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch, color: Colors.black, size: 20),
                    SizedBox(width: 10),
                    Text("PROBAR DEMO / STAGING EN VIVO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.8)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text("Fases del Desarrollo", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),

            ...proj.phases.map((phase) => _buildSprintItem(phase.title, phase.progress, phase.status, phase.color)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF080A0F),
        selectedItemColor: const Color(0xFF00F0FF),
        unselectedItemColor: Colors.white38,
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: "Proyecto"),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "Changelog"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: "Tech Lead"),
        ],
      ),
    );
  }

  Widget _buildSprintItem(String title, double progress, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0C10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              Text("${(progress * 100).toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 6.0,
            percent: progress,
            progressColor: color,
            backgroundColor: Colors.white10,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Text(status, style: TextStyle(color: color.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}