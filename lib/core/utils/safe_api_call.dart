
Future<T> safeCall<T>(Future<T> Function() call, T fallback) async {
  try {
    return await call();
  } catch (e) {
    print("⚠️ Dashboard API failed: $e");
    return fallback;
  }
}
