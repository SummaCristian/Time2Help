import SwiftUI
import MapKit

struct NeighbourhoodSelector: View {
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    // The location selected by the User, nil if no selection has been made yet
    @Binding var selectedNeighbourhoodStructTemp: Neighbourhood
    @Binding var selectedNeighbourhoodStructTempTwo: Neighbourhood
    
    // The newly created favor, whose location is being edited in here
    //    @ObservedObject var newFavor: Favor
    
    // The UI
    var body: some View {
        ZStack {
            // The MapReader is needed to intercept the User's tap inputs
            MapReader { reader in
                Map(
                    initialPosition: MapCameraPosition.camera(.init(centerCoordinate: selectedNeighbourhoodStructTemp.location, distance: 3200)),
                    bounds: MapCameraBounds(minimumDistance: 500, maximumDistance: .infinity),
                    interactionModes: .all
                ) {
                    // The User's Location
                    UserAnnotation()
                    
                    // The Favor's Marker
                    // Note: it's set in selectedLocation if possible, but if it's nil, it defaults to the Favor's old Location
                    ForEach(Database.neighbourhoods) { neighbourhood in
                        Annotation("", coordinate: neighbourhood.location) {
                            NeighbourhoodMarker(isSelected: .constant(neighbourhood.id == selectedNeighbourhoodStructTempTwo.id), neighbourhood: neighbourhood)
                                .onTapGesture {
                                    selectedNeighbourhoodStructTempTwo = neighbourhood
                                }
                        }
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
                        pointsOfInterest: .excludingAll
                    )
                )
                .safeAreaPadding(.top, 110)
                .safeAreaPadding(.leading, 5)
                .safeAreaPadding(.trailing, 10)
                .safeAreaPadding(.bottom, 80)
            }
            
            // The Title bar
            VStack {
                VStack {
                    // Some space at the top
                    Spacer()
                        .frame(height: 10)
                    
                    // The Text
                    HStack(spacing: 8) {
                        Text("Clicca sul marcatore per selezionare il tuo quartiere")
                            .font(.headline)
                        
                        
                        Spacer()
                        
                        NeighbourhoodMarker(isSelected: .constant(false), neighbourhood: .init(name: "", location: .init()))
                            .padding(.bottom, -20)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                }
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
                        selectedNeighbourhoodStructTempTwo = selectedNeighbourhoodStructTemp
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
                        selectedNeighbourhoodStructTemp = selectedNeighbourhoodStructTempTwo
                        // Dismisses the sheet
                        dismiss()
                    }) {
                        Label("Seleziona", systemImage: "checkmark")
                            .font(.body.bold())
                            .foregroundStyle(selectedNeighbourhoodStructTempTwo.id == selectedNeighbourhoodStructTemp.id ? .gray : .white)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(selectedNeighbourhoodStructTempTwo.id == selectedNeighbourhoodStructTemp.id ? Color(.systemGray5) : .green, in: .capsule)
                    }
                    .shadow(radius: 10)
                    .hoverEffect(.highlight)
                    .disabled(selectedNeighbourhoodStructTempTwo.id == selectedNeighbourhoodStructTemp.id)
                }
            }
            .padding(.all, 20)
        }
        .presentationDragIndicator(.visible)
    }
}

struct Neighbourhood: Identifiable {
    var id: UUID = UUID()
    var name: String
    var location: CLLocationCoordinate2D
    
    init(name: String, location: CLLocationCoordinate2D) {
        self.name = name
        self.location = location
    }
}
