

For this project, I have made 3 models: ModeModel, GroupModel and StudentModel.

StudentModel has a nullable group reference, so each student can belong to zero or one group at a time.  Each GroupModel maintains its own list of students and can optionally have a ModeModel assigned to it.
Modes are reusable predefined objects (3 modes), while the class itself provides the default mode when a group has no specific mode assigned.

When a student leaves a group, their group reference is immediately set to null, and they are removed from the group’s student list. The student falls back to the class default mode.
The same process occurs when a student is moved directly to another group: they are first removed from the old group, then added to the new group

I also considered deleting groups and assigning groups without a mode. When a group is deleted, all of its students are unassigned rather than being left with a reference to a nonexistent group.  If a group has no mode assigned, its students use the class default. The design also prevents a student from remaining in two groups because every move removes the student from their previous group before adding them to the new one.

Added a search feature on the students keep the "who has what" view usable as the class size grows — filters by student name.