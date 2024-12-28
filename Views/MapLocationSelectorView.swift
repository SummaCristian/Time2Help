import SwiftUI
import MapKit

struct LocationSelector: View {
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: MapViewModel
    
    // The location selected by the User, nil if no selection has been made yet
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    
    // The newly created favor, whose location is being edited in here
    @ObservedObject var newFavor: Favor
    
    // A NameSpace needed for certain Map features
    @Namespace private var mapNameSpace
    
    // The MapCameraPosition used to center around the User's Location
    @State private var camera: MapCameraPosition = MapCameraPosition.automatic
    @State private var cameraSupport: MapCameraPosition = MapCameraPosition.automatic
    
    // The UI
    var body: some View {
        ZStack {
            // The MapReader is needed to intercept the User's tap inputs
            MapReader { reader in
                Map(
                    position: $camera,
                    bounds: MapCameraBounds(minimumDistance: 500, maximumDistance: .infinity),
                    interactionModes: .all,
                    scope: mapNameSpace
                ) {
                    if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
                        // The User's Location
                        UserAnnotation()
                    }
                    
                    // The Favor's Marker
                    // Note: it's set in selectedLocation if possible, but if it's nil, it defaults to the Favor's old Location
                    Annotation("", coordinate: selectedLocation ?? newFavor.location) {
                        FavorMarker(favor: newFavor, isSelected: .constant(true), isInFavorSheet: true, isOwner: true)
                    }
                }
                .mapControlVisibility(.visible)
                .mapControls {
                    MapScaleView()
                }
                .mapStyle(
                    isSatelliteMode ? .hybrid(elevation: .realistic, pointsOfInterest: .all) : .standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)
                )
                .safeAreaPadding(.top, 105)
                .safeAreaPadding(.leading, 5)
                .safeAreaPadding(.trailing, 10)
                .safeAreaPadding(.bottom, 80)
                .overlay {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Spacer()
                            
                            MapButtonsView(viewModel: viewModel, camera: $camera, cameraSupport: $cameraSupport, selectedCLLocationCoordinate: selectedLocation ?? newFavor.location, mapNameSpace: mapNameSpace)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 105)
                    .padding(.trailing, 10)
                }
                .onMapCameraChange(frequency: .continuous) { camera in
                    self.cameraSupport = MapCameraPosition.camera(.init(centerCoordinate: camera.camera.centerCoordinate, distance: camera.camera.distance, heading: camera.camera.heading, pitch: camera.camera.pitch))
                }
                .mapScope(mapNameSpace)
                .animation(.easeInOut, value: camera)
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
                // The Text
                HStack(spacing: 8) {
                    Text("Clicca sulla mappa per selezionare un luogo")
                        .font(.headline)
                    
                    Spacer()
                    
                    FavorMarker(favor: newFavor, isSelected: .constant(false), isInFavorSheet: true, isOwner: true)
                }
                .padding(.vertical, 25)
                .padding(.horizontal, 20)
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
                    .disabled(selectedLocation == nil)
                    .hoverEffect(.highlight)
                }
            }
            .padding(.all, 20)
        }
        .presentationDragIndicator(.hidden)
    }
}
