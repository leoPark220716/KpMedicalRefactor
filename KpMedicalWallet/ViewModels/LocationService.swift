import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var currentLocation: CLLocationCoordinate2D?
    var address: String?
    @Published var address_Naver: String?
    var latitude: String?
    var longitude: String?
    var isAuthorized: Bool = false
    private let Navergeo = NaverGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    func getRequestPermission(){
        print("✅request")
        locationManager.requestWhenInUseAuthorization() // 위치 서비스 사용 동의 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                print("Location services are not authorized")
            @unknown default:
                print("Unknown authorization status")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            locationManager.startUpdatingLocation() // 위치 업데이트 시작
        case .notDetermined, .restricted, .denied:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }
    
    // CLLocationManagerDelegate 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location.coordinate // 현재 위치 업데이트
        self.longitude = String(location.coordinate.longitude)
        self.latitude = String(location.coordinate.latitude)
        self.lookupAddress(location: location)
        self.Navergeo.callNaverAddress(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude) { address in
            DispatchQueue.main.async {
                self.address_Naver = address
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
    func lookupAddress(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error getting address: \(error)")
                return
            }
            if let firstPlacemark = placemarks?.first {
                self.address = firstPlacemark.detailedAddress
            }
        }
    }
}
extension CLPlacemark {
    // 편리한 주소 형식으로 변환
    var detailedAddress: String? {
        var components: [String] = []
        
        if let subThoroughfare = subThoroughfare {
            components.append(subThoroughfare) // 번지
        }
        if let thoroughfare = thoroughfare {
            components.append(thoroughfare) // 거리
        }
        if let locality = locality {
            components.append(locality) // 도시
        }
        if let subAdministrativeArea = subAdministrativeArea {
            components.append(subAdministrativeArea) // 시나 군
        }
        if let administrativeArea = administrativeArea {
            components.append(administrativeArea) // 주나 도
        }
        if let postalCode = postalCode {
            components.append(postalCode) // 우편번호
        }
        if let country = country {
            components.append(country) // 국가
        }
        
        return components.joined(separator: ", ")
    }
}
