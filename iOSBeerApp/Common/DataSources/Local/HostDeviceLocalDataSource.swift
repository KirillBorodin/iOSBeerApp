//
//  HostDeviceLocalDataSource.swift
//  iOSBeerApp
//
//  Created by Kirill on 09.12.2024.
//

import Network
import os
import Foundation


class HostDeviceLocalDataSource {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isConnected = false
    private let logger = Logger(subsystem: "Common.DataSource", category: "HostDeviceLocalDataSource")
    
    
    init() {
        
        logger.info("Initializing network monitor...")
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let status = path.status == .satisfied
            self.isConnected = status
            if status {
                self.logger.info("Internet connection is available.")
            } else {
                self.logger.warning("Internet connection is unavailable.")
            }
        }
        monitor.start(queue: queue)
        logger.info("Network monitor started.")
    }
    
    func isInternetConnectionAvailable() -> Bool {
        logger.info("Checking internet connection status: \(self.isConnected ? "Connected" : "Not Connected")")
        return isConnected
    }
}
