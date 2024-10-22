import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    // The ViewModel, where the Data and Permission are handled.
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var database: Database
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    @State private var selection: MapFeature? = nil
    @Namespace private var mapNameSpace
    
    // The UI
    var body: some View {
        // Bundling everything in a ZStack, so that a background blur effect can be applied behind the TabView
        ZStack {
            // The Map, centered around ViewModel's region, and showing the User's position when possible
            Map(initialPosition: mapCameraPosition, bounds: MapCameraBounds(minimumDistance: 0.008, maximumDistance: .infinity), interactionModes: .all, selection: $selection, scope: mapNameSpace) {
                UserAnnotation()
                
                ForEach(database.favors) { favor in
                    Marker(favor.title, systemImage: favor.icon.icon, coordinate: favor.location)
                        .tint(favor.color.color)
                        .stroke(lineWidth: 5)
                }
            }
            .mapControlVisibility(.visible)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .mapStyle(.standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)    )
            .onAppear {
                // When the Map appears on-screen, check permissions and update location
                viewModel.checkIfLocationServicesIsEnabled()
            }
            /*.onChange(of: viewModel.region) { oldRegion, newRegion in
             mapCameraPosition = .region(viewModel.region)
             }*/
            .edgesIgnoringSafeArea(.bottom)
            .tint(.blue)
        }
    }
}
