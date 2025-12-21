import 'package:mobile_drug_use_app/repo/substance_repository.dart';

class FakeSubstanceRepository implements SubstanceRepository {
  @override
  Future<Map<String, dynamic>?> getSubstanceDetails(
    String substanceName,
  ) async {
    if (substanceName.toLowerCase() == 'dexedrine') {
      return {
        'name': 'Dexedrine',
        'formatted_dose': {
          'oral': {'common': 10},
        },
        'roas': ['oral', 'insufflated'],
      };
    }
    return null;
  }

  @override
  List<String> getAvailableROAs(Map<String, dynamic>? substanceDetails) {
    return ['oral', 'insufflated', 'inhaled', 'sublingual'];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchSubstancesCatalog() async {
    return [
      {
        'name': 'Dexedrine',
        'pretty_name': 'Dexedrine',
        'categories': ['Stimulant'],
        'description': 'A stimulant drug.',
        'is_common': true,
      },
      {
        'name': 'Caffeine',
        'pretty_name': 'Caffeine',
        'categories': ['Stimulant'],
        'description': 'A mild stimulant.',
        'is_common': true,
      },
    ];
  }

  @override
  bool isROAValid(String roa, Map<String, dynamic>? substanceDetails) {
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
