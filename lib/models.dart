/// Core domain model for group-level mode assignment.
///
/// Design summary (see write-up for the full version):
/// - A Class has a default Mode that applies to every student by default.
/// - A Class can contain any number of Groups. A Group MAY have its own
///   Mode override; a freshly created Group has no mode (mode == null)
///   until a teacher explicitly assigns one.
/// - A student belongs to AT MOST ONE group at a time within a class.
///   (Assumption: the real product's roster/mode UI is single-select per
///   student, so we mirror that exclusivity here rather than allowing
///   overlapping groups, which would create an ambiguous "which mode wins"
///   question the task doesn't ask us to solve.)
/// - Resolution rule: if a student is in a group AND that group has a mode
///   set, the group's mode wins. Otherwise the student falls back to the
///   class default. This means removing a student from a group (or moving
///   them into a group with no mode set) instantly and correctly reverts
///   them to the class default — there's no separate "unassign" step to
///   forget.
library;

enum Mode { adventure, reading, focus }

extension ModeLabel on Mode {
  String get label => switch (this) {
        Mode.adventure => 'Abenteuer-Modus',
        Mode.reading => 'Lese-Modus',
        Mode.focus => 'Fokus-Modus',
      };
}

class Student {
  final String id;
  final String name;
  Student({required this.id, required this.name});
}

class Group {
  final String id;
  String name;

  /// null = this group has no override yet; members fall back to the
  /// class default until a teacher assigns one.
  Mode? mode;

  final Set<String> studentIds = {};

  Group({required this.id, required this.name, this.mode});
}

enum ModeSource { classDefault, group }

class ModeResolution {
  final Mode mode;
  final ModeSource source;
  final String? groupName;

  ModeResolution({required this.mode, required this.source, this.groupName});

  String get label => source == ModeSource.classDefault
      ? '${mode.label} · Klassen-Standard'
      : '${mode.label} · Gruppe "$groupName"';
}

class SchoolClass {
  final String id;
  final String name;
  Mode defaultMode;

  final List<Student> students = [];
  final List<Group> groups = [];

  SchoolClass({required this.id, required this.name, required this.defaultMode});

  Student studentById(String id) => students.firstWhere((s) => s.id == id);

  /// The group a student currently belongs to, if any.
  Group? groupOf(String studentId) {
    for (final g in groups) {
      if (g.studentIds.contains(studentId)) return g;
    }
    return null;
  }

  /// The single source of truth for "what mode does this student see".
  ModeResolution resolveModeFor(String studentId) {
    final group = groupOf(studentId);
    if (group != null && group.mode != null) {
      return ModeResolution(
        mode: group.mode!,
        source: ModeSource.group,
        groupName: group.name,
      );
    }
    return ModeResolution(mode: defaultMode, source: ModeSource.classDefault);
  }

  Group createGroup(String name) {
    final group = Group(id: 'g_${DateTime.now().microsecondsSinceEpoch}', name: name);
    groups.add(group);
    return group;
  }

  /// Assigns a mode to an entire group in one action — every current and
  /// future member resolves to it immediately, with no per-student step.
  void assignModeToGroup(String groupId, Mode? mode) {
    groups.firstWhere((g) => g.id == groupId).mode = mode;
  }

  /// Moves a student to [targetGroupId], or back to the class default if
  /// [targetGroupId] is null. Handles removal from any prior group so a
  /// student is never silently left in two places at once.
  void moveStudent(String studentId, String? targetGroupId) {
    for (final g in groups) {
      g.studentIds.remove(studentId);
    }
    if (targetGroupId != null) {
      groups.firstWhere((g) => g.id == targetGroupId).studentIds.add(studentId);
    }
    // No further bookkeeping needed: resolveModeFor() reflects the new
    // state on its next call, because it always derives the answer from
    // current group membership rather than caching a "resolved mode" field.
  }
}

/// Seed data roughly mirroring the "4A" class from the reference screens.
SchoolClass buildSampleClass() {
  final schoolClass = SchoolClass(id: 'c_4a', name: '4A (25/26)', defaultMode: Mode.adventure);

  schoolClass.students.addAll([
    Student(id: 's1', name: 'Anna'),
    Student(id: 's2', name: 'Toni'),
    Student(id: 's3', name: 'Selin'),
    Student(id: 's4', name: 'Helga'),
    Student(id: 's5', name: 'Lukas'),
    Student(id: 's6', name: 'Mahir'),
    Student(id: 's7', name: 'Julian'),
    Student(id: 's8', name: 'Adam'),
    Student(id: 's9', name: 'Olina'),
  ]);

  final focusGroup = schoolClass.createGroup('Leseförderung');
  focusGroup.mode = Mode.focus;
  schoolClass.moveStudent('s3', focusGroup.id);
  schoolClass.moveStudent('s4', focusGroup.id);

  final readingGroup = schoolClass.createGroup('Ruhige Ecke');
  // Deliberately left with no mode yet, to demonstrate the "group exists
  // but has no override" state — its members still show the class default.
  schoolClass.moveStudent('s6', readingGroup.id);

  return schoolClass;
}
