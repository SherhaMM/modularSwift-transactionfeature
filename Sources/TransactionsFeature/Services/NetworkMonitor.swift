import Foundation
import Network
import Combine

public protocol NetworkMonitoring {
    var networkStatusPublisher: Published<Bool>.Publisher { get }
}

final public class NetworkMonitor: NetworkMonitoring {
    @Published var networkStatus: Bool = false
    
    public var networkStatusPublisher: Published<Bool>.Publisher { $networkStatus }
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    public init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.networkStatus = true
            } else {
                self?.networkStatus = false
            }
        }
        monitor.start(queue: queue)
    }
}
