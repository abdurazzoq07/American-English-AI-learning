import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../l10n/app_localizations.dart';
import '../services/ai_service.dart';
import '../services/learning_store.dart';
import '../theme.dart';
import 'settings_screen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatLine> _messages = <ChatLine>[];
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  AiSettings? _settings;
  bool _sending = false;
  bool _speechReady = false;
  bool _listening = false;
  bool _speaking = false;
  String _level = 'A2';

  static const _prompts = [
    'Tell me about your day.',
    'What food do you like?',
    'Describe a place you want to visit.',
  ];

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    AiService.instance
        .loadSettings()
        .then((settings) {
          if (mounted) setState(() => _settings = settings);
        })
        .catchError((Object _) {});
  }

  @override
  void dispose() {
    unawaited(_speech.stop());
    unawaited(_tts.stop());
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshSettings() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const SettingsScreen(),
    );
    if (!mounted) return;
    final settings = await AiService.instance.loadSettings();
    if (mounted) setState(() => _settings = settings);
  }

  Future<void> _toggleVoiceInput() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    if (_sending) return;

    if (!_speechReady) {
      try {
        _speechReady = await _speech.initialize(
          onStatus: (status) {
            if (mounted) setState(() => _listening = status == 'listening');
          },
          onError: (_) {
            if (mounted) setState(() => _listening = false);
          },
        );
      } catch (_) {
        _speechReady = false;
      }
    }
    if (!_speechReady) {
      _showVoiceUnavailable();
      return;
    }

    if (mounted) setState(() => _listening = true);
    try {
      await _speech.listen(
        onResult: (result) {
          final recognized = result.recognizedWords.trim();
          if (!mounted || recognized.isEmpty) return;
          _controller.value = TextEditingValue(
            text: recognized,
            selection: TextSelection.collapsed(offset: recognized.length),
          );
          setState(() {});
          if (result.finalResult) {
            unawaited(_speech.stop());
            setState(() => _listening = false);
            unawaited(_send(recognized));
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: 'en_US',
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _listening = false);
      _showVoiceUnavailable();
    }
  }

  void _showVoiceUnavailable() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: LText(
          'Mikrofon yoki English (US) nutq xizmati mavjud emas. Ruxsat va qurilma sozlamalarini tekshiring.',
        ),
      ),
    );
  }

  Future<void> _speakReply(String text) async {
    try {
      if (_speaking) {
        await _tts.stop();
        if (mounted) setState(() => _speaking = false);
        return;
      }
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(.44);
      if (mounted) setState(() => _speaking = true);
      await _tts.speak(text);
    } catch (_) {
      if (!mounted) return;
      setState(() => _speaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: LText('Qurilmada inglizcha ovoz xizmati mavjud emas.'),
        ),
      );
    }
  }

  Future<void> _send([String? supplied]) async {
    final text = (supplied ?? _controller.text).trim();
    if (text.isEmpty || _sending) return;
    if (_listening) {
      unawaited(_speech.stop());
      _listening = false;
    }
    _controller.clear();
    setState(() {
      _messages.add(ChatLine(text: text, isUser: true));
      _sending = true;
    });
    _jumpToBottom();
    try {
      final settings = _settings ?? await AiService.instance.loadSettings();
      final reply = await AiService.instance.reply(
        settings: settings,
        history: _messages,
        level: _level,
      );
      if (!mounted) return;
      setState(() => _messages.add(ChatLine(text: reply, isUser: false)));
      await LearningStore.instance.recordSession(minutes: 5);
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _messages.add(
          ChatLine(
            text:
                'Ulanishda muammo: $error\n\nAPI manzili, model, kalit va internet aloqasini tekshirib ko‘ring.',
            isUser: false,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _jumpToBottom();
      }
    }
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final configured = _settings?.apiKey.isNotEmpty == true;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: configured
                        ? mintFor(context)
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant
                          .withValues(alpha: .6),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        configured
                            ? Icons.key_rounded
                            : Icons.info_outline_rounded,
                        color: configured ? deepTeal : mutedFor(context),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: LText(
                          configured
                              ? 'AI API kaliti sozlandi'
                              : 'AI suhbat uchun provayder kalitini sozlang',
                          style: TextStyle(
                            color: configured
                                ? Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer
                                : mutedFor(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _level,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(14),
                items: const ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: LText(level)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _level = value ?? _level),
              ),
            ],
          ),
        ),
        Expanded(
          child: _messages.isEmpty
              ? _EmptyConversation(
                  prompts: _prompts,
                  onPrompt: (prompt) => _send(prompt),
                  onSettings: _refreshSettings,
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                  itemCount: _messages.length + (_sending ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_sending && index == _messages.length) {
                      return const _TypingBubble();
                    }
                    final line = _messages[index];
                    return _MessageBubble(
                      line: line,
                      speaking: _speaking,
                      onSpeak: line.isUser
                          ? null
                          : () => _speakReply(line.text),
                    );
                  },
                ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: tr(context, 'Inglizcha javobingizni yozing…'),
                      prefixIcon: Icon(
                        _listening
                            ? Icons.graphic_eq_rounded
                            : Icons.edit_note_rounded,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 52,
                  width: 48,
                  child: IconButton.filledTonal(
                    tooltip: tr(
                      context,
                      _listening
                          ? 'Ovozli kiritishni to‘xtatish'
                          : 'Ovozli javobni boshlash',
                    ),
                    onPressed: _sending ? null : _toggleVoiceInput,
                    icon: Icon(
                      _listening ? Icons.stop_rounded : Icons.mic_rounded,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 52,
                  width: 52,
                  child: FilledButton(
                    onPressed: _sending ? null : () => _send(),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.arrow_upward_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation({
    required this.prompts,
    required this.onPrompt,
    required this.onSettings,
  });

  final List<String> prompts;
  final ValueChanged<String> onPrompt;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: mintFor(context),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(Icons.forum_rounded, color: deepTeal, size: 37),
            ),
            const SizedBox(height: 17),
            LText(
              'Keling, gaplashamiz.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 7),
            const LText(
              'Oddiy inglizcha jumladan boshlang. AI javob beradi va foydali tuzatishlarni ko‘rsatadi.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...prompts.map(
              (prompt) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => onPrompt(prompt),
                    icon: const Icon(Icons.north_west_rounded, size: 17),
                    label: LText(prompt, textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextButton.icon(
              onPressed: onSettings,
              icon: const Icon(Icons.tune_rounded),
              label: const LText('AI sozlamalarini ochish'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.line,
    required this.speaking,
    this.onSpeak,
  });

  final ChatLine line;
  final bool speaking;
  final VoidCallback? onSpeak;

  @override
  Widget build(BuildContext context) {
    final user = line.isUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .82,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(15, 12, 9, 7),
        decoration: BoxDecoration(
          color: user ? brandBlue : surfaceFor(context),
          border: user
              ? null
              : Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant
                      .withValues(alpha: .55),
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(19),
            topRight: const Radius.circular(19),
            bottomLeft: Radius.circular(user ? 19 : 5),
            bottomRight: Radius.circular(user ? 5 : 19),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                line.text,
                style: TextStyle(
                  color: user ? Colors.white : inkFor(context),
                  height: 1.48,
                ),
              ),
            ),
            if (onSpeak != null)
              SizedBox(
                height: 30,
                child: IconButton(
                  tooltip: tr(context, 'AI javobini ovoz chiqarib tinglash'),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: onSpeak,
                  icon: Icon(
                    speaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                    size: 18,
                    color: deepTeal,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceFor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          LText('Javob tayyorlanmoqda…'),
        ],
      ),
    ),
  );
}
