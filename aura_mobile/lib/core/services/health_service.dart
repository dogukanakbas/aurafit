class HealthService {
  Future<bool> requestPermissions() async {
    return true;
  }

  Future<int> fetchTodaySteps() async {
    return 8450;
  }
}
