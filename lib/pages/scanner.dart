import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:skursbiachle/services/get_pupil_id.dart';
import 'package:skursbiachle/widgets/qr_scanner_overlay.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  QrCodeScannerState createState() => QrCodeScannerState();
}

class QrCodeScannerState extends State<QrCodeScanner>
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
                        await controller.stop();
                        setState(() {
                          final data = getID(barcode.rawValue);
                          if (data is GetPupilID) {
                            result = Navigator.pushNamed(context, '/PupilCheck',
                                arguments: {
                                  'pupilID': data.pupilID,
                                });
                          } else if (data is KeyCreation) {
                            print('KEY');
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
}
