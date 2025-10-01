import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/user_model.dart';
import '../../data/models/match_model.dart';
import '../../data/models/match_registration_model.dart';
import '../../data/models/end_model.dart';
import '../../data/models/match_score_model.dart';

class HiveService {
  static const String usersBoxName = 'users';
  static const String matchesBoxName = 'matches';
  static const String registrationsBoxName = 'registrations';
  static const String endsBoxName = 'ends';
  static const String scoresBoxName = 'scores';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(MatchModelAdapter());
    Hive.registerAdapter(MatchRegistrationModelAdapter());
    Hive.registerAdapter(EndModelAdapter());
    Hive.registerAdapter(MatchScoreModelAdapter());
    
    // Open boxes
    await Hive.openBox<UserModel>(usersBoxName);
    await Hive.openBox<MatchModel>(matchesBoxName);
    await Hive.openBox<MatchRegistrationModel>(registrationsBoxName);
    await Hive.openBox<EndModel>(endsBoxName);
    await Hive.openBox<MatchScoreModel>(scoresBoxName);
  }

  static Box<UserModel> get usersBox => Hive.box<UserModel>(usersBoxName);
  static Box<MatchModel> get matchesBox => Hive.box<MatchModel>(matchesBoxName);
  static Box<MatchRegistrationModel> get registrationsBox => Hive.box<MatchRegistrationModel>(registrationsBoxName);
  static Box<EndModel> get endsBox => Hive.box<EndModel>(endsBoxName);
  static Box<MatchScoreModel> get scoresBox => Hive.box<MatchScoreModel>(scoresBoxName);

  static Future<void> clearAllData() async {
    await usersBox.clear();
    await matchesBox.clear();
    await registrationsBox.clear();
    await endsBox.clear();
    await scoresBox.clear();
  }
}