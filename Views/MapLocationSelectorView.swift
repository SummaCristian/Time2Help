import SwiftUI
import MapKit

struct LocationSelector: View {
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: MapViewModel
    
    // The location selected by the User, nil if no selection has been made yet
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    
    // The newly created favor, whose location is being edited in here
    @ObservedObject var newFavor: Favor
    
    // The UI
    var body: some View {
        ZStack {
            // The MapReader is needed to intercept the User's tap inputs
            MapReader { reader in
                Map(
                    initialPosition: .automatic,
                    bounds: MapCameraBounds(minimumDistance: 500, maximumDistance: .infinity),
                    interactionModes: .all
                ) {
                    if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
                        // The User's Location
                        UserAnnotation()
                    }
                    
                    // The Favor's Marker
                    // Note: it's set in selectedLocation if possible, but if it's nil, it defaults to the Favor's old Location
                    Annotation("", coordinate: selectedLocation ?? newFavor.location) {
                        FavorMarker(favor: newFavor, isSelected: .constant(true), isInFavorSheet: true)
                    }
                }
                .mapControlVisibility(.visible)
                .mapControls {
                    if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
                        MapUserLocationButton()
                    }
                    MapCompass()
                    MapScaleView()
                    MapPitchToggle()
                }
                .safeAreaPadding(.top, 100)
                .safeAreaPadding(.leading, 5)
                .safeAreaPadding(.trailing, 10)
                .safeAreaPadding(.bottom, 80)
                .onTapGesture(perform: { screenCoord in
                    // Intercepted a tap made by the User
                    // Converts the tap position into Map's coordinates
                    let screenCoordUpdated = CGPoint(x: screenCoord.x - 5, y: screenCoord.y - 100)
                    let location = reader.convert(screenCoordUpdated, from: .local)
                    // Saves these coordinates as the new selectedLocation.
                    // This value is also used for the Favor Marker: it's now moved to this location
                    withAnimation(.easeInOut) {
                        selectedLocation = location
                    }
                })
            }
            
            // The Title bar
            VStack {
                //                VStack {
                // Some space at the top
                //                    Spacer()
                //                        .frame(height: 10)
                
                // The Text
                HStack(spacing: 8) {
                    Text("Clicca sulla mappa per selezionare un luogo")
                        .font(.headline)
                    
                    Spacer()
                    
                    FavorMarker(favor: newFavor, isSelected: .constant(false), isInFavorSheet: true)
                }
                .padding(.vertical, 25)
                .padding(.horizontal, 20)
                //                }
                .background(.ultraThinMaterial)
                
                Spacer()
            }
            
            // The bottom Buttons
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    // The Cancel Button
                    // This button does not save the newly selectedLocation
                    Button(action: {
                        // Doesn't save the Location inside the Favor (it's still the old value)
                        // Dismisses the sheet
                        dismiss()
                    }) {
                        Label("Annulla", systemImage: "xmark")
                            .font(.body.bold())
                            .foregroundStyle(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(.red, in: .capsule)
                    }
                    .shadow(radius: 10)
                    .hoverEffect(.highlight)
                    
                    // The Confirm Button
                    // This button saves the newly selectedLocation inside the Favor
                    Button(action: {
                        // Saves the Location inside the Favor if it's not nil
                        newFavor.location = selectedLocation ?? newFavor.location
                        // Dismisses the sheet
                        dismiss()
                    }) {
                        Label("Seleziona", systemImage: "checkmark")
                            .font(.body.bold())
                            .foregroundStyle(.white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(.green, in: .capsule)
                    }
                    .shadow(radius: 10)
                    .hoverEffect(.highlight)
                }
            }
            .padding(.all, 20)
        }
        .presentationDragIndicator(.hidden)
    }
}
