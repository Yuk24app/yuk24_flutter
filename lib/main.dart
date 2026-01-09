import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const Yuk24App());
}

/// ================= GLOBAL TIL =================
ValueNotifier<String> appLang = ValueNotifier('uz');

/// ================= TARJIMALAR =================
final Map<String, Map<String, String>> tr = {
  'uz': {
    'login': 'KIRISH',
    'home': 'Asosiy sahifa',
    'jobs': 'Ishlar',
    'add': 'E’lon berish',
    'delivery': 'Yetkazib berish',
    'cargo': 'Yuk turi',
    'weight': 'Og‘irlik',
    'region': 'Viloyat',
    'city': 'Shahar',
    'car': 'Mashina rusumi',
    'phone': 'Telefon',
    'place': 'JOYLAШ',
    'search': 'Qidirish',
    'details': 'E’lon tafsiloti',
  },
  'ru': {
    'login': 'ВХОД',
    'home': 'Главная',
    'jobs': 'Работы',
    'add': 'Разместить',
    'delivery': 'Доставка',
    'cargo': 'Тип груза',
    'weight': 'Вес',
    'region': 'Область',
    'city': 'Город',
    'car': 'Тип машины',
    'phone': 'Телефон',
    'place': 'РАЗМЕСТИТЬ',
    'search': 'Поиск',
    'details': 'Детали',
  },
  'en': {
    'login': 'LOGIN',
    'home': 'Home',
    'jobs': 'Jobs',
    'add': 'Post ad',
    'delivery': 'Delivery',
    'cargo': 'Cargo type',
    'weight': 'Weight',
    'region': 'Region',
    'city': 'City',
    'car': 'Car type',
    'phone': 'Phone',
    'place': 'POST',
    'search': 'Search',
    'details': 'Details',
  },
};

String t(String key) => tr[appLang.value]![key]!;

/// ================= APP =================
class Yuk24App extends StatelessWidget {
  const Yuk24App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLang,
      builder: (context, _, __) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StartPage(),
        );
      },
    );
  }
}

/// ================= START PAGE =================
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'YUK24',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _langBtn('uz'),
                _langBtn('ru'),
                _langBtn('en'),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              ),
              child: Text(t('login')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _langBtn(String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              appLang.value == code ? Colors.blue : Colors.grey,
        ),
        onPressed: () => appLang.value = code,
        child: Text(code.toUpperCase()),
      ),
    );
  }
}

/// ================= HOME =================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('home'))),
      body: Row(
        children: [
          _card(context, t('add'), Colors.orange, const AddPage()),
          _card(context, t('delivery'), Colors.blue, const JobsPage()),
        ],
      ),
    );
  }

  Widget _card(BuildContext c, String text, Color color, Widget page) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= ISHLAR =================
class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  String searchText = '';
  String selectedCar = 'Barchasi';

  final carList = [
    'Barchasi',
    'Labo',
    'Isuzu',
    'Kamaz',
    'Fura',
    'Tentli fura',
    'Konteyner',
  ];

  final List<Map<String, String>> jobs = [
    {
      'cargo': 'Meva yuk',
      'car': 'Labo',
      'region': 'Andijon',
      'city': 'Asaka',
      'weight': '800',
      'unit': 'kg',
      'phone': '+998931112233',
    },
    {
      'cargo': 'Qurilish yuk',
      'car': 'Isuzu',
      'region': 'Toshkent',
      'city': 'Chilonzor',
      'weight': '5',
      'unit': 'tonna',
      'phone': '+998901234567',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = jobs.where((job) {
      final matchText =
          job['cargo']!.toLowerCase().contains(searchText.toLowerCase());
      final matchCar =
          selectedCar == 'Barchasi' || job['car'] == selectedCar;
      return matchText && matchCar;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(t('jobs'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: t('search'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (v) => setState(() => searchText = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              value: selectedCar,
              items: carList
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCar = v!),
              decoration: InputDecoration(labelText: t('car')),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(filtered[i]['cargo']!),
                  subtitle:
                      Text('${filtered[i]['weight']} ${filtered[i]['unit']}'),
                  trailing: Text(filtered[i]['car']!),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          JobDetailPage(job: filtered[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= ISH TAFSILOTI =================
class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;
  const JobDetailPage({super.key, required this.job});

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('details'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row(t('cargo'), job['cargo']!),
                _row(t('car'), job['car']!),
                _row(t('region'), job['region']!),
                _row(t('city'), job['city']!),
                _row(
                  t('weight'),
                  '${job['weight']} ${job['unit']}',
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _call(job['phone']!),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        job['phone']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$title: ',
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

/// ================= E’LON BERISH =================
class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String selectedCar = 'Labo';

  final carTypes = [
    'Labo',
    'Isuzu',
    'Kamaz',
    'Fura',
    'Tentli fura',
    'Konteyner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('add'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(decoration: InputDecoration(labelText: t('cargo'))),
            TextField(decoration: InputDecoration(labelText: t('weight'))),
            TextField(decoration: InputDecoration(labelText: t('region'))),
            TextField(decoration: InputDecoration(labelText: t('city'))),
            DropdownButtonFormField<String>(
              value: selectedCar,
              items: carTypes
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCar = v!),
              decoration: InputDecoration(labelText: t('car')),
            ),
            TextField(
              decoration: InputDecoration(labelText: t('phone')),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text(t('place')),
            ),
          ],
        ),
      ),
    );
  }
}
