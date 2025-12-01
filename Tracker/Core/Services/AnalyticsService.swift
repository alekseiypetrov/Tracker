import AppMetricaCore

final class AnalyticsService {
    static let apiKey = "0dc05cba-05be-4173-a218-84d17ef076de"
    
    static func activateConfiguration() {
        guard let configuration = AppMetricaConfiguration(apiKey: apiKey) else { return }
        AppMetrica.activate(with: configuration)
    }
    
    static func sendEvent(name: String, parameters: [AnyHashable: Any]) {
        print("[\(name)]: \(parameters)\n")
        AppMetrica.reportEvent(name: name,
                               parameters: parameters) { error in
            assertionFailure("REPORT ERROR: \(error.localizedDescription)")
        }
    }
}
