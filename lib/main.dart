import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/hive_service.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/match_provider.dart';
import 'presentation/providers/registration_provider.dart';
import 'presentation/providers/scoring_provider.dart';
import 'data/repositories/match_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/registration_repository_impl.dart';
import 'data/repositories/end_repository_impl.dart';
import 'data/repositories/match_score_repository_impl.dart';
import 'domain/usecases/create_match.dart';
import 'domain/usecases/get_matches.dart';
import 'domain/usecases/register_for_match.dart';
import 'domain/usecases/get_match_registrations.dart';
import 'domain/usecases/manage_registration.dart';
import 'domain/usecases/start_match.dart';
import 'domain/usecases/record_end.dart';
import 'domain/usecases/get_match_scores.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // Initialize Hive
  await HiveService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repositories
        Provider<MatchRepositoryImpl>(
          create: (_) => MatchRepositoryImpl(),
        ),
        Provider<UserRepositoryImpl>(
          create: (_) => UserRepositoryImpl(),
        ),
        Provider<RegistrationRepositoryImpl>(
          create: (context) => RegistrationRepositoryImpl(
            userRepository: context.read<UserRepositoryImpl>(),
          ),
        ),
        Provider<EndRepositoryImpl>(
          create: (_) => EndRepositoryImpl(),
        ),
        Provider<MatchScoreRepositoryImpl>(
          create: (context) => MatchScoreRepositoryImpl(
            endRepository: context.read<EndRepositoryImpl>(),
            userRepository: context.read<UserRepositoryImpl>(),
          ),
        ),
        
        // Use Cases
        Provider<CreateMatch>(
          create: (context) => CreateMatch(context.read<MatchRepositoryImpl>()),
        ),
        Provider<GetMatches>(
          create: (context) => GetMatches(context.read<MatchRepositoryImpl>()),
        ),
        Provider<WatchMatches>(
          create: (context) => WatchMatches(context.read<MatchRepositoryImpl>()),
        ),
        Provider<RegisterForMatch>(
          create: (context) => RegisterForMatch(
            registrationRepository: context.read<RegistrationRepositoryImpl>(),
            userRepository: context.read<UserRepositoryImpl>(),
          ),
        ),
        Provider<GetMatchRegistrations>(
          create: (context) => GetMatchRegistrations(context.read<RegistrationRepositoryImpl>()),
        ),
        Provider<ManageRegistration>(
          create: (context) => ManageRegistration(context.read<RegistrationRepositoryImpl>()),
        ),
        Provider<StartMatch>(
          create: (context) => StartMatch(
            matchRepository: context.read<MatchRepositoryImpl>(),
            registrationRepository: context.read<RegistrationRepositoryImpl>(),
            scoreRepository: context.read<MatchScoreRepositoryImpl>(),
          ),
        ),
        Provider<RecordEnd>(
          create: (context) => RecordEnd(
            endRepository: context.read<EndRepositoryImpl>(),
            scoreRepository: context.read<MatchScoreRepositoryImpl>(),
            matchRepository: context.read<MatchRepositoryImpl>(),
          ),
        ),
        Provider<GetMatchScores>(
          create: (context) => GetMatchScores(context.read<MatchScoreRepositoryImpl>()),
        ),
        
        // Providers
        ChangeNotifierProvider<MatchProvider>(
          create: (context) => MatchProvider(
            createMatch: context.read<CreateMatch>(),
            getMatches: context.read<GetMatches>(),
            watchMatches: context.read<WatchMatches>(),
            matchRepository: context.read<MatchRepositoryImpl>(),
          ),
        ),
        ChangeNotifierProvider<RegistrationProvider>(
          create: (context) => RegistrationProvider(
            registerForMatch: context.read<RegisterForMatch>(),
            getMatchRegistrations: context.read<GetMatchRegistrations>(),
            manageRegistration: context.read<ManageRegistration>(),
          ),
        ),
        ChangeNotifierProvider<ScoringProvider>(
          create: (context) => ScoringProvider(
            recordEnd: context.read<RecordEnd>(),
            getMatchScores: context.read<GetMatchScores>(),
            startMatch: context.read<StartMatch>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Archer Match Up',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
