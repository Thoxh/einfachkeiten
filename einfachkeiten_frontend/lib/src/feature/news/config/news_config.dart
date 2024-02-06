class NewsConfig {
  static Uri cmsUri = Uri.parse('https://api.thoxh.de/items/einfachkeiten');
  static Uri cmsFilesUri = Uri.parse('https://api.thoxh.de/assets');
  static Uri cmsIncrementCounterFlowUri = Uri.parse(
      'https://api.thoxh.de/flows/trigger/3430fec7-2719-4188-b3a1-1c9919b3e1c8');

  static Map<String, String>? cmsHeader = {
    'Authorization': 'Bearer iNrNyhyJHslO8VRo7Fdgqd4QVQw4zN8Y',
    'Content-Type': 'application/json'
  };
}
