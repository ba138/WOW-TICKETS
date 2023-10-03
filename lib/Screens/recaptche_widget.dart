// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class ReCaptchaPage extends StatefulWidget {
//   @override
//   _ReCaptchaPageState createState() => _ReCaptchaPageState();
// }

// class _ReCaptchaPageState extends State<ReCaptchaPage> {
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('reCAPTCHA v2 Example'),
//       ),
//       body: WebView(
//         initialUrl: 'https://www.example.com/recaptcha_page', // Replace with your reCAPTCHA v2 URL
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController controller) {
//           _controller.complete(controller);
//         },
//         onPageFinished: (String url) {
//           // Page has finished loading, you can trigger reCAPTCHA here if needed
//           if (url.contains('recaptcha_page')) {
//             // Execute JavaScript code to trigger reCAPTCHA
//             _controller.future.then((controller) {
//               controller.evaluateJavascript('''
//                 // Replace 'YOUR_RECAPTCHA_SITE_KEY' with your actual reCAPTCHA v2 Site Key
//                 var siteKey = 'YOUR_RECAPTCHA_SITE_KEY';
//                 grecaptcha.ready(function() {
//                   grecaptcha.execute(siteKey, {action: 'submit'}).then(function(token) {
//                     // Send the token to your Flutter app
//                     window.flutter_inappwebview.callHandler('onRecaptchaToken', token);
//                   });
//                 });
//               ''');
//             });
//           }
//         },
//         javascriptChannels: <JavascriptChannel>[
//           // JavaScript channel for receiving reCAPTCHA tokens
//           JavascriptChannel(
//             name: 'flutter_inappwebview',
//             onMessageReceived: (JavascriptMessage message) {
//               final token = message.message;
//               // Handle the reCAPTCHA token received from JavaScript
//               print('reCAPTCHA Token: $token');
//             },
//           ),
//         ].toSet(),
//       ),
//     );
//   }
// }
