import AppMetricaCore

final class AnalyticsService {
    static let shared = AnalyticsService()
    private let apiKey = "0dc05cba-05be-4173-a218-84d17ef076de"
    private var configuration: AppMetricaConfiguration?
    
    private init() { }
    
    func activateConfiguration() {
        configuration = AppMetricaConfiguration(apiKey: apiKey)
        guard let configuration else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func sendEvent(name: String, parameters: [AnyHashable: Any]) {
        guard let configuration else { return }
        print("[\(name)]: \(parameters)\n")
        AppMetrica.reportEvent(name: name,
                               parameters: parameters) { error in
            assertionFailure("REPORT ERROR: \(error.localizedDescription)")
        }
    }
}
