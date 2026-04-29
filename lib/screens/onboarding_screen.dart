import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/task_provider.dart';
import 'login_screen.dart';
import 'tasks_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _startLocalMode(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('storage_mode', 'local');
    if (!context.mounted) return;
    Provider.of<TaskProvider>(context, listen: false).setLocalMode();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TasksScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/taskssphere_only_logo.png',
                height: 80,
              ),
              const SizedBox(height: 16),
              Text(
                'TasksSphere',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Wie möchtest du starten?',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 48),

              // Cloud option
              SizedBox(
                width: double.infinity,
                child: _OptionCard(
                  icon: Icons.cloud_outlined,
                  title: 'Mit Account anmelden',
                  subtitle: 'Synchronisiere deine Aufgaben über alle Geräte.',
                  filled: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Local option
              SizedBox(
                width: double.infinity,
                child: _OptionCard(
                  icon: Icons.phone_android_outlined,
                  title: 'Lokal nutzen',
                  subtitle: 'Deine Daten bleiben nur auf diesem Gerät.',
                  filled: false,
                  onTap: () => _startLocalMode(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: filled ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: filled ? primaryColor : Theme.of(context).dividerColor.withValues(alpha: 0.3),
            width: filled ? 0 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: filled ? Colors.white : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: filled ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: filled ? Colors.white.withValues(alpha: 0.8) : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: filled ? Colors.white.withValues(alpha: 0.8) : Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }
}
