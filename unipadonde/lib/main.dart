import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unipadonde/startpage/start_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://atswkwzuztfzaerlpcpc.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF0c3drd3p1enRmemFlcmxwY3BjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5MjczNTcsImV4cCI6MjA1MzUwMzM1N30.FzMP9I3qs9aVol2njwWYjFPKJAgtBE-RkcQ-UrinA2A');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discount App',
      debugShowCheckedModeBanner: false,
      home: const StartView(),
    );
  }
}
/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SupabaseRepository _repository = SupabaseRepository();
  late Future<List<Map<String, dynamic>>> _countriesfuture;
  @override
  void initState() {
    super.initState();
    // Initialize the _countriesfuture variable here
    _countriesfuture = _repository.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3D405B),
        elevation: 10,
        shadowColor: Colors.black,
        title: const Center(
          child: Text(
            'countries',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _countriesfuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('no data'));
          }
          final countries = snapshot.data!;
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return Text(country['country']);
            },
          );
        },
      ),
    );
  }
}*/
