import SwiftUI
import MapKit

struct LocationSelector: View {
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    
    // The location selected by the User, nil if no selection has been made yet
    @State private var selectedLocation: CLLocationCoordinate2D? = nil
    
    // The newly created favor, whose location is being edited in here
    @ObservedObject var newFavor: Favor
    
    // The UI
    var body: some View {
        ZStack {
            // The MapReader is needed to intercept the User's tap inputs
            MapReader {reader in
                Map(
                    initialPosition: .automatic,
                    bounds: MapCameraBounds(minimumDistance: 500, maximumDistance: .infinity),
                    interactionModes: .all
                ) {
                    // The User's Location
                    UserAnnotation()
                    
                    // The Favor's Marker
                    // Note: it's set in selectedLocation if possible, but if it's nil, it defaults to the Favor's old Location
                    Annotation("", coordinate: selectedLocation ?? newFavor.location){
                        FavorMarker(favor: newFavor)
                    }
                }
                .safeAreaPadding(.vertical, 65)
                .onTapGesture(perform: { screenCoord in
                    // Intercepted a tap made by the User
                    // Converts the tap position into Map's coordinates
                    let location = reader.convert(screenCoord, from: .local)
                    // Saves these coordinates as the new selectedLocation.
                    // This value is also used for the Favor Marker: it's now moved to this location
                    selectedLocation = location
                })
                
            }
            
            // The Title bar
            VStack {
                VStack {
                    // Some space at the top
                    Spacer()
                        .frame(height: 10)
                    
                    // The Text
                    HStack {
                        Spacer()
                        
                        Text("Clicca sulla mappa per selezionare un luogo")
                            .font(.headline)
                            .padding()
                        
                        Spacer()
                    }
                }
                .background(.ultraThinMaterial)
                
                Spacer()
            }
            
            // The bottom Buttons
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    // The Cancel Button
                    // This button does not save the newly selectedLocation
                    Button(action: {
                        // Doesn't save the Location inside the Favor (it's still the old value)
                        // Dismisses the sheet
                        dismiss()
                    }) {
                        Label("Annulla", systemImage: "xmark")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.red)
                    .shadow(radius: 10)
                    .hoverEffect(.highlight)
                    
                    Spacer()
                    
                    // The Confirm Button
                    // This button saves the newly selectedLocation inside the Favor
                    Button(action: {
                        // Saves the Location inside the Favor if it's not nil
                        newFavor.location = selectedLocation ?? newFavor.location
                        // Dismisses the sheet
                        dismiss()
                    }) {
                        Label("Seleziona", systemImage: "checkmark")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.green)
                    .shadow(radius: 10)
                    .hoverEffect(.highlight)
                    
                    Spacer()
                }
            }
            .padding(.vertical)
        }
        .presentationDragIndicator(.visible)
    }
}
