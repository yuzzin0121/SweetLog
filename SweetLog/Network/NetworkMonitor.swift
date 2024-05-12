//
//  NetworkMonitor.swift
//  SweetLog
//
//  Created by 조유진 on 5/13/24.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private init() { 
        monitor = NWPathMonitor()
    }
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
