import 'dart:math';

const enableAudio = true;

final _r = Random();

bool randomBoolean(double odds) {
  return _r.nextDouble() < odds;
}

double randomDouble(double min, double max) {
  return min + _r.nextDouble() * (max - min);
}