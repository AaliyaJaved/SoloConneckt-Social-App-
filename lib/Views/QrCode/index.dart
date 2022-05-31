import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var status=controller?.getFlashStatus();
    print("flash status");
    print(status);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildQrView(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () async {
                        await controller?.resumeCamera();
                      },
                      icon: Icon(Icons.center_focus_strong,
                          color: Theme.of(context).backgroundColor)),
                  Text(
                    "Scan profile",
                    style: ThemeHelper().TextStyleMethod2(18, context,
                        FontWeight.w600, Theme.of(context).backgroundColor),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.all(8),
                  //   child: ElevatedButton(
                  //       onPressed: () async {
                  //         await controller?.flipCamera();
                  //         setState(() {});
                  //       },
                  //       child: FutureBuilder(
                  //         future: controller?.getCameraInfo(),
                  //         builder: (context, snapshot) {
                  //           if (snapshot.data != null) {
                  //             return Text(
                  //                 'Camera facing ${describeEnum(snapshot.data!)}');
                  //           } else {
                  //             return const Text('loading');
                  //           }
                  //         },
                  //       )),
                  // ),
                  // InkWell(
                  //   onTap: () async {
                  //      await controller?.toggleFlash();
                  //           setState(() {});
                  //   },
                  //   child: FutureBuilder(
                  //     future: controller?.getFlashStatus(),
                  //     builder: (context) {
                  //       return Icon(Icons.flash_auto_outlined,color: Theme.of(context).backgroundColor);
                  //     }
                  //   )),
                  IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      icon: Icon(Icons.flash_auto_outlined,
                          color: Theme.of(context).backgroundColor)),
                ],
              ),
            ),
            // FittedBox(
            //   fit: BoxFit.contain,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: <Widget>[
            //       if (result != null)
            //         Text(
            //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
            //       else
            //         const Text('Scan a code'),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(8),
            //             child: ElevatedButton(
            //                 onPressed: () async {
            //                   await controller?.toggleFlash();
            //                   setState(() {});
            //                 },
            //                 child: FutureBuilder(
            //                   future: controller?.getFlashStatus(),
            //                   builder: (context, snapshot) {
            //                     return Text('Flash: ${snapshot.data}');
            //                   },
            //                 )),
            //           ),
            //           Container(
            //             margin: const EdgeInsets.all(8),
            //             child: ElevatedButton(
            //                 onPressed: () async {
            //                   await controller?.flipCamera();
            //                   setState(() {});
            //                 },
            //                 child: FutureBuilder(
            //                   future: controller?.getCameraInfo(),
            //                   builder: (context, snapshot) {
            //                     if (snapshot.data != null) {
            //                       return Text(
            //                           'Camera facing ${describeEnum(snapshot.data!)}');
            //                     } else {
            //                       return const Text('loading');
            //                     }
            //                   },
            //                 )),
            //           )
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: <Widget>[
            //           Container(
            //             margin: const EdgeInsets.all(8),
            //             child: ElevatedButton(
            //               onPressed: () async {
            //                 await controller?.pauseCamera();
            //               },
            //               child: const Text('pause',
            //                   style: TextStyle(fontSize: 20)),
            //             ),
            //           ),
            //           Container(
            //             margin: const EdgeInsets.all(8),
            //             child: ElevatedButton(
            //               onPressed: () async {
            //                 await controller?.resumeCamera();
            //               },
            //               child: const Text('resume',
            //                   style: TextStyle(fontSize: 20)),
            //             ),
            //           )
            //         ],
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).backgroundColor,
          // borderRadius: 10,
          borderLength: 50,
          borderWidth: 6,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
