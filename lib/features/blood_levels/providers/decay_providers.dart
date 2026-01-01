import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/decay_service.dart';

final decayServiceProvider = Provider<DecayService>((ref) => DecayService());
