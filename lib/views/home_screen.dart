import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/geocoding_service.dart';
import '../theme/app_theme.dart';
import '../utils/weather_helper.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/view_status.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/forecast_card.dart';
import '../widgets/hourly_strip.dart';
import '../widgets/state_message.dart';
import '../widgets/stats_card.dart';
import '../widgets/weather_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => SearchViewModel(GeocodingService()),
          child: const SearchScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherViewModel>();
    final isSuccess = vm.status == ViewStatus.success && vm.weather != null;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B7FEA), Color(0xFF7FA0F8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: _TopCard(
                  vm: vm,
                  showDetail: isSuccess,
                  onSearch: () => _openSearch(context),
                ),
              ),
              Expanded(child: _buildBody(context, vm)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    switch (vm.status) {
      case ViewStatus.initial:
      case ViewStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      case ViewStatus.error:
        return StateMessage(
          icon: Icons.cloud_off_rounded,
          title: 'Gagal memuat cuaca',
          message: vm.errorMessage,
          color: Colors.white,
          actionLabel: 'Coba Lagi',
          onAction: () => vm.loadWeather(),
        );
      case ViewStatus.empty:
        return StateMessage(
          icon: Icons.inbox_rounded,
          title: 'Data kosong',
          message: 'Belum ada data cuaca untuk kota ini.',
          color: Colors.white,
          actionLabel: 'Muat Ulang',
          onAction: () => vm.loadWeather(),
        );
      case ViewStatus.success:
        final weather = vm.weather!;
        return Column(
          children: [
            if (weather.hourly.isNotEmpty) HourlyStrip(hours: weather.hourly),
            Expanded(
              child: ForecastList(
                days: weather.daily,
                onRefresh: () => vm.loadWeather(showLoading: false),
              ),
            ),
          ],
        );
    }
  }
}

class _TopCard extends StatelessWidget {
  const _TopCard({
    required this.vm,
    required this.showDetail,
    required this.onSearch,
  });

  final WeatherViewModel vm;
  final bool showDetail;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.deep, Color(0xFF2F46C9)],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vm.location.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (vm.location.subtitle.isNotEmpty)
                      Text(
                        vm.location.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    Text(
                      WeatherHelper.fullDate(DateTime.now()),
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _SquareButton(
                icon: vm.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: vm.isFavorite ? const Color(0xFFFF6B81) : Colors.white,
                onTap: () => vm.toggleFavorite(vm.location),
              ),
              const SizedBox(width: 8),
              _SquareButton(
                icon: Icons.search_rounded,
                color: Colors.white,
                onTap: onSearch,
              ),
            ],
          ),
          if (showDetail) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: WeatherCard(
                current: vm.weather!.current,
                today: vm.weather!.daily.first,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: StatsCard(
                current: vm.weather!.current,
                today: vm.weather!.daily.first,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x1FFFFFFF),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}