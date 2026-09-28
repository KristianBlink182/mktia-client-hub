import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

// ---------------- FONDO DE ONDAS CUÁNTICAS NEÓN Y CÓDIGO FUENTE ----------------
class CyberWavesPainter extends CustomPainter {
  final double animation;
  CyberWavesPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Resplandor ambiental superior
    final radialGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8B5CF6).withOpacity(0.28),
          const Color(0xFF00F0FF).withOpacity(0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.22), radius: 280));
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.22), 280, radialGlow);

    // 2. Líneas de código flotantes en segundo plano
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final snippets = [
      "import { QuantumEngine } from '@mktia/core';",
      "const pipeline = await initCloudCluster();",
      "STATUS: ZERO-TRUST ARMED [OK]",
      "LATENCY: 8ms • EDGE: MIAMI-DC",
      "deploying release: v2.1.0-rc...",
      "01101101 01101011 01110100 01101001 01100001",
    ];

    for (int i = 0; i < snippets.length; i++) {
      final yPos = (size.height * 0.15) + (i * 90.0) + (sin(animation * 2 * pi + i) * 12);
      textPainter.text = TextSpan(
        text: snippets[i],
        style: TextStyle(
          fontFamily: 'monospace',
          color: const Color(0xFF00F0FF).withOpacity(0.14),
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(24.0 + (i % 2 == 0 ? 0 : 40), yPos));
    }

    // 3. Ondas electromagnéticas luminosas que fluyen y cambian de color
    for (int wave = 0; wave < 4; wave++) {
      final path = Path();
      final waveOffset = animation * 2 * pi + (wave * 0.8);
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 - (wave * 0.3)
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF00F0FF).withOpacity(0.45 - (wave * 0.08)),
            const Color(0xFF8B5CF6).withOpacity(0.65 - (wave * 0.08)),
            Colors.transparent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final baseHeight = size.height * (0.65 + (wave * 0.08));
      path.moveTo(0, baseHeight);

      for (double x = 0; x <= size.width; x += 8) {
        final y = baseHeight +
            (sin((x / 70) + waveOffset) * 26) +
            (cos((x / 110) - waveOffset) * 18);
        path.lineTo(x, y);
      }

      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CyberWavesPainter oldDelegate) => true;
}

// ---------------- LOGIN CON LOGO CENTRADO Y ANIMACIONES DE ALTO IMPACTO ----------------
class TechLoginScreen extends StatefulWidget {
  const TechLoginScreen({super.key});

  @override
  State<TechLoginScreen> createState() => _TechLoginScreenState();
}

class _TechLoginScreenState extends State<TechLoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _error = "Ingresa tu código de proyecto");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http
          .get(Uri.parse("https://mktia.pe/api/projects.php?code=$code"))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final p = data['project'];

        _openProject(ClientProject(
          clientName: p['clientName'] ?? "Cliente MktIA",
          projectName: p['projectName'] ?? "Sistema a Medida",
          activeVersion: p['activeVersion'] ?? "v1.4.2",
          progress: (p['progress'] as num).toDouble(),
          nextDelivery: p['nextDelivery'] ?? "Próxima entrega prevista pronto.",
          demoUrl: p['demoUrl'] ?? "https://mktia.pe",
          phases: _buildDefaultPhases((p['progress'] as num).toDouble()),
        ));
        return;
      }
    } catch (_) {
      // Respaldo instantáneo si el servidor tarda
    }

    // Respaldo local
    if (code == "EQUI-2026" || code == "LIVO-PROP" || code == "ABUELITOS-PE" || code.startsWith("CLI-")) {
      _openProject(ClientProject(
        clientName: code == "EQUI-2026"
            ? "EQUI Salud SAC"
            : code == "LIVO-PROP"
                ? "LIVO Inmobiliaria"
                : "Cliente MktIA Studio",
        projectName: code == "EQUI-2026"
            ? "Plataforma Médica & Apps"
            : code == "LIVO-PROP"
                ? "SaaS de Administración de Condominios"
                : "Sistema de Alto Impacto",
        activeVersion: "v1.4.2-staging",
        progress: code == "EQUI-2026" ? 0.92 : 0.74,
        nextDelivery: "Próxima entrega prevista en 4 días.",
        demoUrl: code == "EQUI-2026" ? "https://equi.pe" : "https://mktia.pe",
        phases: _buildDefaultPhases(code == "EQUI-2026" ? 0.92 : 0.74),
      ));
    } else {
      setState(() => _error = "Código de proyecto no encontrado. Verifica con tu Tech Lead.");
      setState(() => _isLoading = false);
    }
  }

  void _openProject(ClientProject project) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen(project: project)),
    );
  }

  List<SprintPhase> _buildDefaultPhases(double progress) {
    return [
      SprintPhase("1. Arquitectura & UI/UX Figma", 1.0, "Completado y Aprobado", const Color(0xFF10B981)),
      SprintPhase("2. Backend, Base de Datos & APIs", 1.0, "100% Funcional", const Color(0xFF10B981)),
      SprintPhase("3. Frontend WebGL & App Móvil", progress > 0.5 ? 0.75 : 0.30, "En desarrollo activo", const Color(0xFF00F0FF)),
      SprintPhase("4. Pruebas QA & Seguridad Zero-Trust", progress > 0.8 ? 0.50 : 0.15, "Pendiente de integración", Colors.amber),
      SprintPhase("5. Despliegue en Servidores Cloud", progress >= 1.0 ? 1.0 : 0.0, "Programado", Colors.white30),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040507),
      body: Stack(
        children: [
          // 1. Animador de Ondas y Código Fuente
          AnimatedBuilder(
            animation: _animController,
            builder: (context, _) => CustomPaint(
              painter: CyberWavesPainter(_animController.value),
              size: Size.infinite,
            ),
          ),

          // 2. Contenido del Login Centrado
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo oficial de MktIA
                  Image.asset(
                    "assets/images/logo.png",
                    height: 58,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Mkt", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36, color: Colors.white)),
                        const Text("ÎA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36, color: Color(0xFF00F0FF))),
                      ],
                    ),
                  ).animate().fade(duration: 500.ms).slideY(begin: -0.1),

                  const SizedBox(height: 12),

                  // Badge Neón
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00F0FF).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.35)),
                    ),
                    child: const Text(
                      "CLIENT HUB • SEGUIMIENTO EN VIVO",
                      style: TextStyle(
                        color: Color(0xFF00F0FF),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ).animate().fade(delay: 150.ms),

                  const SizedBox(height: 34),

                  // Tarjeta Glassmorphism
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090B10).withOpacity(0.88),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF00F0FF).withOpacity(0.1), blurRadius: 40, spreadRadius: 2),
                        BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 30, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CÓDIGO DE ACCESO DEL PROYECTO",
                          style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
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
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: 2.5),
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
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.1),

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

// ---------------- DASHBOARD COMPLETO ----------------
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