//
//  Helper.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import Foundation
import Alamofire

class NetworkReachability {
    static let shared = NetworkReachability()
    private let reachabilityManager = NetworkReachabilityManager()

    private init() {
        startListening()
    }

    private func startListening() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                print("Network is reachable")
            case .notReachable:
                print("Network is not reachable")
            case .unknown:
                print("Network status is unknown")
            }
        })
    }

    func isConnected() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
}
