import 'dart:async';

import 'package:flutter/material.dart';

import '../data/cefr_lessons.dart';
import '../l10n/app_localizations.dart';
import '../services/learning_store.dart';
import '../theme.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = LearningStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LearningPathHero(completed: store.completedLessons.length),
            const SizedBox(height: 26),
            LText(
              'Darajangizni tanlang',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            LText(
              'A1 dan C2 gacha: qoida, tarjimali misollar va qisqa testlar.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900
                    ? 3
                    : constraints.maxWidth >= 560
                    ? 2
                    : 1;
                final itemWidth =
                    (constraints.maxWidth - (columns - 1) * 12) / columns;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final level in cefrLevels)
                      SizedBox(
                        width: itemWidth,
                        child: _LevelCard(level: level),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            LText(
              'CEFR daraja belgilari o‘quv yo‘li uchun taxminiy tasnifdir; grammatika mavzularining yagona rasmiy CEFR ro‘yxati emas.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningPathHero extends StatelessWidget {
  const _LearningPathHero({required this.completed});
  final int completed;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(
        colors: [Color(0xFF0C1B35), Color(0xFF174A91), Color(0xFF196B9B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: brandBlue.withValues(alpha: .18),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LText(
                'A1  →  C2',
                style: TextStyle(
                  color: Color(0xFFBBD5FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              LText(
                'Qadam-baqadam ravonlik sari',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(color: Colors.white, fontSize: 23),
              ),
              const SizedBox(height: 7),
              LText(
                'Har bir darsda qoida, real misol va bilimni tekshiruvchi mashq bor.',
                style: const TextStyle(color: Color(0xFFD8E6FF), height: 1.45),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF8FDEFF),
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: LText(
                      '$completed / ${cefrLessons.length} ta dars yakunlandi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .12),
            border: Border.all(color: Colors.white.withValues(alpha: .22)),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 29,
            color: Color(0xFFBBD5FF),
          ),
        ),
      ],
    ),
  );
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level});
  final CefrLevelInfo level;

  @override
  Widget build(BuildContext context) {
    final store = LearningStore.instance;
    final lessons = cefrLessons.where((lesson) => lesson.level == level.code);
    final total = lessons.length;
    final completed = lessons
        .where((lesson) => store.completedLessons.contains(lesson.id))
        .length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CefrLevelScreen(levelCode: level.code),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: level.color.withValues(alpha: .16),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      level.code,
                      style: TextStyle(
                        color: level.color,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                  const Spacer(),
                  LText(
                    '$completed / $total ta dars',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: mutedFor(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              LText(
                level.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              LText(
                level.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,
                  color: level.color,
                  backgroundColor: surfaceRaisedFor(context),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  LText(
                    completed == total && total > 0
                        ? 'Daraja yakunlandi'
                        : 'Darslarni ko‘rish',
                    style: TextStyle(
                      color: level.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: level.color,
                    size: 19,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CefrLevelScreen extends StatelessWidget {
  const CefrLevelScreen({super.key, required this.levelCode});
  final String levelCode;

  @override
  Widget build(BuildContext context) {
    final level = cefrLevels.firstWhere((item) => item.code == levelCode);
    final lessons = cefrLessons
        .where((lesson) => lesson.level == levelCode)
        .toList(growable: false);
    final store = LearningStore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              level.code,
              style: TextStyle(color: level.color, fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 10),
            Expanded(child: LText(level.title)),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final currentCompleted = lessons
              .where((lesson) => store.completedLessons.contains(lesson.id))
              .length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceFor(context),
                  borderRadius: BorderRadius.circular(23),
                  border: Border.all(color: level.color.withValues(alpha: .35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LText(
                      level.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: lessons.isEmpty
                                  ? 0
                                  : currentCompleted / lessons.length,
                              minHeight: 8,
                              color: level.color,
                              backgroundColor: surfaceRaisedFor(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        LText(
                          '$currentCompleted / ${lessons.length}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              LText(
                'Darslar va amaliyot',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              for (final lesson in lessons) ...[
                _LessonCard(lesson: lesson, color: level.color),
                const SizedBox(height: 11),
              ],
              LText(
                'Dars yakunlangach, natija va test javobi ushbu qurilmada saqlanadi.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson, required this.color});
  final CefrLesson lesson;
  final Color color;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: LearningStore.instance,
    builder: (context, _) {
      final done = LearningStore.instance.completedLessons.contains(lesson.id);
      return Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => showDialog<void>(
            context: context,
            builder: (_) => _LessonDialog(lesson: lesson, color: color),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.auto_stories_rounded, color: color),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LText(
                        lesson.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 3),
                      LText(
                        lesson.subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  done
                      ? Icons.check_circle_rounded
                      : Icons.chevron_right_rounded,
                  color: done ? const Color(0xFF48C39B) : color,
                  size: 23,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _LessonDialog extends StatefulWidget {
  const _LessonDialog({required this.lesson, required this.color});
  final CefrLesson lesson;
  final Color color;

  @override
  State<_LessonDialog> createState() => _LessonDialogState();
}

class _LessonDialogState extends State<_LessonDialog> {
  String? _choice;
  late bool _done;

  @override
  void initState() {
    super.initState();
    _done = LearningStore.instance.completedLessons.contains(widget.lesson.id);
  }

  void _answer(String option) {
    if (_choice != null) return;
    setState(() => _choice = option);
    unawaited(
      LearningStore.instance.recordQuiz(
        correct: option == widget.lesson.answer,
      ),
    );
  }

  Future<void> _complete() async {
    await LearningStore.instance.markLessonComplete(widget.lesson.id);
    await LearningStore.instance.recordSession(minutes: 5);
    if (mounted) setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final answered = _choice != null;
    final correct = _choice == lesson.answer;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      scrollable: true,
      icon: Icon(Icons.auto_stories_rounded, color: widget.color, size: 29),
      title: Column(
        children: [
          Text(
            lesson.level,
            style: TextStyle(
              color: widget.color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 5),
          Text(lesson.title, textAlign: TextAlign.center),
        ],
      ),
      content: SizedBox(
        width: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            LText(lesson.explanation, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: mintFor(context),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: widget.color.withValues(alpha: .22)),
              ),
              child: LText(
                lesson.pattern,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: dark ? const Color(0xFFD7E6FF) : brandNavy,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 15),
            LText(
              'Misollar va tarjima',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            for (final example in lesson.examples)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: widget.color,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            example.english,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            example.uzbek,
                            style: TextStyle(
                              color: mutedFor(context),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(height: 24),
            LText(
              'Bilimingizni tekshiring',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              lesson.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 9),
            for (final option in lesson.options)
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: answered ? null : () => _answer(option),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: answered && option == lesson.answer
                          ? (dark
                                ? const Color(0xFF153B3B)
                                : const Color(0xFFE4F6EC))
                          : answered && option == _choice
                          ? (dark
                                ? const Color(0xFF492B3A)
                                : const Color(0xFFFFE9ED))
                          : null,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(option),
                    ),
                  ),
                ),
              ),
            if (answered)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: correct
                      ? (dark
                            ? const Color(0xFF153B3B)
                            : const Color(0xFFE4F6EC))
                      : (dark
                            ? const Color(0xFF492B3A)
                            : const Color(0xFFFFE9ED)),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: LText(
                  correct
                      ? 'To‘g‘ri! Ajoyib.'
                      : 'To‘g‘ri javob: ${lesson.answer}',
                  style: TextStyle(
                    color: correct
                        ? (dark
                              ? const Color(0xFF86E0C0)
                              : const Color(0xFF166949))
                        : (dark
                              ? const Color(0xFFFFA9B7)
                              : const Color(0xFF9B354D)),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const LText('Yopish'),
        ),
        if (answered && !_done)
          FilledButton.icon(
            onPressed: _complete,
            icon: const Icon(Icons.check_rounded),
            label: const LText('Darsni tugatdim'),
          ),
        if (_done)
          Padding(
            padding: const EdgeInsets.all(10),
            child: LText(
              'Saqlandi ✓',
              style: TextStyle(
                color: widget.color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}
