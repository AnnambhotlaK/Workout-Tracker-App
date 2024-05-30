import 'package:flutter/material.dart';
import 'package:main/components/exercise_tile.dart';
import 'package:main/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // Checkbox was ticked
  void onCheckboxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  // Text controllers for creating new exercise
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // Creating a new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add a New Exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Exercise Name
                  TextField(
                    decoration: const InputDecoration(label: Text('Name: ')),
                    controller: exerciseNameController,
                  ),

                  // Weight
                  TextField(
                    decoration: const InputDecoration(label: Text('Weight: ')),
                    controller: weightController,
                  ),

                  // Reps
                  TextField(
                    decoration: const InputDecoration(label: Text('Reps: ')),
                    controller: repsController,
                  ),

                  // Sets
                  TextField(
                    decoration: const InputDecoration(label: Text('Sets: ')),
                    controller: setsController,
                  ),
                ],
              ),
              actions: [
                // Save button
                MaterialButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),

                // Cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }

  // Save Workout
  void save() {
    // Get exercise information from controllers
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    // Add workout to workoutdata list
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);

    // Pop dialog box
    Navigator.pop(context);
    clear();
  }

  // Cancel Workout
  void cancel() {
    // Pop dialog box
    Navigator.pop(context);
    clear();
  }

  // Clear controller
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            appBar: AppBar(title: Text(widget.workoutName)),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewExercise,
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
                itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
                itemBuilder: (context, index) => ExerciseTile(
                      exerciseName: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .name,
                      weight: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .weight,
                      reps: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .reps,
                      sets: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .sets,
                      isCompleted: value
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .isCompleted,
                      onCheckboxChanged: (val) => onCheckboxChanged(
                          widget.workoutName,
                          value
                              .getRelevantWorkout(widget.workoutName)
                              .exercises[index]
                              .name),
                    ))));
  }
}
