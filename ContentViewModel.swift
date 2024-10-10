import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 45.478143,longitude: 9.228255)
    static let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {    
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.span
    )
    
    private let span = 0.008
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Show an alert letting them know this is off and to go turn it on...")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return }
        // Not showing error because nil cases are handled here
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted likely due to parental controls")
            case .denied:
                print("You have denied location permissions to this app. Go into Settings and change that")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.span)
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // The Location Authorization has changed (likely from the User, so it checks once again what changed
        checkLocationAuthorization()
    }
}
