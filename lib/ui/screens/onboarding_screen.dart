import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _selectedExperience;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Добро пожаловать!",
      "description": "Проверьте свои знания Flutter и Dart в современном интерактивном приложении.",
      "icon": Icons.rocket_launch_rounded,
      "color": const Color(0xFF6366F1), // Indigo
    },
    {
      "title": "Умные вопросы",
      "description": "Наши вопросы направлены на глубокое понимание фреймворка, а не на простую зубрёжку.",
      "icon": Icons.psychology_rounded,
      "color": const Color(0xFF14B8A6), // Teal
    },
    {
      "title": "Современный дизайн",
      "description": "Строгая MVVM архитектура, управление состояниями Provider и стильный Glassmorphism UI.",
      "icon": Icons.architecture_rounded,
      "color": const Color(0xFFEC4899), // Pink
    },
    {
      "title": "Твой опыт",
      "description": "Как хорошо ты знаком с Flutter?",
      "icon": Icons.code_rounded,
      "color": const Color(0xFFF59E0B), // Amber
      "isInteractive": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    if (data["isInteractive"] == true) {
                      return OnboardingInteractiveContent(
                        title: data["title"],
                        description: data["description"],
                        icon: data["icon"],
                        color: data["color"],
                        selectedExperience: _selectedExperience,
                        onExperienceSelected: (value) {
                          setState(() {
                            _selectedExperience = value;
                          });
                        },
                      );
                    }
                    return OnboardingContent(
                      title: data["title"],
                      description: data["description"],
                      icon: data["icon"],
                      color: data["color"],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Индикатор страниц
                    Row(
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? onboardingData[_currentPage]["color"]
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    // Кнопка Далее/Начать
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 56,
                      width: _currentPage == onboardingData.length - 1 ? 160 : 64,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == onboardingData.length - 1) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: onboardingData[_currentPage]["color"],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 8,
                          shadowColor: onboardingData[_currentPage]["color"].withOpacity(0.5),
                        ),
                        child: _currentPage == onboardingData.length - 1
                            ? const Text(
                                'Начать!',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : const Icon(Icons.arrow_forward_rounded, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingContent({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 60,
                  spreadRadius: -10,
                ),
              ],
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 100,
              color: color,
            ),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingInteractiveContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? selectedExperience;
  final Function(String) onExperienceSelected;

  const OnboardingInteractiveContent({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.selectedExperience,
    required this.onExperienceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = [
      {"label": "Только начинаю", "icon": Icons.school_rounded},
      {"label": "Уже пишу приложения", "icon": Icons.code_rounded},
      {"label": "Сеньор / Профи", "icon": Icons.workspace_premium_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 64,
              color: color,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 40),
          ...options.map((option) {
            final isSelected = selectedExperience == option["label"];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () => onExperienceSelected(option["label"] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: isSelected ? color : Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: -2,
                            )
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option["icon"] as IconData,
                        color: isSelected ? color : Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option["label"] as String,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: color,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
