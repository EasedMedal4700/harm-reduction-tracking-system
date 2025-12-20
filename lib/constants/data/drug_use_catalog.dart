class DrugUseCatalog {
  // ============================================================================
  // CONSUMPTION METHODS
  // ============================================================================

  static const List<Map<String, String>> consumptionMethods = [
    {'name': 'oral', 'emoji': '💊'},
    {'name': 'insufflated', 'emoji': '👃'},
    {'name': 'inhaled', 'emoji': '💨'},
    {'name': 'sublingual', 'emoji': '👅'},
    {'name': 'rectal', 'emoji': '🩺'}, // Neutral medical icon; adjust if needed
    {'name': 'intravenous', 'emoji': '💉'},
    {'name': 'intramuscular', 'emoji': '💪'},
  ];

  // ============================================================================
  // PRIMARY EMOTIONS
  // ============================================================================

  static const List<Map<String, String>> primaryEmotions = [
    {'name': 'Happy', 'emoji': '😊'},
    {'name': 'Calm', 'emoji': '😌'},
    {'name': 'Anxious', 'emoji': '😰'},
    {'name': 'Surprised', 'emoji': '😲'},
    {'name': 'Sad', 'emoji': '😢'},
    {'name': 'Disgusted', 'emoji': '🤢'},
    {'name': 'Angry', 'emoji': '😠'},
    {'name': 'Excited', 'emoji': '🤩'},
  ];

  static const Map<String, List<String>> secondaryEmotions = {
    'Happy': ['Joyful', 'Proud', 'Grateful', 'Satisfied'],
    'Calm': ['Peaceful', 'Relaxed', 'Grounded', 'Safe'],
    'Anxious': ['Nervous', 'Worried', 'Restless', 'Tense'],
    'Surprised': ['Curious', 'Shocked', 'Amazed'],
    'Sad': ['Lonely', 'Disappointed', 'Hopeless', 'Grieving'],
    'Disgusted': ['Irritated', 'Grossed Out', 'Uncomfortable'],
    'Angry': ['Frustrated', 'Annoyed', 'Bitter', 'Hostile'],
    'Excited': ['Energized', 'Motivated', 'Inspired', 'Playful'],
  };

  // ============================================================================
  // SUBSTANCES
  // ============================================================================

  static const List<String> substances = [
    'Test',
    'Cannabis',
    'Cocaine',
    'Heroin',
    'Methamphetamine',
    'MDMA',
    'Alcohol',
    'Nicotine',
    'Other',
  ];

  static const List<String> locations = [
    'Select a location',
    'Home',
    'Work',
    'School',
    'Public',
    'Vehicle',
    'Gym',
    'Other',
  ];
}
