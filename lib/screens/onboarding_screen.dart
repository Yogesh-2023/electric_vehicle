part of '../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double _progress = 0.0;

  void _onDragUpdate(
    DragUpdateDetails details,
    double maxWidth,
    double knobSize,
  ) {
    final track = maxWidth - knobSize;
    setState(() {
      _progress = (_progress + details.delta.dx / track).clamp(0.0, 1.0);
    });
  }

  void _onDragEnd() {
    if (_progress >= 0.85) {
      setState(() => _progress = 1);
      Future.delayed(const Duration(milliseconds: 220), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    } else {
      setState(() => _progress = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = Responsive.isCompact(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F7FB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 16 : 24),
          child: Column(
            children: [
              Image.asset(
                'assets/images/new-ev-care-logo.png',
                width: isCompact ? 250 : 300,
                height: isCompact ? 118 : 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 2),
              Text(
                'Powered by EV Care Platform',
                style: TextStyle(
                  fontSize: isCompact ? 12 : 14,
                  color: const Color(0xFF2B3A4A).withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: isCompact ? 22 : 30),
              const Text(
                'Create EV service jobs with ease. Let technicians inspect, track, and complete every vehicle confidently.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: Color(0xFF2B3A4A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final imageWidth = math.min(
                      width * (isCompact ? 1.05 : 0.82),
                      constraints.maxHeight * 1.05,
                    );

                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          bottom: 8,
                          child: Container(
                            width: imageWidth * 0.58,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0x1F033D83),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                        Center(
                          child: Transform.translate(
                            offset: Offset(42 * _progress, 0),
                            child: Transform.scale(
                              scale: 1 - (0.12 * _progress),
                              alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                'assets/images/new-ev-scooter.png',
                                width: imageWidth,
                                height: constraints.maxHeight,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              _DragToStart(
                progress: _progress,
                onUpdate: _onDragUpdate,
                onEnd: _onDragEnd,
              ),
              SizedBox(height: isCompact ? 22 : 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragToStart extends StatelessWidget {
  const _DragToStart({
    required this.progress,
    required this.onUpdate,
    required this.onEnd,
  });

  final double progress;
  final void Function(
    DragUpdateDetails details,
    double maxWidth,
    double knobSize,
  )
  onUpdate;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    const knobSize = 56.0;
    const height = 64.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final knobLeft = (maxWidth - knobSize) * progress;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(height),
            boxShadow: const [
              BoxShadow(color: Color(0x1F000000), offset: Offset(0, 6)),
            ],
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              const Center(
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                right: 4,
                child: Container(
                  width: knobSize,
                  height: knobSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDEDED),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: AppColors.green),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 120),
                left: knobLeft,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      onUpdate(details, maxWidth, knobSize),
                  onHorizontalDragEnd: (_) => onEnd(),
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.two_wheeler, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
