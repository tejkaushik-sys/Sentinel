import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../data/models/event_model.dart';
import '../../data/models/moment_model.dart';
import '../widgets/sentinel_bottom_nav.dart';
import '../widgets/event_detail_sheet.dart';
import '../widgets/red_alert_dialog.dart';
import '../widgets/moments_sheet.dart';
import '../widgets/ask_sentinel_modal.dart';
import 'home/home_screen.dart';
import 'around/around_screen.dart';
import 'journey/journey_screen.dart';
import 'report/report_screen.dart';
import 'profile/profile_screen.dart';
import 'destination/destination_briefing_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<EventModel> _events = [];
  List<SentinelMomentModel> _moments = [];
  EventModel? _activeRedAlert;
  bool _hasCheckedRedAlert = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadGlobalData();
  }

  void _loadGlobalData() async {
    final events = await apiClient.getEvents();
    final moments = await apiClient.getSentinelMoments();
    final redAlert = await apiClient.getActiveRedAlert();

    if (mounted) {
      setState(() {
        _events = events;
        _moments = moments;
        _activeRedAlert = redAlert;
      });

      // Show Red Alert modal if critical incident detected
      if (!_hasCheckedRedAlert && _activeRedAlert != null && _activeRedAlert!.isRedAlert) {
        _hasCheckedRedAlert = true;
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            _showRedAlertModal(_activeRedAlert!);
          }
        });
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void _showEventDetail(EventModel event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EventDetailSheet(
        event: event,
        onUseAlternateRoute: () {
          _onBottomNavTapped(2); // Jump to Journey tab
        },
      ),
    );
  }

  void _showRedAlertModal(EventModel event) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) => RedAlertDialog(
        event: event,
        onViewDetails: () {
          _showEventDetail(event);
        },
      ),
    );
  }

  void _openAskSentinel([String? query]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AskSentinelModal(initialQuery: query),
    );
  }

  void _openMoments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MomentsSheet(
        moments: _moments,
        onSelectMoment: (m) {
          Navigator.of(ctx).pop();
          if (m.category == 'weather') {
            _openDestinationBriefing("Patia, Bhubaneswar");
          } else if (m.category == 'night_briefing') {
            _onBottomNavTapped(1); // Around Me
          }
        },
      ),
    );
  }

  void _openDestinationBriefing(String destination) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => DestinationBriefingScreen(destinationName: destination),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: [
          HomeScreen(
            onOpenAskSentinel: _openAskSentinel,
            onOpenMoments: _openMoments,
            onOpenEventDetail: _showEventDetail,
            onOpenDestinationBriefing: _openDestinationBriefing,
            onNavigateToAround: () => _onBottomNavTapped(1),
          ),
          AroundScreen(
            onOpenEventDetail: _showEventDetail,
            onOpenAreaSearch: () => _openDestinationBriefing("Patia, Bhubaneswar"),
          ),
          JourneyScreen(
            onOpenEventDetail: _showEventDetail,
            onOpenDestinationBriefing: _openDestinationBriefing,
          ),
          ReportScreen(
            onReportSubmitted: () {
              _loadGlobalData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Report ingested into Sentinel moderation pipeline!"),
                  backgroundColor: AppColors.cyanDark,
                ),
              );
            },
          ),
          ProfileScreen(
            onOpenDestinationBriefing: _openDestinationBriefing,
            onOpenMoments: _openMoments,
          ),
        ],
      ),
      bottomNavigationBar: SentinelBottomNav(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
