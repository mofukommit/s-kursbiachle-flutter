import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:skursbiachle/model/teacher.dart';

import 'package:skursbiachle/services/scan_qr_get_data.dart';
import 'package:skursbiachle/widgets/qr_scanner_overlay.dart';

import '../database/teacher_database.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  ScannerState createState() => ScannerState();
}

class ScannerState extends State<Scanner>
    with SingleTickerProviderStateMixin, RouteAware {
  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
    facing: CameraFacing.back,
  );

  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.kommit,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            'Scan!',
            overflow: TextOverflow.fade,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                  controller: controller,
                  allowDuplicates: true,
                  onDetect: (barcode, args) async {
                    dynamic result;
                    if (this.barcode != barcode.rawValue) {
                      this.barcode = barcode.rawValue;
                      try {
                        final data = await getID(barcode.rawValue);
                        await controller.stop();
                        setState(() {
                          if (data is GetPupilID) {
                            result = Navigator.pushNamed(context, '/pupilCheck',
                                arguments: {
                                  'pupilID': data.pupilID,
                                });
                          } else if (data is KeyCreation) {
                            // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                            // print(data.url);
                            writeKeys(data.costumerKey, data.costumerSec, data.url);
                            result = Navigator.pushNamed(context, '/authorized');
                          } else {
                            if (data is ErrorNEW) {
                              print('${data.msg}, ${data.code}');
                            }
                          }
                        });
                      } on Exception catch (e) {
                        print(e);
                      }
                      print('${await result} #######################################');
                      if (await result == true) {
                        controller.start();
                        isStarted = false;
                        this.barcode = null;
                      }
                    }
                  }),
              QRScannerOverlay(
                overlayColor: Colors.black.withOpacity(0.5),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 100,
                      color: Colors.black.withOpacity(0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            color: Colors.white,
                            icon: ValueListenableBuilder(
                              valueListenable: controller.cameraFacingState,
                              builder: (context, state, child) {
                                if (state == null) {
                                  return const Icon(Icons.camera_front);
                                }
                                switch (state as CameraFacing) {
                                  case CameraFacing.front:
                                    return const Icon(Icons.camera_front);
                                  case CameraFacing.back:
                                    return const Icon(Icons.camera_rear);
                                }
                              },
                            ),
                            iconSize: 32.0,
                            onPressed: () => controller.switchCamera(),
                          ),
                          Center(
                            child: IconButton(
                              color: Colors.white,
                              icon: isStarted
                                  ? const Icon(Icons.stop)
                                  : const Icon(Icons.play_arrow),
                              iconSize: 32.0,
                              onPressed: () => setState(() {
                                isStarted ? controller.stop() : controller.start();
                                isStarted = !isStarted;
                              }),
                            ),
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: ValueListenableBuilder(
                              valueListenable: controller.torchState,
                              builder: (context, state, child) {
                                if (state == null) {
                                  return const Icon(
                                    Icons.flash_off,
                                    color: Colors.grey,
                                  );
                                }
                                switch (state as TorchState) {
                                  case TorchState.off:
                                    return const Icon(
                                      Icons.flash_off,
                                      color: Colors.grey,
                                    );
                                  case TorchState.on:
                                    return const Icon(
                                      Icons.flash_on,
                                      color: Colors.yellow,
                                    );
                                }
                              },
                            ),
                            iconSize: 32.0,
                            onPressed: () => controller.toggleTorch(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future writeKeys(costumerKey, costumerSec, url) async {
    final key = KeyDB(
      id: 1,
      costumerKey: costumerKey,
      costumerSec: costumerSec,
      url: url
    );

    await KeyDatabase.instance.create(key);
  }
}

