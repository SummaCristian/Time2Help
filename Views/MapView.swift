import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    // The ViewModel, where the Data and Permission are handled.
    @ObservedObject var viewModel: MapViewModel
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    @Namespace private var mapNameSpace
    
    // The UI
    var body: some View {
        // Bundling everything in a ZStack, so that a background blur effect can be applied behind the TabView
        ZStack {
            // The Map, centered around ViewModel's region, and showing the User's position when possible
            //Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true)
            Map(initialPosition: mapCameraPosition, bounds: MapCameraBounds(minimumDistance: 0.008, maximumDistance: .infinity), interactionModes: .all, scope: mapNameSpace) {
                UserAnnotation()
            }
            .mapControlVisibility(.visible)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .onAppear {
                // When the Map appears on-screen, check permissions and update location
                viewModel.checkIfLocationServicesIsEnabled()
            }
            .onChange(of: viewModel.region) { oldRegion, newRegion in
                mapCameraPosition = .region(viewModel.region)
            }
            .edgesIgnoringSafeArea(.bottom)
            .tint(.blue)
        }
    }
}
