import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    // The ViewModel, where the Data and Permission are handled.
    @ObservedObject var viewModel: MapViewModel
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var selection: MapFeature? = nil
    
    @Namespace private var mapNameSpace
    
    // The UI
    var body: some View {
        // The Map, centered around ViewModel's region, and showing the User's position when possible
        Map(
            initialPosition: mapCameraPosition, 
            bounds: MapCameraBounds(minimumDistance: 0.008, maximumDistance: .infinity), 
            interactionModes: .all, 
            selection: $selection, 
            scope: mapNameSpace) {
                // The User's position
                UserAnnotation()
                
                // All the Favors
                ForEach(database.favors) { favor in
                    Annotation(
                        coordinate: favor.location,
                        content: {
                            FavorMarker(favor: favor)
                        }, 
                        label: {
                            Label(favor.title, systemImage: favor.icon.icon)
                        }
                    )
                    .mapOverlayLevel(level: .aboveLabels)
                }
            }
            .mapControlVisibility(.visible)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .mapStyle(
                .standard(
                    elevation: .realistic, 
                    emphasis: .automatic, 
                    pointsOfInterest: .all, 
                    showsTraffic: false))
            .onAppear {
                // When the Map appears on-screen, check permissions and update location
                viewModel.checkIfLocationServicesIsEnabled()
            }
            .edgesIgnoringSafeArea(.bottom)
            .tint(.blue)
    }
}
