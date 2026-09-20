
class ModeModel {
  final int id;
  final String name;

  ModeModel({required this.id, required this.name});
}



//Todo: Dynamically generate modes list from a firestore or API in the future. For now, we have a static list of modes for demonstration purposes.
List<ModeModel> modes = [
  ModeModel(id: 1, name: 'Abenteuer-Modus'),
  ModeModel(id: 2, name: 'Lese-Modus'),
  ModeModel(id: 3, name: 'Fokus-Modus'),
];