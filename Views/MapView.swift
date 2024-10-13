import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    // The ViewModel, where the Data and Permission are handled.
    @ObservedObject var viewModel: MapViewModel
    
    // The UI
    var body: some View {
        // Bundling everything in a ZStack, so that a background blur effect can be applied behind the TabView
        ZStack {
            // The Map, centered around ViewModel's region, and showing the User's position when possible
            Map(coordinateRegion: $viewModel.region, interactionModes: [.all], showsUserLocation: true)
                .mapControlVisibility(.visible)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                    MapPitchToggle()
                }
                .onAppear {
                    // When the Map appears on-screen, the Permission is checked, the User's position is
                    // refreshed, and the Map is then centered on it.
                    viewModel.checkIfLocationServicesIsEnabled()
                }   
                .ignoresSafeArea()
                .mapStyle(.standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false))
            
            VStack {
                Spacer()
                VisualEffectBlurView()
                    .frame(height: 90)
                    .edgesIgnoringSafeArea(.bottom)
                    .contentShape(Rectangle())
                    .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
            }
            .ignoresSafeArea()
        }
    }
}

// Rectangle with semi-transparent and blurred background.
// Used to create a background effect to the TabView
struct VisualEffectBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // Nothing
    }
}
