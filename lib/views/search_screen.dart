import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../theme/app_theme.dart';
import '../utils/weather_helper.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/view_status.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/state_message.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const List<String> _popularCities = [
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Yogyakarta',
    'Semarang',
    'Purwokerto',
    'Bali',
    'Medan',
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(LocationModel location) {
    context.read<WeatherViewModel>().selectLocation(location);
    Navigator.of(context).pop();
  }

  void _searchCity(String name) {
    _controller.text = name;
    _controller.selection = TextSelection.collapsed(offset: name.length);
    setState(() {});
    context.read<SearchViewModel>().search(name);
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchViewModel>();
    final weather = context.watch<WeatherViewModel>();

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
              _buildSearchBar(),
              Expanded(child: _buildBody(search, weather)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Material(
            color: const Color(0x1FFFFFFF),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Material(
              color: const Color(0x26FFFFFF),
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                controller: _controller,
                autofocus: true,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {});
                  context.read<SearchViewModel>().onQueryChanged(value);
                },
                onSubmitted: (value) {
                  if (value.trim().length >= 2) {
                    context.read<SearchViewModel>().search(value.trim());
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Cari kota...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.white70),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                            context.read<SearchViewModel>().onQueryChanged('');
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchViewModel search, WeatherViewModel weather) {
    switch (search.status) {
      case ViewStatus.initial:
        return _buildInitial(weather);
      case ViewStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      case ViewStatus.error:
        return StateMessage(
          icon: Icons.cloud_off_rounded,
          title: 'Pencarian gagal',
          message: search.errorMessage,
          color: Colors.white,
          actionLabel: 'Coba Lagi',
          onAction: () => search.search(_controller.text.trim()),
        );
      case ViewStatus.empty:
        return const StateMessage(
          icon: Icons.search_off_rounded,
          title: 'Kota tidak ditemukan',
          message: 'Coba gunakan kata kunci lain.',
          color: Colors.white,
        );
      case ViewStatus.success:
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: search.results.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = search.results[index];
            final isFav = weather.isFavoriteLocation(item);
            return _LocationTile(
              location: item,
              onTap: () => _select(item),
              trailing: IconButton(
                icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav ? const Color(0xFFFF6B81) : Colors.black38,
                ),
                onPressed: () => weather.toggleFavorite(item),
              ),
            );
          },
        );
    }
  }

  Widget _buildInitial(WeatherViewModel weather) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        if (weather.favorites.isNotEmpty) ...[
          const _SectionTitle('Kota Favorit'),
          for (final item in weather.favorites)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _FavoriteCard(
                location: item,
                weather: weather.favoriteWeather[item.id],
                onTap: () => _select(item),
                onRemove: () => weather.toggleFavorite(item),
              ),
            ),
          const SizedBox(height: 12),
        ],
        if (weather.recents.isNotEmpty) ...[
          const _SectionTitle('Terakhir Dicari'),
          for (final item in weather.recents)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LocationTile(
                location: item,
                onTap: () => _select(item),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: Colors.black38,
                  onPressed: () => weather.removeRecent(item),
                ),
              ),
            ),
          const SizedBox(height: 12),
        ],
        const _SectionTitle('Kota Populer'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final city in _popularCities)
              _CityChip(label: city, onTap: () => _searchCity(city)),
          ],
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Ketik minimal 2 huruf untuk mencari kota',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.location,
    required this.onTap,
    required this.trailing,
  });

  final LocationModel location;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0x1A3D5AFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                    if (location.subtitle.isNotEmpty)
                      Text(
                        location.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.location,
    required this.weather,
    required this.onTap,
    required this.onRemove,
  });

  final LocationModel location;
  final WeatherModel? weather;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final w = weather;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.deep, Color(0xFF2F46C9)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 6, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        location.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        w == null
                            ? 'Memuat...'
                            : WeatherHelper.describe(w.current.weatherCode),
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      w == null ? '--°' : '${w.current.temperature.round()}°',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    if (w != null && w.daily.isNotEmpty)
                      Text(
                        'H:${w.daily.first.maxTemp.round()}° '
                        'L:${w.daily.first.minTemp.round()}°',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CityChip extends StatelessWidget {
  const _CityChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}