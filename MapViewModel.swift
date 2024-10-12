import MapKit

// This file contains the whole logic necessary to handle the User's positioning on the Map,
// as well as the Location Permission's handling, like asking for it when it's not granted.

// Constants used to work with coordinates
enum MapDetails {
    // PoliMi's Coordinates
    static let startingLocation = CLLocationCoordinate2D(latitude: 45.478143,longitude: 9.228255)
    // Default Map zoom level
    static let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {    
    // Data used to center the Map inside the UI.
    // When this changes, the Map changes accordingly.
    // If Location Permission is granted, the Map is centered on the User's position,
    // otherwise on the default position (PoliMi)
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.span
    )
    
    // iOS's Location Manager    
    var locationManager: CLLocationManager?
    
    // Function that runs a rountine check of the Location Permission, and acts accordingly based
    // on the result
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            // Location Permission granted and GPS is ON
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            // Location Permission not granted or GPS is OFF
            print("Show an alert letting them know this is off and to go turn it on...")
            // TODO: Implement something in UI
        }
    }
    
    // Reads the actual Permission and decides what to do
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return }
        // Not showing error because nil cases are handled here
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                // The User hasn't been asked for Permission yet. Asking now...
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Permission Restricted: Something like Parental Controls or MDM doesn't allow it
                print("Your location is restricted likely due to parental controls")
                // TODO: Implement in UI
            case .denied:
                // The User has denied the Permission. Showing error...
                print("You have denied location permissions to this app. Go into Settings and change that")
                // TODO: Implement in UI
            case .authorizedAlways, .authorizedWhenInUse:
                // The User has granted one of the two levels of Permission. Both are ok.
                // Saving the User's position inside the region value, so that the Map can be centered on it.
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.span)
            @unknown default:
                break
        }
    }
    
    // Delegated function: iOS will automatically call it when the User changes the app's Location Permission.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // The Location Authorization has changed (likely from the User, so it checks once again what changed
        checkLocationAuthorization()
    }
}
