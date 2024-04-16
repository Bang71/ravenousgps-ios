//
//  ViewController.swift
//  ravenousgps
//
//  Created by 신병기 on 4/15/24.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    private var locationManager: CLLocationManager!
    private var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        initMap()
    }
    
    private func initMap() {
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withTarget: .seoul, zoom: 13.0)
        options.frame = self.view.bounds
        
        mapView = GMSMapView(options: options)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        self.view.addSubview(mapView)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 13.0)
            mapView.camera = camera
            locationManager.stopUpdatingLocation()
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard locationPermission() else {
            showLocationPermissionAlert()
            return false
        }
        return true
    }
}

extension ViewController {
    private func locationPermission() -> Bool {
        let authorizationStatus = CLLocationManager().authorizationStatus
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            return true
        default:
            return false
        }
    }
    
    private func showLocationPermissionAlert() {
        let alertController = UIAlertController(title: "위치 접근 권한 요청", message: "목적지 알림 사용하려면 위치 접근 권한이 필요합니다.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
