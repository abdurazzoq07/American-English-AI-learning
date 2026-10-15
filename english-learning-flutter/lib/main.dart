import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/conversation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lessons_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/vocabulary_screen.dart';
import 'services/app_preferences.dart';
import 'services/learning_store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait<void>([
    LearningStore.instance.init(),
    AppPreferences.instance.init(),
  ]);
  runApp(const AmericanEnglishApp());
}

class AmericanEnglishApp extends StatelessWidget {
  const AmericanEnglishApp({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppPreferences.instance,
    builder: (context, _) => MaterialApp(
      title: 'American English',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: AppPreferences.instance.themeMode,
      locale: AppPreferences.instance.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const AdaptiveShell(),
    ),
  );
}

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  int _selectedIndex = 0;

  List<Widget> get _pages => <Widget>[
    HomeScreen(onNavigate: (index) => setState(() => _selectedIndex = index)),
    const ConversationScreen(),
    const VocabularyScreen(),
    const PracticeScreen(),
    const LessonsScreen(),
  ];

  List<NavigationRailDestination> _railDestinations() => const [
    NavigationRailDestination(
      icon: Icon(Icons.grid_view_rounded),
      label: LText('Bugun'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.forum_rounded),
      label: LText('Suhbat'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.menu_book_rounded),
      label: LText('Lug‘at'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.record_voice_over_rounded),
      label: LText('Mashq'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.auto_stories_rounded),
      label: LText('Darslar'),
    ),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 880;
      final title = const [
        'Bugungi reja',
        'Inglizcha suhbat',
        '1000 ta so‘z',
        'Talaffuz va test',
        'Grammatika',
      ][_selectedIndex];
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  'assets/app_icon.png',
                  width: 34,
                  height: 34,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 11),
              LText(wide ? 'American English' : title),
            ],
          ),
          actions: [
            IconButton(
              tooltip: tr(context, 'Sozlamalar'),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const SettingsScreen(),
              ),
              icon: const Icon(Icons.tune_rounded),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Row(
          children: [
            if (wide)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                child: NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: surfaceFor(context),
                  indicatorColor: mintFor(context),
                  destinations: _railDestinations(),
                ),
              ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: IndexedStack(index: _selectedIndex, children: _pages),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: wide
            ? null
            : _GlassNavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) =>
                    setState(() => _selectedIndex = index),
              ),
      );
    },
  );
}

class _GlassNavigationBar extends StatelessWidget {
  const _GlassNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: dark ? .78 : .84),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? [const Color(0xCC172A49), const Color(0xC9081428)]
                    : [
                        Colors.white.withValues(alpha: .88),
                        const Color(0xFFE8F0FF).withValues(alpha: .88),
                      ],
              ),
              border: Border.all(
                color: (dark ? Colors.white : brandBlue).withValues(alpha: .16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? .24 : .08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: NavigationBar(
              height: 72,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.grid_view_rounded),
                  label: tr(context, 'Bugun'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.forum_rounded),
                  label: tr(context, 'Suhbat'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.menu_book_rounded),
                  label: tr(context, 'Lug‘at'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.record_voice_over_rounded),
                  label: tr(context, 'Mashq'),
                ),
                NavigationDestination(
                  icon: const Icon(Icons.auto_stories_rounded),
                  label: tr(context, 'Dars'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
