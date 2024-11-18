import SwiftUI
import MapKit

struct NeighbourhoodSelector: View {
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    // The location selected by the User, nil if no selection has been made yet
    @Binding var selectedNeighbourhoodStructTemp: Neighbourhood
    @Binding var selectedNeighbourhoodStructTempTwo: Neighbourhood
    
    @State private var neighbourhoodsUpdated: [Neighbourhood] = Database.neighbourhoods
    
    @State private var camera: MapCameraPosition = MapCameraPosition.automatic
    
    @State private var showList: Bool = false
    
    // The UI
    var body: some View {
        ZStack {
            Map(
                position: $camera,
                bounds: MapCameraBounds(minimumDistance: 500, maximumDistance: .infinity),
                interactionModes: .all
            ) {
                // The User's Location
                UserAnnotation()
                
                // The Favor's Marker
                // Note: it's set in selectedLocation if possible, but if it's nil, it defaults to the Favor's old Location
                ForEach(neighbourhoodsUpdated) { neighbourhood in
                    Annotation("", coordinate: neighbourhood.location) {
                        NeighbourhoodMarker(isSelected: .constant(neighbourhood.id == selectedNeighbourhoodStructTempTwo.id), neighbourhood: neighbourhood)
                            .onTapGesture {
                                selectedNeighbourhoodStructTempTwo = neighbourhood
                                withAnimation(.spring(duration: 0.2)) {
                                    camera = MapCameraPosition.camera(.init(centerCoordinate: .init(latitude: neighbourhood.location.latitude, longitude: neighbourhood.location.longitude), distance: camera.camera?.distance ?? 7200))
                                }
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
            .onAppear {
                camera = MapCameraPosition.camera(.init(centerCoordinate: selectedNeighbourhoodStructTemp.location, distance: 3200))
            }
            .onMapCameraChange(frequency: .onEnd) { camera in
                let centerCoordinate = camera.camera.centerCoordinate
                neighbourhoodsUpdated = neighbourhoodsUpdated.sorted(by: {
                    let distanceZero = sqrt(pow(centerCoordinate.latitude - $0.location.latitude, 2) + pow(centerCoordinate.longitude - $0.location.longitude, 2))
                    let distanceOne = sqrt(pow(centerCoordinate.latitude - $1.location.latitude, 2) + pow(centerCoordinate.longitude - $1.location.longitude, 2))
                    
                    return distanceZero < distanceOne
                })
                let cameraDistance = camera.camera.distance
                let numberOfBigs = cameraDistance < 10000 ? 5 : cameraDistance < 15000 ? 3 : cameraDistance < 30000 ? 1 : 0
                for i in 0..<numberOfBigs {
                    if !neighbourhoodsUpdated[i].big {
                        neighbourhoodsUpdated[i].big = true
                    }
                }
                for j in numberOfBigs..<neighbourhoodsUpdated.count {
                    if neighbourhoodsUpdated[j].big {
                        neighbourhoodsUpdated[j].big = false
                    }
                }
                self.camera = MapCameraPosition.camera(.init(centerCoordinate: .init(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude), distance: camera.camera.distance))
            }
            .safeAreaPadding(.top, 110)
            .safeAreaPadding(.leading, 5)
            .safeAreaPadding(.trailing, 10)
            .safeAreaPadding(.bottom, 80)
            
            if showList {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
                    .safeAreaPadding(.top, 97)
                    .edgesIgnoringSafeArea(.bottom)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(Database.neighbourhoods) { neighbourhood in
                            Button {
                                selectedNeighbourhoodStructTempTwo = neighbourhood
                                withAnimation(.spring(duration: 0.2)) {
                                    camera = MapCameraPosition.camera(.init(centerCoordinate: .init(latitude: neighbourhood.location.latitude, longitude: neighbourhood.location.longitude), distance: camera.camera?.distance ?? 7200))
                                }
                                showList = false
                            } label: {
                                HStack {
                                    Text(neighbourhood.name)
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    
                                    Spacer()
                                }
                                .overlay(alignment: .trailing) {
                                    if neighbourhood.id == selectedNeighbourhoodStructTempTwo.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title2.bold())
                                            .foregroundStyle(.green)
                                    }
                                }
                                .padding(.all, 20)
                                .background(colorScheme == .dark ? Color(.systemGray6) : .white, in: .rect(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(.all, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colorScheme == .dark ? .black : Color(.systemGray6), in: .rect)
                .safeAreaPadding(.top, 97)
                .padding(.bottom, 90)
                
//                VStack {
//                    Spacer()
//
//
//                        .frame(height: 90)
//                        .ignoresSafeArea()
//                }
            }
            
            // The Title bar
            VStack {
//                VStack {
//                    // Some space at the top
//                    Spacer()
//                        .frame(height: 10)
                    
                    // The Text
                    HStack(spacing: 8) {
                        Text("Clicca sul marcatore per selezionare il tuo quartiere")
                            .font(.headline)
                        
                        Spacer()
                        
                        NeighbourhoodMarker(isSelected: .constant(false), neighbourhood: .init(name: "", location: .init(), big: true))
                            .padding(.bottom, -25)
                    }
                    .padding(.vertical, 25)
                    .padding(.horizontal, 20)
//                }
                .background(.ultraThinMaterial)
                
                Spacer()
            }
            
//            Text("\(altitude)")
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    Button {
                        showList.toggle()
                    } label: {
                        Image(systemName: showList ? "map.fill" : "magnifyingglass")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .padding(.all, 12)
                    }
                    .background(
                        Circle()
                            .foregroundStyle(.blue)
                    )
                }
                
                Spacer()
            }
            .safeAreaPadding(.top, 115)
            .safeAreaPadding(.trailing, showList ? 20 : 70)
            .animation(.spring(duration: 0.4), value: showList)
            
            // The bottom Buttons
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    // The Cancel Button
                    // This button does not save the newly selectedLocation
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            selectedNeighbourhoodStructTempTwo = selectedNeighbourhoodStructTemp
                        }
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
        .presentationDragIndicator(.hidden)
    }
}

struct Neighbourhood: Identifiable {
    var id: UUID = UUID()
    var name: String
    var location: CLLocationCoordinate2D
    var big: Bool
    
    init(name: String, location: CLLocationCoordinate2D) {
        self.name = name
        self.location = location
        self.big = false
    }
    
    init(name: String, location: CLLocationCoordinate2D, big: Bool) {
        self.name = name
        self.location = location
        self.big = big
    }
}
