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

// Temporary
//extension MKCoordinateRegion: Equatable {
//    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
//        lhs.center.latitude == rhs.center.latitude &&
//        lhs.center.longitude == rhs.center.longitude &&
//        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
//        lhs.span.longitudeDelta == rhs.span.longitudeDelta
//    }
//}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Data used to center the Map inside the UI.
    // When this changes, the Map changes accordingly.
    // If Location Permission is granted, the Map is centered on the User's position,
    // otherwise on the default position (PoliMi)
    @Published var region = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.span
    )
    
    @Published var message: String = ""
    
    // iOS's Location Manager
    @Published var locationManager: CLLocationManager = CLLocationManager()
    
    // @Published var location: CLLocationCoordinate2D?
    
    func customInitialize() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthorization()
    }
    
    // Reads the actual Permission and decides what to do
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // The User hasn't been asked for Permission yet. Asking now...
            locationManager.requestWhenInUseAuthorization()
        default:
            showMessage()
        }
    }
    
    func showMessage() {
        switch locationManager.authorizationStatus {
        case .restricted:
            // Permission Restricted: Something like Parental Controls or MDM doesn't allow it
            message = "La tua location è bloccata dal parental control.\nPuoi riprovare dopo che avrai finito la fase di login cliccando sul tasto a forma di ingranaggio nella pagina del profilo."
        case .denied:
            // The User has denied the Permission. Showing error...
            message = "Puoi sempre cambiare idea, dopo che avrai finito la fase di login, cliccando sul tasto a forma di ingranaggio nella pagina del profilo."
        case .authorizedAlways, .authorizedWhenInUse:
            // The User has granted one of the two levels of Permission. Both are ok.
            message = "Puoi cambiare la tua scelta, dopo che avrai finito la fase di login, cliccando sul tasto a forma di ingranaggio nella pagina del profilo."
        default:
            break
        }
    }
    
    // Delegated function: iOS will automatically call it when the User changes the app's Location Permission.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // The Location Authorization has changed (likely from the User, so it checks once again what changed
        checkLocationAuthorization()
    }
}
