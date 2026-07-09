import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const Color _teal = Color(0xFF15919B);
const Color _orange = Color(0xFFF7941D);

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Paths match a FLAT "assets/" folder (no "images/" subfolder)
  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/onboarding_1.png',
      title: 'ONLINE PAYMENT',
      subtitle:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra quam elementum massa, viverra. Ut turpis suscipit consectetur.',
    ),
    OnboardingData(
      image: 'assets/onboarding_2.png',
      title: 'ONLINE SHOPPING',
      subtitle:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra quam elementum massa, viverra. Ut turpis suscipit consectetur.',
    ),
    OnboardingData(
      image: 'assets/onboarding_3.png',
      title: 'HOME DELIVER SERVICE',
      subtitle:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra quam elementum massa, viverra. Ut turpis suscipit consectetur.',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _onSkip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _teal,
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) {
          final page = _pages[index];
          return _OnboardingPage(
            data: page,
            isLastPage: index == _pages.length - 1,
            controller: _controller,
            pageCount: _pages.length,
            onNext: _onNext,
            onSkip: _onSkip,
          );
        },
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final bool isLastPage;
  final PageController controller;
  final int pageCount;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _OnboardingPage({
    required this.data,
    required this.isLastPage,
    required this.controller,
    required this.pageCount,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _teal,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Illustration area on teal background
            Expanded(
              flex: 5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Image.asset(
                    data.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // White rounded card overlapping the teal background
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: _orange,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: onSkip,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Skip>>',
                            style: TextStyle(
                              color: _orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SmoothPageIndicator(
                          controller: controller,
                          count: pageCount,
                          effect: const WormEffect(
                            dotColor: Color(0xFFE0E0E0),
                            activeDotColor: _orange,
                            dotHeight: 7,
                            dotWidth: 7,
                          ),
                        ),
                        GestureDetector(
                          onTap: onNext,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: _orange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isLastPage ? Icons.check : Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}