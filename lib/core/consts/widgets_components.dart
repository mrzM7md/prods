import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prods/core/consts/style_components.dart';

import 'app_colors.dart';

TextFormField getAppTextField({
  required String text,
  required Function(dynamic value) onChange,
  required validator,
  required TextEditingController controller,
  required Color fillColor,
  required bool obscureText,
  required TextDirection? direction,
  ValueChanged? onSubmitted,
  TextInputType? inputType,
  bool readOnly = false,
  List<TextInputFormatter>? inputFormatters,
  required Widget? suffixIconButton,
}) =>
    TextFormField(
      textAlign: TextAlign.start,
      onChanged: (value) => onChange(value),
      controller: controller,
      textDirection: direction,
      style: getGlobalTextStyle(),
      obscureText: obscureText,
      keyboardType: inputType,
      validator: validator,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      // mouseCursor: MouseCursor.defer,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        // hintText: "",
        labelText: text,
        hintTextDirection: direction,
        suffixIcon: suffixIconButton,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        filled: true,
        fillColor: fillColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(19)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: fillColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: fillColor),
        ),
      ),
    );

Widget getAppButton(
        {required Color color,
        required Color textColor,
        required String text,
        required onClick,
        IconData? icon}) =>
    Row(
      children: [
        MaterialButton(
          onPressed: onClick,
          elevation: 0,
          color: color,
          height: 46,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
          child: ConditionalBuilder(
            condition: icon == null,
            builder: (context) => Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            fallback: (context) {
              return Row(
                children: [
                  Icon(
                    icon,
                    color: textColor,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );

class ShowCustomMessage {
  void showCustomToast({
    required BuildContext context,
    required String message,
    required Color bkgColor,
    required Color textColor,
  }) {
    late OverlayEntry overlayEntry;
    bool isRemoved = false;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: bkgColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    isRemoved = true;
                    overlayEntry.remove();
                  }, icon: const Icon(Icons.close)),
                  Text(
                    message,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      if(!isRemoved){
        overlayEntry.remove();
      }
    });
  }
}


void showDeleteConfirmationMessage(BuildContext context, Color bkgColor,
  String title, String description, Function onClick, {String buttonTitle = "حذف"}) {
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        const ModalBarrier(
          dismissible: false, // منع إغلاق النافذة بالنقر خارجها
          color: Colors.black54, // لون الخلفية الشفافة
        ),
        Positioned(
          top: 200.0,
          left: MediaQuery.of(context).size.width * 0.2,
          width: MediaQuery.of(context).size.width / 2,
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: bkgColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        overlayEntry.remove();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.sizeOf(context).width <= 400 ? 14 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.sizeOf(context).width <= 400 ? 12 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getAppButton(
                      color: AppColors.appRedColor,
                      textColor: Colors.white,
                      text: buttonTitle,
                      onClick: () {
                        overlayEntry.remove();
                        onClick();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // إدراج الـ OverlayEntry بعد إنشائه
  Overlay.of(context).insert(overlayEntry);
}

OverlayEntry showAddOnFieldMessage(
    Function(dynamic value) onChange,
    Function(dynamic value) validator,
    GlobalKey<FormState> key,
    BuildContext context,
    Color bkgColor,
    String title,
    String description,
    Function onClick,
    TextEditingController controller) {
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        const ModalBarrier(
          dismissible: false, // منع إغلاق النافذة بالنقر خارجها
          color: Colors.black54, // لون الخلفية الشفافة
        ),
        Positioned(
          top: 200.0,
          left: MediaQuery.of(context).size.width * 0.2,
          width: MediaQuery.of(context).size.width / 2,
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: bkgColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        overlayEntry.remove();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.sizeOf(context).width <= 400 ? 14 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.sizeOf(context).width <= 400 ? 12 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Form(
                        key: key,
                        child: getAppTextField(
                          text: "أدخل قيمة",
                          onChange: onChange,
                          validator: validator,
                          controller: controller,
                          fillColor: AppColors.appGrey,
                          onSubmitted:(value) => onClick(),
                          obscureText: false,
                          direction: TextDirection.ltr,
                          suffixIconButton: null,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    getAppButton(
                      color: AppColors.appGreenColor,
                      textColor: Colors.white,
                      text: "موافق",
                      onClick: onClick,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // إدراج الـ OverlayEntry بعد إنشائه
  Overlay.of(context).insert(overlayEntry);
  return overlayEntry;
}

Widget getAppProgress() => Container(
    alignment: Alignment.center,
    height: 40,
    width: 40,
    child: const CircularProgressIndicator(
      color: Colors.blueAccent,
    ));

DataColumn getAppDataColumn(String text) => DataColumn(
    headingRowAlignment: MainAxisAlignment.center,
    label: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)));

DataCell getAppDataCell(String text) => DataCell(Align(
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    )));
