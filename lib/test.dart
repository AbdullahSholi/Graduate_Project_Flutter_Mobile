import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:graduate_project/screens/Login/logallpage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Stripe.publishableKey="pk_test_51P0BDE1qqwiIHxVLW2VQnKp18Mv56mjqtQTGOw8ZyjkBN8wsDyVo8ohAWlV85JDmvY5lBeql0i1q8dl3IFCjtFw400LCCXSBZ7";
// print("AAAA ${ApiKeys.publishableKey}");
//Remove this method to stop OneSignal Debugging
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());




}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _enableConsentButton = false;
  String _debugLabelString = "";
  String? _emailAddress;
  String? _smsNumber;
  String? _externalUserId;
  String? _language;
  String? _liveActivityId;
  bool _requireConsent = false;

//   void _handleSendTags() {
//     print("Sending tags");
//     OneSignal.User.addTagWithKey("test2", "val2");
//
//     print("Sending tags array");
//     var sendTags = {'test': 'value', 'test2': 'value2'};
//     OneSignal.User.addTags(sendTags);
//   }
//
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     if (!mounted) return;
//
// //     OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
// //
// //     OneSignal.initialize("6991924e-f460-444c-824d-bf138d0e8d7b");
// //
// // // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//
//
//     OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//
//     OneSignal.Debug.setAlertLevel(OSLogLevel.none);
//     OneSignal.consentRequired(_requireConsent);
//
//     // NOTE: Replace with your own app ID from https://www.onesignal.com
//     OneSignal.initialize("6991924e-f460-444c-824d-bf138d0e8d7b");
//     print("++++++++++++++++++++++++++++++++++++");
//     var temp = await OneSignal.User.pushSubscription.id;
//
//     print(temp);
//     print("++++++++++++++++++++++++++++++++++++");
//     OneSignal.Notifications.requestPermission(true);
//
//
//
//     OneSignal.LiveActivities.setupDefault();
//     // OneSignal.LiveActivities.setupDefault(options: new LiveActivitySetupOptions(enablePushToStart: false, enablePushToUpdate: true));
//
//     // AndroidOnly stat only
//     // OneSignal.Notifications.removeNotification(1);
//     // OneSignal.Notifications.removeGroupedNotifications("group5");
//
//     OneSignal.Notifications.clearAll();
//
//     OneSignal.User.pushSubscription.addObserver((state) {
//       print(OneSignal.User.pushSubscription.optedIn);
//       print(OneSignal.User.pushSubscription.id);
//       print(OneSignal.User.pushSubscription.token);
//       print(state.current.jsonRepresentation());
//     });
//
//     OneSignal.User.addObserver((state) {
//       var userState = state.jsonRepresentation();
//       print('OneSignal user changed: $userState');
//     });
//
//     OneSignal.Notifications.addPermissionObserver((state) {
//       print("Has permission " + state.toString());
//     });
//
//     OneSignal.Notifications.addClickListener((event) {
//       print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
//       this.setState(() {
//         _debugLabelString =
//         "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
//       });
//     });
//
//     OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//       print(
//           'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
//
//       /// Display Notification, preventDefault to not display
//       event.preventDefault();
//
//       /// Do async work
//
//       /// notification.display() to display after preventing default
//       event.notification.display();
//
//       this.setState(() {
//         _debugLabelString =
//         "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
//       });
//     });
//
//     OneSignal.InAppMessages.addClickListener((event) {
//       this.setState(() {
//         _debugLabelString =
//         "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}";
//       });
//     });
//     OneSignal.InAppMessages.addWillDisplayListener((event) {
//       print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
//     });
//     OneSignal.InAppMessages.addDidDisplayListener((event) {
//       print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
//     });
//     OneSignal.InAppMessages.addWillDismissListener((event) {
//       print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
//     });
//     OneSignal.InAppMessages.addDidDismissListener((event) {
//       print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
//     });
//
//     this.setState(() {
//       _enableConsentButton = _requireConsent;
//     });
//
//     // Some examples of how to use In App Messaging public methods with OneSignal SDK
//     oneSignalInAppMessagingTriggerExamples();
//
//     // Some examples of how to use Outcome Events public methods with OneSignal SDK
//     oneSignalOutcomeExamples();
//
//     OneSignal.InAppMessages.paused(true);
//   }


  //
  // void _handleRemoveTag() {
  //   print("Deleting tag");
  //   OneSignal.User.removeTag("test2");
  //
  //   print("Deleting tags array");
  //   OneSignal.User.removeTags(['test']);
  // }
  //
  // void _handleGetTags() async {
  //   print("Get tags");
  //
  //   var tags = await OneSignal.User.getTags();
  //   print(tags);
  // }
  //
  // void _handlePromptForPushPermission() {
  //   print("Prompting for Permission");
  //   OneSignal.Notifications.requestPermission(true);
  // }
  //
  // void _handleSetLanguage() {
  //   if (_language == null) return;
  //   print("Setting language");
  //   OneSignal.User.setLanguage(_language!);
  // }
  //
  // void _handleSetEmail() {
  //   if (_emailAddress == null) return;
  //   print("Setting email");
  //
  //   OneSignal.User.addEmail(_emailAddress!);
  // }
  //
  // void _handleRemoveEmail() {
  //   if (_emailAddress == null) return;
  //   print("Remove email");
  //
  //   OneSignal.User.removeEmail(_emailAddress!);
  // }
  //
  // void _handleSetSMSNumber() {
  //   if (_smsNumber == null) return;
  //   print("Setting SMS Number");
  //
  //   OneSignal.User.addSms(_smsNumber!);
  // }
  //
  // void _handleRemoveSMSNumber() {
  //   if (_smsNumber == null) return;
  //   print("Remove smsNumber");
  //
  //   OneSignal.User.removeSms(_smsNumber!);
  // }
  //
  // void _handleConsent() {
  //   print("Setting consent to true");
  //   OneSignal.consentGiven(true);
  //
  //   print("Setting state");
  //   this.setState(() {
  //     _enableConsentButton = false;
  //   });
  // }
  //
  // void _handleSetLocationShared() {
  //   print("Setting location shared to true");
  //   OneSignal.Location.setShared(true);
  // }
  //
  // void _handleGetExternalId() async {
  //   var externalId = await OneSignal.User.getExternalId();
  //   print('External ID: $externalId');
  // }
  //
  // void _handleLogin() {
  //   print("Setting external user ID");
  //   if (_externalUserId == null) return;
  //   OneSignal.login(_externalUserId!);
  //   OneSignal.User.addAlias("fb_id", "1341524");
  // }
  //
  // void _handleLogout() {
  //   OneSignal.logout();
  //   OneSignal.User.removeAlias("fb_id");
  // }
  //
  // void _handleGetOnesignalId() async {
  //   var onesignalId = await OneSignal.User.getOnesignalId();
  //   print('OneSignal ID: $onesignalId');
  // }
  //
  // oneSignalInAppMessagingTriggerExamples() async {
  //   /// Example addTrigger call for IAM
  //   /// This will add 1 trigger so if there are any IAM satisfying it, it
  //   /// will be shown to the user
  //   OneSignal.InAppMessages.addTrigger("trigger_1", "one");
  //
  //   /// Example addTriggers call for IAM
  //   /// This will add 2 triggers so if there are any IAM satisfying these, they
  //   /// will be shown to the user
  //   Map<String, String> triggers = new Map<String, String>();
  //   triggers["trigger_2"] = "two";
  //   triggers["trigger_3"] = "three";
  //   OneSignal.InAppMessages.addTriggers(triggers);
  //
  //   // Removes a trigger by its key so if any future IAM are pulled with
  //   // these triggers they will not be shown until the trigger is added back
  //   OneSignal.InAppMessages.removeTrigger("trigger_2");
  //
  //   // Create a list and bulk remove triggers based on keys supplied
  //   List<String> keys = ["trigger_1", "trigger_3"];
  //   OneSignal.InAppMessages.removeTriggers(keys);
  //
  //   // Toggle pausing (displaying or not) of IAMs
  //   OneSignal.InAppMessages.paused(true);
  //   var arePaused = await OneSignal.InAppMessages.arePaused();
  //   print('Notifications paused $arePaused');
  // }
  //
  // oneSignalOutcomeExamples() async {
  //   OneSignal.Session.addOutcome("normal_1");
  //   OneSignal.Session.addOutcome("normal_2");
  //
  //   OneSignal.Session.addUniqueOutcome("unique_1");
  //   OneSignal.Session.addUniqueOutcome("unique_2");
  //
  //   OneSignal.Session.addOutcomeWithValue("value_1", 3.2);
  //   OneSignal.Session.addOutcomeWithValue("value_2", 3.9);
  // }
  //
  // void _handleOptIn() {
  //   OneSignal.User.pushSubscription.optIn();
  // }
  //
  // void _handleOptOut() {
  //   OneSignal.User.pushSubscription.optOut();
  // }
  //
  // void _handleStartDefaultLiveActivity() {
  //   if (_liveActivityId == null) return;
  //   print("Starting default live activity");
  //   OneSignal.LiveActivities.startDefault(_liveActivityId!, {
  //     "title": "Welcome!"
  //   }, {
  //     "message": {"en": "Hello World!"},
  //     "intValue": 3,
  //     "doubleValue": 3.14,
  //     "boolValue": true
  //   });
  // }
  //
  // void _handleEnterLiveActivity() {
  //   if (_liveActivityId == null) return;
  //   print("Entering live activity");
  //   OneSignal.LiveActivities.enterLiveActivity(_liveActivityId!, "FAKE_TOKEN");
  // }
  //
  // void _handleExitLiveActivity() {
  //   if (_liveActivityId == null) return;
  //   print("Exiting live activity");
  //   OneSignal.LiveActivities.exitLiveActivity(_liveActivityId!);
  // }
  //
  // void _handleSetPushToStartLiveActivity() {
  //   if (_liveActivityId == null) return;
  //   print("Setting Push-To-Start live activity");
  //   OneSignal.LiveActivities.setPushToStartToken(
  //       _liveActivityId!, "FAKE_TOKEN");
  // }
  //
  // void _handleRemovePushToStartLiveActivity() {
  //   if (_liveActivityId == null) return;
  //   print("Setting Push-To-Start live activity");
  //   OneSignal.LiveActivities.removePushToStartToken(_liveActivityId!);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initPlatformState();
    initPlatform();

  }
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Table(
            children: [
              TableRow(
                children: [
                 TextButton(onPressed: (){
                   initPlatform();
                 }, child: Text("Click!"))
                ]
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initPlatform() async{
    await OneSignal.shared.setAppId("6991924e-f460-444c-824d-bf138d0e8d7b");
    await OneSignal.shared.getDeviceState().then((value) => print("${value?.userId} RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"));
  }
}
//
// typedef void OnButtonPressed();
//
// class OneSignalButton extends StatefulWidget {
//   final String title;
//   final OnButtonPressed onPressed;
//   final bool enabled;
//
//   OneSignalButton(this.title, this.onPressed, this.enabled);
//
//   State<StatefulWidget> createState() => new OneSignalButtonState();
// }
//
// class OneSignalButtonState extends State<OneSignalButton> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return new Table(
//       children: [
//         new TableRow(children: [
//           new TextButton(
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               disabledForegroundColor: Colors.white,
//               backgroundColor: Color.fromARGB(255, 212, 86, 83),
//               disabledBackgroundColor: Color.fromARGB(180, 212, 86, 83),
//               padding: EdgeInsets.all(8.0),
//             ),
//             child: new Text(widget.title),
//             onPressed: widget.enabled ? widget.onPressed : null,
//           )
//         ]),
//         new TableRow(children: [
//           Container(
//             height: 8.0,
//           )
//         ]),
//       ],
//     );
//   }
// }
