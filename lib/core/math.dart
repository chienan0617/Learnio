import 'package:learnio/base.dart';

class Math {
  static final Random random = Random();

  static int nextInt(int v) {
    return random.nextInt(v);
  }

  static double nextDouble() {
    return random.nextDouble();
  }

  static bool nexBool() {
    return random.nextBool();
  }
}

class Vector2I {
  int x, y;

  Vector2I(this.x, this.y);

  Vector2I setI(Vector2I v) {
    x = v.x;
    y = v.y;
    return this;
  }

  Vector2I setF(Vector2F v) {
    x = v.x.toInt();
    y = v.y.toInt();
    return this;
  }

  Vector2I set(int x, int y) {
    this.x = x;
    this.y = y;
    return this;
  }

  int root() {
    return sqrt(x * x + y * y).toInt();
  }
}

class Vector2F {
  double x, y;

  Vector2F(this.x, this.y);

  Vector2F setF(Vector2F v) {
    x = v.x;
    y = v.y;
    return this;
  }

  Vector2F setI(Vector2I v) {
    x = v.x.toDouble();
    y = v.y.toDouble();
    return this;
  }

  Vector2F set(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }

  double root(double x, double y) {
    return sqrt(x * x + y * y);
  }
}

class Vector2<E> {
  E x;
  E y;

  Vector2(this.x, this.y);

  Vector2 set(Vector2 v) {
    x = v.x;
    y = v.y;
    return this;
  }

  Vector2 setV(E x, E y) {
    this.x = x;
    this.y = y;
    return this;
  }
}

typedef Pair<E> = Vector2<E>;
