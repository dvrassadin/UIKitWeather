//
//  LocationService.swift
//  SimpleWeather
//
//  Created by Daniil Rassadin on 12/5/25.
//

import CoreLocation
import OSLog

@MainActor
final class LocationService: NSObject, @preconcurrency LocationServiceProtocol {
    static let shared = LocationService()
    
    // MARK: Properties
    
    private let locationManager = CLLocationManager()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "Location"
    )
    
    private var locationCompletion: ((CLLocation?) -> Void)?
    
    // MARK: Initialization
    
    override private init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: Public Methods
    
    func requestAuthorizationIfNeeded() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            logger.info("Requested location authorization")
        } else {
            logger.info("Location authorization status: \(String(describing: status.rawValue))")
        }
    }
    
    func requestCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        locationCompletion = completion
        locationManager.requestLocation()
        logger.info("Requested current location")
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationService: @preconcurrency CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            logger.info("Location access granted")
        case .denied, .restricted:
            logger.warning("Location access denied or restricted")
        case .notDetermined:
            break
        @unknown default:
            logger.error("Unknown location authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        if let location {
            logger.info("Current location: lat=\(location.coordinate.latitude), lon=\(location.coordinate.longitude)")
        } else {
            logger.warning("Received empty location array")
        }
        locationCompletion?(location)
        locationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Failed to get location: \(error.localizedDescription)")
        locationCompletion?(nil)
        locationCompletion = nil
    }
    
}
