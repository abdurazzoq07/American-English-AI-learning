import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/ai_service.dart';
import '../services/app_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _base = TextEditingController();
  final _model = TextEditingController();
  final _key = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  bool _obscure = true;
  late String _languageCode;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _languageCode = AppPreferences.instance.languageCode;
    _themeMode = AppPreferences.instance.themeMode;
    AiService.instance
        .loadSettings()
        .then((settings) {
          if (!mounted) return;
          _base.text = settings.baseUrl;
          _model.text = settings.model;
          _key.text = settings.apiKey;
          setState(() => _loading = false);
        })
        .catchError((Object _) {
          if (mounted) setState(() => _loading = false);
        });
  }

  @override
  void dispose() {
    _base.dispose();
    _model.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _changeLanguage(String? value) async {
    if (value == null) return;
    setState(() => _languageCode = value);
    await AppPreferences.instance.setLanguageCode(value);
  }

  Future<void> _changeTheme(ThemeMode? value) async {
    if (value == null) return;
    setState(() => _themeMode = value);
    await AppPreferences.instance.setThemeMode(value);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await AiService.instance.saveSettings(
        AiSettings(baseUrl: _base.text, model: _model.text, apiKey: _key.text),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: LText('AI sozlamalari xavfsiz saqlandi.')),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: LText('Saqlab bo‘lmadi: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _languagePicker(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: tr(context, 'Ilova tili')),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _languageCode,
        isExpanded: true,
        borderRadius: BorderRadius.circular(12),
        items: const [
          DropdownMenuItem(value: 'system', child: LText('Tizim tili')),
          DropdownMenuItem(value: 'en', child: LText('English')),
          DropdownMenuItem(value: 'ru', child: LText('Русский')),
          DropdownMenuItem(value: 'uz', child: LText('O‘zbekcha')),
        ],
        onChanged: _changeLanguage,
      ),
    ),
  );

  Widget _themePicker(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: tr(context, 'Mavzu')),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<ThemeMode>(
        value: _themeMode,
        isExpanded: true,
        borderRadius: BorderRadius.circular(12),
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: LText('Tizim bo‘yicha'),
          ),
          DropdownMenuItem(value: ThemeMode.light, child: LText('Yorug‘')),
          DropdownMenuItem(value: ThemeMode.dark, child: LText('Qorong‘i')),
        ],
        onChanged: _changeTheme,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 520;
    return AlertDialog(
      icon: const Icon(Icons.tune_rounded),
      title: const LText('Sozlamalar'),
      content: SizedBox(
        width: compact ? double.maxFinite : 440,
        child: _loading
            ? const SizedBox(
                height: 110,
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _languagePicker(context),
                      const SizedBox(height: 12),
                      _themePicker(context),
                      const SizedBox(height: 18),
                      const Divider(),
                      const SizedBox(height: 10),
                      LText(
                        'AI ulanishi',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      LText(
                        'OpenAI-compatible API',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _base,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: tr(context, 'API manzili'),
                          hintText: 'https://api.openai.com/v1',
                        ),
                        validator: (value) =>
                            value == null ||
                                Uri.tryParse(value.trim())?.hasScheme != true
                            ? tr(context, 'To‘liq URL kiriting')
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _model,
                        decoration: InputDecoration(
                          labelText: tr(context, 'Model nomi'),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? tr(context, 'Model nomini kiriting')
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _key,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: tr(context, 'API kalit'),
                          hintText: tr(
                            context,
                            'Kalit faqat ushbu qurilmada saqlanadi',
                          ),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: LText(
                          'API kaliti Android Keystore yoki Windows himoyalangan saqlash mexanizmida saqlanadi. AI xizmatidan foydalanish provayder hisobingizda to‘lov yoki limit talab qilishi mumkin.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const LText('Bekor'),
        ),
        FilledButton.icon(
          onPressed: _loading || _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save_rounded),
          label: LText(_saving ? 'Saqlanmoqda' : 'Saqlash'),
        ),
      ],
    );
  }
}
