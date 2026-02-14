import 'package:flutter/material.dart';

double responsiveSize(BuildContext context, double base, {double min = 0, double max = double.infinity}) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  double factor = ((w + h) / 2) / 500;
  double value = base * factor;
  if (min > 0) value = value < min ? min : value;
  if (max < double.infinity) value = value > max ? max : value;
  return value;
}
