// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:secretchat/controller/storyController.dart';

// List<CameraDescription> cameras;

// class CameraPreviewScreen extends StatefulWidget {
//   //const CameraPreview({ Key? key }) : super(key: key);

//   @override
//   _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
// }

// class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
//   //var storyController = Get.put(RecordController());

//   CameraController controller;

//   Future<void> cameraContent;

//   bool cameraOpenFront = true;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
//     cameraContent = controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   // @override
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   final CameraController cameraController = controller;

//   //   // App state changed before we got the chance to initialize.
//   //   if (cameraController == null || !cameraController.value.isInitialized) {
//   //     return;
//   //   }

//   //   if (state == AppLifecycleState.inactive) {
//   //     cameraController.dispose();
//   //   } else if (state == AppLifecycleState.resumed) {
//   //     onNewCameraSelected(cameraController.description);
//   //   }
//   // }

//   // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   // void showInSnackBar(String message) {
//   //   // ignore: deprecated_member_use
//   //   _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
//   // }

//   // void onNewCameraSelected(CameraDescription cameraDescription) async {
//   //   if (controller != null) {
//   //     await controller.dispose();
//   //   }

//   //   final CameraController cameraController = CameraController(
//   //     cameraDescription,
//   //     ResolutionPreset.max,
//   //     //enableAudio: enableAudio,
//   //     //imageFormatGroup: ImageFormatGroup.jpeg,
//   //   );

//   //   controller = cameraController;

//   //   // If the controller is updated then update the UI.
//   //   cameraController.addListener(() {
//   //     if (mounted) setState(() {});
//   //     if (cameraController.value.hasError) {
//   //       showInSnackBar(
//   //           'Camera error ${cameraController.value.errorDescription}');
//   //     }
//   //   });

//   //   try {
//   //     await cameraController.initialize();
//   //     // await Future.wait([
//   //     //   // The exposure mode is currently not supported on the web.
//   //     //   ...(!kIsWeb
//   //     //       ? [
//   //     //           cameraController
//   //     //               .getMinExposureOffset()
//   //     //               .then((value) => _minAvailableExposureOffset = value),
//   //     //           cameraController
//   //     //               .getMaxExposureOffset()
//   //     //               .then((value) => _maxAvailableExposureOffset = value)
//   //     //         ]
//   //     //       : []),
//   //     //   cameraController
//   //     //       .getMaxZoomLevel()
//   //     //       .then((value) => _maxAvailableZoom = value),
//   //     //   cameraController
//   //     //       .getMinZoomLevel()
//   //     //       .then((value) => _minAvailableZoom = value),
//   //     //]);
//   //   } on CameraException catch (e) {
//   //     _showCameraException(e);
//   //   }
//   //   if (mounted) {
//   //     setState(() {});
//   //   }
//   // }

//   // void _showCameraException(CameraException e) {
//   //   //logError(e.code, e.description);
//   //   showInSnackBar('Error: ${e.code}\n${e.description}');
//   // }

//   // @override
//   // void dispose() {
//   //   controller.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return Container(
//       //height: 100.h,
//       height: MediaQuery.of(context).size.height,
//       color: Colors.black,
//       child: Center(
//         child: Container(
//           //height: 90.h,
//           child: FutureBuilder(
//               future: cameraContent,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Container(
//                     color: Colors.black,
//                     height: MediaQuery.of(context).size.height,
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                       ),
//                     ),
//                   );
//                 }

//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Container(
//                     color: Colors.black,
//                     height: MediaQuery.of(context).size.height * 0.9,
//                     child: Center(
//                       child: CameraPreview(controller),
//                     ),
//                   );
//                 }

//                 return Container(
//                   color: Colors.black,
//                   height: MediaQuery.of(context).size.height,
//                   child: Center(
//                     child: Text('Camera'),
//                   ),
//                 );
//               }
//               //child: CameraPreview(controller)),
//               ),
//         ),
//       ),
//     );
//   }
// }
