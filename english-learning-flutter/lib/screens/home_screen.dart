import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

import '../theme.dart';
import '../services/learning_store.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final store = LearningStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(
              learned: store.learnedWords.length,
              onStart: () => onNavigate(3),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFF4A340),
                    value: '${store.activeDays}',
                    label: 'faol kun',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.bolt_rounded,
                    color: deepTeal,
                    value: '${store.studyMinutes}',
                    label: 'daq. taxmin',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.task_alt_rounded,
                    color: const Color(0xFF7D67D8),
                    value: '${store.learnedWords.length}',
                    label: 'so‘z',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LText(
                  'Bugungi kichik qadam',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const StatisticsScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.insights_rounded, size: 18),
                  label: const LText('Statistika'),
                ),
              ],
            ),
            const SizedBox(height: 13),
            _GoalCard(
              learned: store.learnedWords.length,
              sessionCount: store.completedSessions,
              onVocabulary: () => onNavigate(2),
              onConversation: () => onNavigate(1),
            ),
            const SizedBox(height: 26),
            LText(
              'Qayerdan davom etamiz?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 13),
            LayoutBuilder(
              builder: (context, constraints) {
                final twoColumns = constraints.maxWidth > 650;
                final cards = [
                  _ActionCard(
                    icon: Icons.forum_rounded,
                    color: deepTeal,
                    title: 'AI bilan suhbat',
                    subtitle: 'Fikrni inglizcha ayting',
                    tag: 'GAPIRISH',
                    onTap: () => onNavigate(1),
                  ),
                  _ActionCard(
                    icon: Icons.style_rounded,
                    color: const Color(0xFF7D67D8),
                    title: 'So‘z kartalari',
                    subtitle: '1000 ta asosiy so‘z',
                    tag: 'LUG‘AT',
                    onTap: () => onNavigate(2),
                  ),
                  _ActionCard(
                    icon: Icons.mic_rounded,
                    color: const Color(0xFFE2834D),
                    title: 'Talaffuz',
                    subtitle: 'Tinglang va aytib ko‘ring',
                    tag: 'AMALIYOT',
                    onTap: () => onNavigate(3),
                  ),
                  _ActionCard(
                    icon: Icons.auto_stories_rounded,
                    color: const Color(0xFF4C8DFF),
                    title: 'CEFR o‘quv yo‘li',
                    subtitle: 'A1 dan C2 gacha darslar',
                    tag: 'DARS',
                    onTap: () => onNavigate(4),
                  ),
                ];
                if (!twoColumns) {
                  return Column(
                    children: cards
                        .map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: card,
                          ),
                        )
                        .toList(),
                  );
                }
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: cards
                      .map(
                        (card) => SizedBox(
                          width: (constraints.maxWidth - 12) / 2,
                          child: card,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const _OfflineNote(),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.learned, required this.onStart});
  final int learned;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1630), Color(0xFF174A91), Color(0xFF2369B4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -34,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .07),
              ),
            ),
          ),
          Positioned(
            right: 22,
            top: 27,
            child: Icon(
              Icons.waving_hand_rounded,
              size: 36,
              color: const Color(0xFF9ADFFF),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 610),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const LText(
                    'AMERICAN ENGLISH  •  SPEAKING PATH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                LText(
                  'Ingliz tilida\ndadil gapiring.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 10),
                LText(
                  '$learned ta so‘z o‘rganildi. Har kuni mashq qilib, ishonch bilan gapiring.',
                  style: const TextStyle(
                    color: Color(0xFFD3E8E2),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: (learned / 1000).clamp(0, 1),
                          minHeight: 7,
                          color: const Color(0xFF91DFFF),
                          backgroundColor: Colors.white.withValues(alpha: .16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    LText(
                      '$learned / 1000 ta so‘z',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 19),
                FilledButton.icon(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF9ADFFF),
                    foregroundColor: const Color(0xFF081326),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const LText('Mashqni boshlash'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 9),
          LText(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 21,
              color: inkFor(context),
            ),
          ),
          LText(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: mutedFor(context)),
          ),
        ],
      ),
    ),
  );
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.learned,
    required this.sessionCount,
    required this.onVocabulary,
    required this.onConversation,
  });
  final int learned;
  final int sessionCount;
  final VoidCallback onVocabulary;
  final VoidCallback onConversation;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: mintFor(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.flag_rounded, color: deepTeal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LText(
                      'Maqsad sari qadam',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    LText(
                      '$learned / 10 jami so‘z  ·  ${sessionCount > 0 ? 'mashqlar bajarilgan' : 'birinchi mashqni boshlang'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz_rounded, color: Color(0xFF879398)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: (learned / 10).clamp(0, 1),
              minHeight: 9,
              backgroundColor: surfaceRaisedFor(context),
              color: deepTeal,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onVocabulary,
                  icon: const Icon(Icons.style_rounded, size: 18),
                  label: const LText('5 ta so‘z'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onConversation,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: const LText('Suhbat'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String tag;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LText(
                    tag,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LText(title, style: Theme.of(context).textTheme.titleMedium),
                  LText(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF95A2A4),
            ),
          ],
        ),
      ),
    ),
  );
}

class _OfflineNote extends StatelessWidget {
  const _OfflineNote();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: mintFor(context),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.offline_bolt_rounded, color: deepTeal),
        SizedBox(width: 11),
        Expanded(
          child: LText(
            'Lug‘at, grammatika va natijalar qurilmangizda saqlanadi. AI suhbat uchun o‘zingizning API kalitingizni sozlamalarda kiriting.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              height: 1.45,
            ),
          ),
        ),
      ],
    ),
  );
}
