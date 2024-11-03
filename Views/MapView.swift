import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
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
    
    // Boolean value that is used to open and close the Favor Details sheet
    @State private var isShowingFavorsDetails = false
    // An Optional<Favor> used as a selector for a Favor: 
    // nil => no Favor selected
    // *something* => that Favor is selected
    @Binding var selectedFavor: Favor?
    // An Optional<FavorMarker> used as a buffer for the last selected Favor.
    // This is used to deselect the Favor once it's not selected anymore
    @State private var selectedFavorID: UUID? = nil
    
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
                            FavorMarker(favor: favor, isSelected: .constant(selectedFavorID == favor.id))
                                .onTapGesture {
                                    // Selects the Favor and triggers the showing of the sheet
                                    selectedFavor = favor
                                    selectedFavorID = favor.id
                                    isShowingFavorsDetails = true
                                }
                        }, 
                        label: {
                            //Label(favor.title, systemImage: favor.icon.icon)
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
