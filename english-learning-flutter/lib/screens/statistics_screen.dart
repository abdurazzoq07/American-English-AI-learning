import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

import '../theme.dart';
import '../services/learning_store.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: LearningStore.instance,
    builder: (context, _) {
      final store = LearningStore.instance;
      return Scaffold(
        appBar: AppBar(title: const LText('O‘rganish statistikasi')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B716B), Color(0xFF16434B)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LText(
                          'SIZNING O‘SISHINGIZ',
                          style: TextStyle(
                            color: Color(0xFFD1E7E0),
                            letterSpacing: 1,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 9),
                        LText(
                          '${store.studyMinutes} daqiqa',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white, fontSize: 32),
                        ),
                        const SizedBox(height: 3),
                        LText(
                          '${store.activeDays} faol kun · ${store.completedSessions} yakunlangan mashq',
                          style: const TextStyle(color: Color(0xFFD1E7E0)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth > 600 ? 3 : 2;
                      final width =
                          (constraints.maxWidth - (columns - 1) * 11) / columns;
                      return Wrap(
                        spacing: 11,
                        runSpacing: 11,
                        children: [
                          SizedBox(
                            width: width,
                            child: _StatCard(
                              icon: Icons.menu_book_rounded,
                              value: '${store.learnedWords.length}',
                              label: 'O‘rganilgan so‘z',
                              color: deepTeal,
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: _StatCard(
                              icon: Icons.favorite_rounded,
                              value: '${store.favoriteWords.length}',
                              label: 'Sevimli so‘zlar',
                              color: const Color(0xFFD15F61),
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: _StatCard(
                              icon: Icons.auto_stories_rounded,
                              value: '${store.completedLessons.length}',
                              label: 'Yakunlangan dars',
                              color: const Color(0xFF7D67D8),
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: _StatCard(
                              icon: Icons.record_voice_over_rounded,
                              value: '${store.pronunciationAttempts}',
                              label: 'Talaffuz urinishi',
                              color: const Color(0xFFE2834D),
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: _StatCard(
                              icon: Icons.check_circle_outline_rounded,
                              value:
                                  '${(store.pronunciationAccuracy * 100).round()}%',
                              label: 'Nutqni tanish mosligi',
                              color: const Color(0xFF4E83B5),
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: _StatCard(
                              icon: Icons.quiz_outlined,
                              value: '${(store.quizAccuracy * 100).round()}%',
                              label: 'Test aniqligi',
                              color: const Color(0xFF3E8A69),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LText(
                            'Kichik marralar',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 14),
                          _ProgressRow(
                            label: 'Birinchi 10 ta so‘z',
                            value: (store.learnedWords.length / 10)
                                .clamp(0, 1)
                                .toDouble(),
                            display: '${store.learnedWords.length} / 10',
                          ),
                          const SizedBox(height: 15),
                          _ProgressRow(
                            label: 'Jami 10 daqiqa (taxminiy)',
                            value: (store.studyMinutes / 10)
                                .clamp(0, 1)
                                .toDouble(),
                            display: '${store.studyMinutes} daqiqa jami',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  LText(
                    'Natijalar ushbu qurilmada saqlanadi. Ilovani qayta o‘rnatsangiz ayrim platformalarda lokal ma’lumotlar o‘chib ketishi mumkin.',
                    style: TextStyle(
                      fontSize: 12,
                      color: mutedFor(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value, label;
  final Color color;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 11),
          LText(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: inkFor(context),
            ),
          ),
          const SizedBox(height: 2),
          LText(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.display,
  });
  final String label, display;
  final double value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(child: LText(label)),
          LText(display, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
      const SizedBox(height: 8),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor: surfaceRaisedFor(context),
          color: deepTeal,
        ),
      ),
    ],
  );
}
