import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

// --- TEMA VISUAL GAMING ---
class AppTheme {
  static const Color background = Color(0xFF0B0B0F);
  static const Color cardColor = Color(0xFF14141E);
  static const Color primaryNeonRed = Color(0xFFFF1744);
  static const Color secondaryCyan = Color(0xFF00E5FF);
  static const Color textLight = Color(0xFFECEFF1);
  static const Color textMuted = Color(0xFF90A4AE);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        primaryColor: primaryNeonRed,
        fontFamily: 'sans-serif',
        colorScheme: const ColorScheme.dark(
          primary: primaryNeonRed,
          secondary: secondaryCyan,
          surface: cardColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryNeonRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      );
}

// --- DIBUJO DEL ESCORPIÓN FITZ ---
class FitzAvatar extends StatelessWidget {
  final double size;
  const FitzAvatar({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.cardColor,
        border: Border.all(color: AppTheme.primaryNeonRed, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryNeonRed.withValues(alpha: 0.35),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomPaint(painter: _ScorpionPainter()),
    );
  }
}

class _ScorpionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()..color = AppTheme.primaryNeonRed..style = PaintingStyle.fill;
    final cyan = Paint()..color = AppTheme.secondaryCyan..style = PaintingStyle.fill;
    final stroke = Paint()..color = AppTheme.primaryNeonRed..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2 + 4);

    for (int i = -1; i <= 1; i += 2) {
      canvas.drawLine(Offset(center.dx + (i * 12), center.dy - 2), Offset(center.dx + (i * 24), center.dy - 8), stroke);
      canvas.drawLine(Offset(center.dx + (i * 14), center.dy + 8), Offset(center.dx + (i * 26), center.dy + 12), stroke);
    }
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: 26, height: 32), const Radius.circular(8)), red);
    canvas.drawRRect(RRect.fromCenter(center: Offset(center.dx, center.dy - 8), width: 18, height: 6), cyan);
    final tail = Path();
    tail.moveTo(center.dx, center.dy + 16);
    tail.quadraticBezierTo(center.dx + 20, center.dy + 14, center.dx + 16, center.dy - 16);
    tail.quadraticBezierTo(center.dx + 10, center.dy - 24, center.dx - 2, center.dy - 22);
    canvas.drawPath(tail, stroke);
    canvas.drawCircle(Offset(center.dx - 2, center.dy - 22), 4, cyan);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- MOTOR DE CONSEJOS TÁCTICOS ---
class TacticalEngine {
  static String getAdvice(String text) {
    final q = text.toLowerCase();
    if (q.contains("persigu") || q.contains("detras")) {
      return "TÁCTICA: Rompe línea de visión. Lanza granada/humo defensivo y busca altura de inmediato.";
    } else if (q.contains("atac") || q.contains("rush")) {
      return "TÁCTICA: Asegura tener vida llena. Entra pegado a la pared y vacía el arma solo con cobertura cerca.";
    } else if (q.contains("perdid") || q.contains("mapa")) {
      return "TÁCTICA: Mira el minimapa. Bordea la zona segura por los filos para no recibir disparos por la espalda.";
    } else if (q.contains("escap") || q.contains("morir")) {
      return "TÁCTICA: Deslízate, usa zigzag entre coberturas duras y aplícate botiquín/blindaje rápido.";
    }
    return "TÁCTICA GENERAL: Mantén la mira a la altura del pecho/cabeza y recarga siempre a cubierto.";
  }
}

// --- BURBUJA FLOTANTE SOBRE LOS JUEGOS ---
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: OverlayWidget()));
}

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});
  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  bool _expanded = false;
  final _controller = TextEditingController();
  String _response = "";
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("es-ES");
  }

  void _toggle() async {
    if (_expanded) {
      await FlutterOverlayWindow.resizeOverlay(120, 120, false);
      setState(() => _expanded = false);
    } else {
      await FlutterOverlayWindow.resizeOverlay(320, 440, false);
      setState(() => _expanded = true);
    }
  }

  void _ask(String t) {
    final res = TacticalEngine.getAdvice(t);
    setState(() => _response = res);
    _tts.speak(res);
  }

  @override
  Widget build(BuildContext context) {
    if (!_expanded) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(onTap: _toggle, child: const FitzAvatar(size: 64)),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.background.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryNeonRed, width: 2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const FitzAvatar(size: 30),
                const SizedBox(width: 8),
                const Text("FITZ TÁCTICO", style: TextStyle(color: AppTheme.primaryNeonRed, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close, size: 20), onPressed: _toggle),
              ],
            ),
            Wrap(
              spacing: 4,
              children: [
                ActionChip(label: const Text("Escapar"), onPressed: () => _ask("necesito escapar")),
                ActionChip(label: const Text("Atacar"), onPressed: () => _ask("debo atacar")),
                ActionChip(label: const Text("Posición"), onPressed: () => _ask("estoy perdido")),
              ],
            ),
            TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(hintText: "¿Situación de juego?", isDense: true),
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () => _ask(_controller.text),
              child: const Text("PEDIR CONSEJO", style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response.isEmpty ? "Elige una opción arriba." : _response, style: const TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- APLICACIÓN PRINCIPAL ---
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: WelcomeScreen()));
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FitzAvatar(size: 120),
                const SizedBox(height: 20),
                const Text("FITZGAME", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryNeonRed)),
                const Text("Tu asistente táctico", style: TextStyle(color: AppTheme.secondaryCyan)),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgeScreen())),
                    child: const Text("COMENZAR"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});
  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  DateTime? _date;
  bool _terms = false;

  void _verify() {
    if (_date == null || !_terms) return;
    int age = DateTime.now().year - _date!.year;
    if (age >= 13) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PermsScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debes tener 13 años o más.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme,
      child: Scaffold(
        appBar: AppBar(title: const Text("Verificación de Edad")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ListTile(
                tileColor: AppTheme.cardColor,
                title: Text(_date == null ? "Toca para elegir tu fecha de nacimiento" : "${_date!.day}/${_date!.month}/${_date!.year}"),
                trailing: const Icon(Icons.calendar_today, color: AppTheme.secondaryCyan),
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: DateTime(2008), firstDate: DateTime(1950), lastDate: DateTime.now());
                  if (d != null) setState(() => _date = d);
                },
              ),
              CheckboxListTile(
                value: _terms,
                title: const Text("Acepto términos y privacidad"),
                onChanged: (v) => setState(() => _terms = v ?? false),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _verify, child: const Text("CONTINUAR")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PermsScreen extends StatefulWidget {
  const PermsScreen({super.key});
  @override
  State<PermsScreen> createState() => _PermsScreenState();
}

class _PermsScreenState extends State<PermsScreen> {
  bool _overlay = false;
  bool _mic = false;

  void _check() async {
    final o = await FlutterOverlayWindow.isPermissionGranted();
    final m = await Permission.microphone.isGranted;
    setState(() { _overlay = o; _mic = m; });
    if (o && m) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme,
      child: Scaffold(
        appBar: AppBar(title: const Text("Permisos")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async { await FlutterOverlayWindow.requestPermission(); _check(); },
                child: Text(_overlay ? "Superposición: Concedido" : "Permitir Superposición"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async { await Permission.microphone.request(); _check(); },
                child: Text(_mic ? "Micrófono: Concedido" : "Permitir Micrófono"),
              ),
              const Spacer(),
              ElevatedButton(onPressed: _check, child: const Text("ENTRAR A FITZGAME")),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme,
      child: Scaffold(
        appBar: AppBar(title: const Text("FitzGame")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FitzAvatar(size: 100),
              const SizedBox(height: 20),
              const Text("Fitz está listo", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (await FlutterOverlayWindow.isActive()) {
                    await FlutterOverlayWindow.closeOverlay();
                  } else {
                    await FlutterOverlayWindow.showOverlay(height: 120, width: 120);
                  }
                },
                child: const Text("ACTIVAR / DESACTIVAR FITZ"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
