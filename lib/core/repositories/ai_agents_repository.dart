import 'package:tripora/core/services/ai_agents_service.dart';

class AIAgentRepository {
  final AIAgentService service;

  AIAgentRepository({required this.service});

  // -------------------------------
  // SUPERVISOR AGENT
  // -------------------------------

  Future<dynamic> planTrip(Map<String, dynamic> body) async {
    return await service.post("/supervisor/plan-trip", body);
  }

  Future<dynamic> planTripMobile(Map<String, dynamic> body) async {
    return await service.post("/supervisor/plan-trip/mobile", body);
  }

  Future<dynamic> supervisorChat(String message) async {
    return await service.post("/supervisor/chat", {"query": message});
  }

  Future<dynamic> getSupervisorCapabilities() async {
    return await service.get("/supervisor/capabilities");
  }

  // -------------------------------
  // RECOMMENDER AGENT
  // -------------------------------

  Future<dynamic> getRecommendations(Map<String, dynamic> body) async {
    return await service.post("/recommender/recommend", body);
  }

  Future<dynamic> loadPOIs(Map<String, dynamic> body) async {
    return await service.post("/recommender/load-pois", body);
  }

  Future<dynamic> getAvailableStates() async {
    return await service.get("/recommender/states");
  }

  Future<dynamic> getInterestCategories() async {
    return await service.get("/recommender/interest-categories");
  }

  // -------------------------------
  // PLANNER AGENT
  // -------------------------------

  Future<dynamic> selectCentroid(Map<String, dynamic> body) async {
    return await service.post("/planner/select-centroid", body);
  }

  Future<dynamic> calculateDistance(Map<String, dynamic> body) async {
    return await service.post("/planner/calculate-distance", body);
  }

  Future<dynamic> clusterPois(Map<String, dynamic> body) async {
    return await service.post("/planner/cluster-pois", body);
  }

  Future<dynamic> generateSequence(Map<String, dynamic> body) async {
    return await service.post("/planner/generate-sequence", body);
  }

  Future<dynamic> planItinerary(Map<String, dynamic> body) async {
    return await service.post("/planner/plan-itinerary", body);
  }

  Future<dynamic> getNearbyPois(String placeId) async {
    return await service.get("/planner/nearby-pois/$placeId");
  }

  // -------------------------------
  // SYSTEM
  // -------------------------------

  Future<dynamic> getRoot() async {
    return await service.get("/");
  }

  Future<dynamic> healthCheck() async {
    return await service.get("/health");
  }
}
