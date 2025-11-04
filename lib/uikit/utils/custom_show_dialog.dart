import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';

Future<void> customShowDialog(
  BuildContext context, {
  Widget? body,
  String? title,
  String? description,
}) async => await showDialog(
  context: context,
  builder: (BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: context.sizeHeight(),
        width: context.sizeWidth(),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: context.sizeWidth(0.2),
          vertical: context.sizeHeight(0.2),
        ),
        color: Colors.black38,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.sizeWidth(0.1),
                vertical: context.sizeHeight(0.05),
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    title != null
                        ? Text(
                            title.toUpperCase(),
                            style: AppTypography.h3,
                            textAlign: TextAlign.center,
                          )
                        : Container(),

                    UIHelpers.verticalSpaceXL,
                    description != null
                        ? Text(
                            description,
                            style: AppTypography.bodyLarge,
                            textAlign: TextAlign.center,
                          )
                        : Container(),
                    body ?? Container(),
                  ],
                ),
              ),
            ),
            IconButton(onPressed: () => context.pop(), icon: Icon(Icons.close)),
          ],
        ),
      ),
    );
  },
);
