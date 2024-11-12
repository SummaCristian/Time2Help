import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) private var openURL
    
    // The ViewModel, where the Data and Permission are handled.
    @ObservedObject var viewModel: MapViewModel
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    // The MapCameraPosition used to center around the User's Location
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    // The list of Map Elements from Apple's MapKit database
    @State private var selection: MapFeature? = nil
    
    // A NameSpace needed for certain Map features
    @Namespace private var mapNameSpace
    
    // An Optional<Favor> used as a selector for a Favor:
    // nil => no Favor selected
    // *something* => that Favor is selected
    @Binding var selectedFavor: Favor?
    // An Optional<FavorMarker> used as a buffer for the last selected Favor.
    // This is used to deselect the Favor once it's not selected anymore
    @Binding var selectedFavorID: UUID?
    
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
                            FavorMarker(favor: favor, isSelected: .constant(selectedFavorID == favor.id), isInFavorSheet: false)
                                .onTapGesture {
                                    // Selects the Favor and triggers the showing of the sheet
                                    selectedFavor = favor
                                    selectedFavorID = favor.id
                                }
                        },
                        label: {}
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
            .edgesIgnoringSafeArea(.bottom)
            .tint(.blue)
            .blur(radius: viewModel.error ? 10 : 0)
            .disabled(viewModel.error)
            .overlay {
                if viewModel.error {
                    Rectangle()
                        .foregroundStyle(.black)
                        .opacity(0.2)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Text(viewModel.errorMessage)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                        
                        Button(action: {
                            let settingsString = UIApplication.openSettingsURLString
                            if let settingsURL = URL (string: settingsString) {
                                openURL(settingsURL)
                            }
                        }, label: {
                            Text("Vai alle impostazioni")
                                .bold()
                                .foregroundStyle(.blue)
                        })
                    }
                    .padding(.all, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                    )
                    .padding(.horizontal, 60)
                }
             }
    }
}
