// This class is used to delay the loading of the app for a few seconds
// usage: AppDelay.delayLoading();
// It is used to show a splash screen for a few seconds
// It is also used to simulate a network request
// It is also used to show a loading indicator for a few seconds
// It is also used to show a loading screen for a few seconds
//To change the duration of the delay, change the value of the Duration in the delayLoading method
//Todo::Mostafa:: Refactor this class to make it more flexible by allowing the duration to be passed as a parameter
//Todo::Mostafa:: Add a method to cancel the delay
//Todo::Mostafa:: Add a method to check if the delay is active
//Todo::Mostafa:: Add a method to get the duration of the delay
//Todo::Mostafa:: Add a method to get the time remaining of the delay
//Todo::Mostafa:: Add a method to get the time elapsed of the delay
//Todo::Mostafa:: Add a method to get the status of the delay (active, cancelled, completed)
// Todo::Mostafa:: Add a method to get the start time of the delay
// Todo::Mostafa:: Add a method to get the end time of the delay

abstract class AppDelay {
  static Future<void> delayLoading() async {
    await Future.delayed(Duration(milliseconds: 700));
  }
}
