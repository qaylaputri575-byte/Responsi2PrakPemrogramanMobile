☁️ Weather Forecast — Responsi Flutter

Aplikasi informasi cuaca berbasis Flutter yang mengambil data dari Open-Meteo REST API. Pengguna dapat melihat cuaca terkini, prakiraan per jam, prakiraan 7 hari, mencari kota di seluruh dunia, serta menyimpan kota favorit dan riwayat pencarian secara lokal.

	
Nama	<Qayla Zahra Era Putri>
NIM	H1D024133
Program Studi	Teknik Informatika, Fakultas Teknik, Universitas Jenderal Soedirman
Mata Kuliah	Praktikum Pemrograman Mobile — Responsi Flutter
Video Penjelasan	<[tempel link YouTube](https://youtu.be/sPg6x3nF5a0)>
📸 Screenshot
No	Screen	Screenshot	Keterangan
1	Home / Weather Screen	<img src="screenshots/home.png" width="220" />	Nama kota, kondisi dan suhu saat ini, tertinggi/terendah, kelembapan, angin, peluang hujan, prakiraan per jam dan 7 hari.
2	Search / Location Screen	<img src="screenshots/search.png" width="220" />	Kolom pencarian, Kota Favorit (dengan suhu dari API), Terakhir Dicari, dan Kota Populer.
3	Search — Hasil Pencarian	<img src="screenshots/search_result.png" width="220" />	Daftar kota dari Geocoding API, dilengkapi tombol favorit.
4	Search — Kota Tidak Ditemukan	<img src="screenshots/search_empty.png" width="220" />	Tampilan saat pencarian tidak menghasilkan data.
✨ Fitur

Home / Weather Screen

Nama kota yang sedang dipilih beserta provinsi/negara dan tanggal hari ini.
Kondisi cuaca terkini (ikon + deskripsi bahasa Indonesia) dan suhu saat ini.
Suhu tertinggi dan terendah hari ini.
Informasi tambahan: kelembapan, kecepatan angin, peluang hujan, suhu terasa seperti, dan curah hujan.
Prakiraan per jam (6 jam ke depan).
Prakiraan cuaca 7 hari ke depan, dilengkapi pull-to-refresh.
Tombol favorit (♥) untuk menyimpan/menghapus kota yang sedang dilihat.

Search / Location Screen

Input pencarian kota dengan debounce 500 ms (request hanya dikirim jika minimal 2 huruf).
Daftar hasil pencarian dari Geocoding API (maksimal 10 hasil).
Memilih hasil untuk menampilkan cuaca kota tersebut di Home.
Kota Favorit ditampilkan sebagai kartu yang memuat suhu, kondisi, serta suhu tertinggi/terendah kota tersebut (diambil dari API).
Terakhir Dicari — riwayat 5 kota terakhir yang dipilih.
Kota Populer — pintasan cepat yang tetap melakukan request ke API saat ditekan.

Lain-lain

Kota terakhir yang dipilih otomatis dibuka kembali saat aplikasi dijalankan.
Pesan error yang ramah (tidak ada koneksi, timeout, atau kode status server).
✅ Kesesuaian dengan Ketentuan Responsi
No	Ketentuan	Implementasi	Lokasi
1a	Flutter & Dart; StatefulWidget dan StatelessWidget	Seluruh aplikasi Flutter/Dart. SearchScreen memakai StatefulWidget (mengelola TextEditingController), widget lainnya StatelessWidget.	lib/
1b	Flutter Widgets, Material Design, Theme, Typography, responsif	Material 3 (useMaterial3), ThemeData + ColorScheme.fromSeed, TextTheme kustom, layout fleksibel (Expanded, SafeArea, Wrap, ListView).	lib/theme/, lib/views/, lib/widgets/
1c	Local storage untuk favorit/riwayat, tampil kembali saat aplikasi dibuka	SharedPreferences menyimpan favorit, riwayat pencarian, dan lokasi terakhir; dimuat ulang di init().	lib/services/storage_service.dart
1d	State management, pencarian lokasi, hasil dipakai untuk cuaca	Provider + ChangeNotifier. Hasil pencarian dipilih → selectLocation() → cuaca kota dimuat.	lib/viewmodels/
1e	REST API Open-Meteo, HTTP GET, JSON → model Dart, loading/kosong/error	Package http (GET), jsonDecode → WeatherModel / LocationModel, enum ViewStatus untuk semua kondisi.	lib/services/, lib/models/
1f	Arsitektur MVVM	Pemisahan Model – View – ViewModel (+ Service), lihat Penerapan MVVM.	seluruh lib/
1g	Minimal 2 screen	HomeScreen dan SearchScreen.	lib/views/
1h	Data cuaca dari API (bukan hardcoded); pencarian benar-benar request ke API	Semua data cuaca dan hasil pencarian berasal dari Open-Meteo. Satu-satunya nilai bawaan adalah lokasi awal (Semarang) sebelum pengguna memilih kota.	lib/services/
2	Pengumpulan: GitHub, dokumentasi, screenshot di README, video	Repositori ini, README ini, folder screenshots/, dan link video di bagian atas.	—
🧰 Teknologi & Dependency
Teknologi	Kegunaan
Flutter & Dart	Framework dan bahasa pengembangan aplikasi
Open-Meteo Forecast API	Data cuaca (terkini, per jam, harian)
Open-Meteo Geocoding API	Mengubah nama kota menjadi koordinat
http	HTTP request metode GET
provider	State management (ChangeNotifier)
shared_preferences	Penyimpanan lokal (favorit, riwayat, lokasi terakhir)
🗂️ Struktur Folder
lib/
├── main.dart                      # Entry point + inisialisasi Provider & Theme
├── models/
│   ├── location_model.dart        # Model lokasi (nama, provinsi, negara, koordinat)
│   └── weather_model.dart         # CurrentWeather, DailyForecast, HourlyForecast, WeatherModel
├── services/
│   ├── weather_service.dart       # GET Forecast API
│   ├── geocoding_service.dart     # GET Geocoding API
│   └── storage_service.dart       # SharedPreferences (favorit, riwayat, lokasi terakhir)
├── viewmodels/
│   ├── weather_viewmodel.dart     # State cuaca, favorit, riwayat, lokasi terpilih
│   ├── search_viewmodel.dart      # State pencarian + debounce
│   └── view_status.dart           # enum: initial, loading, success, empty, error
├── views/
│   ├── home_screen.dart           # Screen 1: cuaca
│   └── search_screen.dart         # Screen 2: pencarian & lokasi
├── widgets/
│   ├── weather_card.dart          # Ikon, suhu, kondisi, tertinggi/terendah
│   ├── stats_card.dart            # Kelembapan, angin, peluang hujan, dll.
│   ├── hourly_strip.dart          # Prakiraan per jam
│   ├── forecast_card.dart         # Prakiraan 7 hari
│   └── state_message.dart         # Tampilan error / data kosong
├── utils/
│   └── weather_helper.dart        # Kode cuaca → teks/ikon, format tanggal, pesan error
└── theme/
    └── app_theme.dart             # ThemeData, warna, typography
🏛️ Penerapan MVVM

Aplikasi memisahkan tanggung jawab ke dalam tiga lapisan utama, ditambah lapisan service untuk akses data.

Lapisan	Peran	Berkas
Model	Struktur data dan parsing JSON (fromJson / toJson). Tidak mengenal UI.	location_model.dart, weather_model.dart
Service	Mengambil data dari sumber luar (HTTP API, penyimpanan lokal).	weather_service.dart, geocoding_service.dart, storage_service.dart
ViewModel	Menyimpan state, menjalankan logika (muat cuaca, favorit, riwayat, pencarian), lalu memberi tahu View lewat notifyListeners().	weather_viewmodel.dart, search_viewmodel.dart
View	Hanya menampilkan state dan meneruskan aksi pengguna ke ViewModel. Tidak memanggil API secara langsung.	home_screen.dart, search_screen.dart, widgets/
Alur Data
 View (Home/Search)
   │  aksi pengguna: pilih kota, ketik pencarian, tekan favorit
   ▼
 ViewModel (WeatherViewModel / SearchViewModel)
   │  memanggil
   ▼
 Service (WeatherService / GeocodingService / StorageService)
   │  HTTP GET / SharedPreferences
   ▼
 API Open-Meteo / Penyimpanan lokal
   │  JSON
   ▼
 Model (WeatherModel / LocationModel)  ──►  ViewModel menyimpan state
                                                │ notifyListeners()
                                                ▼
                                   View membangun ulang tampilan
                                   (context.watch<ViewModel>())

Pembagian ViewModel

WeatherViewModel — lokasi terpilih, data cuaca, daftar favorit, riwayat, dan cuaca ringkas tiap favorit. Dibuat satu kali di main.dart sehingga dipakai oleh kedua screen.
SearchViewModel — query, hasil pencarian, dan status pencarian. Dibuat saat SearchScreen dibuka dan dibuang ketika screen ditutup.
🌐 Implementasi API
1. Forecast API — cuaca

GET https://api.open-meteo.com/v1/forecast

Parameter	Nilai
latitude, longitude	Koordinat kota terpilih
current	temperature_2m, relative_humidity_2m, apparent_temperature, precipitation, weather_code, wind_speed_10m
hourly	temperature_2m, weather_code
daily	weather_code, temperature_2m_max, temperature_2m_min, precipitation_probability_max
timezone	auto
forecast_days	7

Pemetaan field API → tampilan

Data	Field API
Suhu saat ini	current.temperature_2m
Kelembapan	current.relative_humidity_2m
Suhu terasa	current.apparent_temperature
Curah hujan	current.precipitation
Kode kondisi cuaca	current.weather_code
Kecepatan angin	current.wind_speed_10m
Suhu maksimum / minimum harian	daily.temperature_2m_max / daily.temperature_2m_min
Peluang hujan maksimum	daily.precipitation_probability_max
2. Geocoding API — pencarian kota

GET https://geocoding-api.open-meteo.com/v1/search

Parameter	Nilai
name	Kata kunci kota dari input pengguna
count	10
language	id
format	json
3. Pengolahan Respons
WeatherService / GeocodingService mengirim request GET dengan timeout 15 detik.
Jika statusCode != 200, service melempar Exception berisi kode status.
Body di-decode dengan jsonDecode, lalu diubah menjadi objek Dart lewat WeatherModel.fromJson dan LocationModel.fromJson.
ViewModel menyimpan hasilnya dan memanggil notifyListeners().
4. Kode Cuaca (WMO) → Deskripsi
Kode	Deskripsi
0	Cerah
1	Cerah Berawan
2	Berawan Sebagian
3	Mendung
45, 48	Berkabut
51–57	Gerimis
61–67	Hujan
71–77	Salju
80–82	Hujan Deras
85, 86	Hujan Salju
≥ 95	Badai Petir
🔄 Pengelolaan State

Menggunakan Provider dengan ChangeNotifier.

main.dart membungkus aplikasi dengan ChangeNotifierProvider<WeatherViewModel> dan langsung memanggil init().
View membaca state dengan context.watch<...>() (dibangun ulang saat state berubah) dan memicu aksi dengan context.read<...>().
Semua tampilan ditentukan oleh enum ViewStatus { initial, loading, success, empty, error }.

Alur pencarian → cuaca

Pengguna mengetik di kolom pencarian → SearchViewModel.onQueryChanged().
Debounce 500 ms, lalu GeocodingService.searchCity() dipanggil.
Hasil tampil sebagai daftar kota.
Pengguna memilih kota → WeatherViewModel.selectLocation() menyimpan lokasi, menambahkannya ke riwayat, lalu memuat cuaca dari Forecast API.
HomeScreen otomatis diperbarui.

Perlindungan race condition: hasil pencarian lama diabaikan bila query sudah berubah (if (query != _query) return;).

💾 Penyimpanan Lokal

Menggunakan SharedPreferences. Objek LocationModel diubah menjadi JSON string (toJson) sebelum disimpan.

Key	Isi	Dipakai untuk
favorite_cities	Daftar kota favorit	Bagian Kota Favorit
recent_cities	5 kota terakhir yang dipilih	Bagian Terakhir Dicari
last_location	Kota yang terakhir dibuka	Dibuka otomatis saat aplikasi dijalankan

Saat aplikasi dibuka, WeatherViewModel.init() memuat ketiga data tersebut sehingga tampil kembali tanpa pengguna mengulang pencarian. Data yang rusak/tidak valid dilewati (try/catch) agar aplikasi tidak crash.

🎨 Tema & Typography

Seluruh warna dan gaya teks dipusatkan di lib/theme/app_theme.dart.

Material 3 dengan ColorScheme.fromSeed(seedColor: primary).
Warna utama: primary #3D5AFE, deep #1B2470, surface #F5F6FA.
Typography (TextTheme): displayLarge 84 (suhu utama), headlineMedium 26 (nama kota), titleLarge 20, titleMedium 16, bodyMedium 14, labelSmall 12.
Gradien biru yang sama dipakai di Home dan Search agar tampilan konsisten.
🚦 Penanganan Loading, Data Kosong, dan Error
Kondisi	Home	Search
Loading	Indikator putar di tengah layar	Indikator putar saat mencari
Data kosong	"Data kosong" + tombol Muat Ulang	"Kota tidak ditemukan"
Error	Pesan error + tombol Coba Lagi	"Pencarian gagal" + tombol Coba Lagi

Pesan error diterjemahkan oleh WeatherHelper.errorText():

Penyebab	Pesan
SocketException	Tidak ada koneksi internet
TimeoutException	Permintaan terlalu lama
Status HTTP ≠ 200	Gagal mengambil data / mencari kota (disertai kode status)
▶️ Cara Menjalankan

Prasyarat: Flutter SDK (channel stable), Android Studio / VS Code, serta emulator atau perangkat Android. Perangkat harus terhubung ke internet.

bash
# 1. Clone repositori
git clone https://github.com/qaylaputri575-byte/Responsi2PrakPemrogramanMobile.git
cd weather_app

# 2. Unduh dependency
flutter pub get

# 3. Jalankan aplikasi
flutter run
📚 Referensi
Open-Meteo Weather Forecast API
Open-Meteo Geocoding API
Flutter Documentation
Provider Package