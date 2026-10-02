import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/verify_model.dart';
import '../../widgets/glass_container.dart';

class MySearchesScreen extends StatefulWidget {
  final Function(String) onSelectSearch;

  const MySearchesScreen({super.key, required this.onSelectSearch});

  @override
  State<MySearchesScreen> createState() => _MySearchesScreenState();
}

class _MySearchesScreenState extends State<MySearchesScreen> {
  final TextEditingController _filterController = TextEditingController();
  List<SearchHistoryModel> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await apiClient.getSearchHistory();
    if (mounted) {
      setState(() {
        _history = history;
        _isLoading = false;
      });
    }
  }

  void _clearHistory() async {
    await apiClient.clearSearchHistory();
    setState(() {
      _history.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Search history cleared"), backgroundColor: AppColors.surfaceElevated),
      );
    }
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Text("My Searches", style: AppTypography.headlineLarge),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _filterController,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: "Search History...",
                          hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search History List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
                    : _history.isEmpty
                        ? Center(
                            child: Text("No search history records found.", style: AppTypography.bodyMedium),
                          )
                        : ListView.builder(
                            itemCount: _history.length,
                            itemBuilder: (context, index) {
                              final item = _history[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GlassContainer(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    widget.onSelectSearch(item.query);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.surfaceHighlight,
                                        ),
                                        child: Icon(_getIcon(item.iconType), color: AppColors.cyan, size: 20),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.query,
                                              style: AppTypography.titleMedium.copyWith(fontSize: 15),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              item.timeAgo,
                                              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 22),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),

              // Clear History Button
              if (_history.isNotEmpty)
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _clearHistory,
                        child: Center(
                          child: Text(
                            "Clear History",
                            style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconType) {
    switch (iconType) {
      case 'person':
        return Icons.person_rounded;
      case 'building':
        return Icons.apartment_rounded;
      case 'location':
        return Icons.location_on_outlined;
      case 'organization':
        return Icons.business_center_rounded;
      default:
        return Icons.history_rounded;
    }
  }
}
