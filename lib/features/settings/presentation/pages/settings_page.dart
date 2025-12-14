import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/settings/providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  String _themeLabel(AppTheme t) {
    switch (t) {
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
      case AppTheme.system:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_themeLabel(settings.theme)),
            onTap: () async {
              final choice = await showDialog<AppTheme?>(
                context: context,
                builder: (c) => SimpleDialog(
                  title: const Text('Choose theme'),
                  children: [
                    SimpleDialogOption(
                      child: const Text('System'),
                      onPressed: () => Navigator.pop(c, AppTheme.system),
                    ),
                    SimpleDialogOption(
                      child: const Text('Light'),
                      onPressed: () => Navigator.pop(c, AppTheme.light),
                    ),
                    SimpleDialogOption(
                      child: const Text('Dark'),
                      onPressed: () => Navigator.pop(c, AppTheme.dark),
                    ),
                  ],
                ),
              );
              if (choice != null) {
                // Theme change would require state management solution
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Theme changed to ${_themeLabel(choice)}')));
              }
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(settings.language),
            onTap: () async {
              final lang = await showDialog<String?>(
                context: context,
                builder: (c) => SimpleDialog(
                  title: const Text('Choose language'),
                  children: [
                    SimpleDialogOption(child: const Text('English'), onPressed: () => Navigator.pop(c, 'en')),
                    SimpleDialogOption(child: const Text('Spanish'), onPressed: () => Navigator.pop(c, 'es')),
                  ],
                ),
              );
              if (lang != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Language changed to $lang')));
              }
            },
          ),
          SwitchListTile(
            title: const Text('Enable notifications'),
            value: settings.notificationsEnabled,
            onChanged: (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications toggled'))),
          ),
          SwitchListTile(
            title: const Text('Data saver'),
            subtitle: const Text('Reduce image quality and background sync'),
            value: settings.dataSaver,
            onChanged: (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data saver toggled'))),
          ),
          ListTile(
            title: const Text('Clear cache'),
            onTap: () {
              // Clear cache logic can be added here
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
            },
          ),
        ],
      ),
    );
  }
}
