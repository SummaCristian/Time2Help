import SwiftUI
import MapKit

struct NeighbourhoodSelector: View {
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: MapViewModel
    
    // The location selected by the User, nil if no selection has been made yet
    @Binding var selectedNeighbourhoodStructTemp: Neighbourhood
    @Binding var selectedNeighbourhoodStructTempTwo: Neighbourhood
    
    @State private var neighbourhoodsUpdated: [Neighbourhood] = Database.neighbourhoods
    
    // A NameSpace for certain Map features
    @Namespace private var mapNameSpace
    
    @State private var camera: MapCameraPosition = MapCameraPosition.automatic
    @State private var cameraSupport: MapCameraPosition = MapCameraPosition.automatic
    
    @State private var showList: Bool = false
    
    // The UI
    var body: some View {
        ZStack {
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
                MapScaleView()
            }
            .mapStyle(
                isSatelliteMode ? .hybrid(elevation: .realistic, pointsOfInterest: .all) :
                .standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)
            )
            .onAppear {
                camera = MapCameraPosition.camera(.init(centerCoordinate: selectedNeighbourhoodStructTempTwo.location, distance: 3200))
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
            }
            .safeAreaPadding(.top, 115)
            .safeAreaPadding(.leading, 5)
            .safeAreaPadding(.trailing, 10)
            .safeAreaPadding(.bottom, 80)
            .overlay {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        
                        MapButtonsView(viewModel: viewModel, camera: $camera, cameraSupport: $cameraSupport, selectedCLLocationCoordinate: selectedNeighbourhoodStructTempTwo.location, mapNameSpace: mapNameSpace)
                    }
                    
                    Spacer()
                }
                .padding(.top, 115)
                .padding(.trailing, 10)
            }
            .onMapCameraChange(frequency: .continuous) { camera in
                self.cameraSupport = MapCameraPosition.camera(.init(centerCoordinate: camera.camera.centerCoordinate, distance: camera.camera.distance, heading: camera.camera.heading, pitch: camera.camera.pitch))
            }
            .mapScope(mapNameSpace)
            .animation(.easeInOut, value: camera)
            
            if showList {
                List {
                    ForEach(Database.neighbourhoods) { neighbourhood in
                        Button {
                            selectedNeighbourhoodStructTempTwo = neighbourhood
                            withAnimation(.spring(duration: 0.2)) {
                                camera = MapCameraPosition.camera(.init(centerCoordinate: .init(latitude: neighbourhood.location.latitude, longitude: neighbourhood.location.longitude), distance: camera.camera?.distance ?? 7200))
                            }
                            showList = false
                        } label: {
                            HStack(spacing: 8) {
                                Text(neighbourhood.name)
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if neighbourhood.id == selectedNeighbourhoodStructTempTwo.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title2.bold())
                                        .foregroundStyle(.green)
                                }
                            }
                            .padding(.all, 8)
                        }
                    }
                }
                .safeAreaPadding(.top, 105)
                .safeAreaPadding(.bottom, 100)
                
                Rectangle()
                    .foregroundStyle(.thinMaterial)
                    .frame(height: 130)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            // The Title bar
            VStack {
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
                        Image(systemName: showList ? "map.fill" : "list.dash")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                    }
                    .background(
                        Circle()
                            .foregroundStyle(.blue)
                    )
                }
                
                Spacer()
            }
            .safeAreaPadding(.top, 115)
            .safeAreaPadding(.trailing, showList ? 10 : 70)
            .animation(.easeInOut(duration: 0.4), value: showList)
            
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
                    .disabled(selectedNeighbourhoodStructTempTwo.id == selectedNeighbourhoodStructTemp.id)
                    .hoverEffect(.highlight)
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
