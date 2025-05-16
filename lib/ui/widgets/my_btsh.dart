import 'package:flutter/material.dart';
import 'package:get/get.dart';

myBottomSheet(BuildContext context,
    {required Widget corpo,
    required Widget rodape,
    required String titulo,
    required IconData iconeCabecalho}) {
  return showModalBottomSheet(
    enableDrag: false,
    constraints: BoxConstraints(minWidth: context.width),
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Color(0xFFf2f2f7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    color: Color(0xFFd1d9f0),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            iconeCabecalho,
                            color: Color(0xFF3E4095),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(titulo,
                              style: context.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            corpo,
            rodape,
          ],
        ),
      );
    },
  );
}
