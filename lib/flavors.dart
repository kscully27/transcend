enum Flavor {
  dev,
  stage,
  prod,
}

class AppFlavor {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Trancend Dev';
      case Flavor.stage:
        return 'Trancend Stage';
      case Flavor.prod:
        return 'Trancend';
      default:
        return 'Trancend';
    }
  }
}