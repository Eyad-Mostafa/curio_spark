class Curiosities {
  String? id;
  String? CuriosText;
  late bool isDone;

  Curiosities({
    required this.id,
    required this.CuriosText,
    this.isDone = false,
  });

  static List<Curiosities> todoList() {
    return [
      Curiosities(
          id: '06',
          CuriosText: 'with Great Power comes Great responsbalty',
          isDone: true),
      Curiosities(id: '02', CuriosText: 'Buy Groceries', isDone: true),
      Curiosities(
        id: '03',
        CuriosText: 'Check Emails',
      ),
      Curiosities(
        id: '04',
        CuriosText: 'Team Meeting',
      ),
      Curiosities(
        id: '05',
        CuriosText: 'Work on mobile apps for 2 hour',
      ),
      Curiosities(
        id: '01',
        CuriosText:
            'Unlike many cross-platform frameworks, Flutter doesnt use WebViews or rely heavily on bridges. It compiles directly to ARM or x86 native code, giving it buttery-smooth performance thats almost indistinguishable from native apps',
      ),
      Curiosities(
        id: '01',
        CuriosText:
            ' use WebViews or rely heavily on bridges. It compiles directly to ARM or x86 native code, giving it buttery-smooth performance thats almost indistinguishable from native apps',
      ),
      Curiosities(
        id: '01',
        CuriosText:
            'Unlike many cross-platform frameworks, Flutter doesnt use WebViews or rely heavily on bridges. It compiles directly to ARM or x86 native code, giving it buttery-smooth performance thats almost indistinguishable from native apps',
      ),
      Curiosities(
        id: '01',
        CuriosText:
            'Unlike many cross-platform frameworks, Flutter doesnt use WebViews or rely heavily on bridges. It compiles directly to ARM or x86 native code, giving it buttery-smooth performance thats almost indistinguishable from native apps',
      ),
      Curiosities(
        id: '01',
        CuriosText:
            'Unlike many cross-platform frameworks, Flutter doesnt use WebViews or rely heavily on bridges. It compiles directly to ARM or x86 native code, giving it buttery-smooth performance thats almost indistinguishable from native apps',
      ),
    ];
  }
}
