import SwiftUI
import MapKit

struct NeighbourhoodSelector: View {
    
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: MapViewModel
    
    // The location selected by the User, nil if no selection has been made yet
    @Binding var selectedNeighbourhoodStructTemp: Neighbourhood
    @Binding var selectedNeighbourhoodStructTempTwo: Neighbourhood
    
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    @AppStorage("showListNeighbourhood") private var showListNeighbourhood: Bool = false
    
    @State private var neighbourhoodsUpdated: [Neighbourhood] = Database.neighbourhoods
    
    // A NameSpace for certain Map features
    @Namespace private var mapNameSpace
    
    @State private var camera: MapCameraPosition = MapCameraPosition.automatic
    @State private var cameraSupport: MapCameraPosition = MapCameraPosition.automatic
    
    @State private var searchText: String = ""
    @FocusState private var searchFocused: Bool
    @State private var showCancel: Bool = false
    
    var searchResult: [Neighbourhood] {
        if !searchFocused && searchText.isEmpty {
            return Database.neighbourhoods
        } else if searchText.isEmpty {
            return []
        } else {
            return Database.neighbourhoods.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
    }
    
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
                .padding(.top, 170)
                .padding(.trailing, 15)
            }
            .onMapCameraChange(frequency: .continuous) { camera in
                self.cameraSupport = MapCameraPosition.camera(.init(centerCoordinate: camera.camera.centerCoordinate, distance: camera.camera.distance, heading: camera.camera.heading, pitch: camera.camera.pitch))
            }
            .mapScope(mapNameSpace)
            .animation(.easeInOut, value: camera)
            
            if showListNeighbourhood {
                ZStack {
                    if (searchText.isEmpty && searchFocused) || (!searchText.isEmpty && searchResult.isEmpty) {
                        VStack(spacing: 20) {
                            Image(systemName: searchText.isEmpty && searchFocused ? "keyboard" : "eyes")
                                .font(.system(size: 80))
                                .overlay(alignment: .topTrailing) {
                                    if !searchText.isEmpty && searchResult.isEmpty {
                                        Image(systemName: "questionmark")
                                            .font(.system(size: 30))
                                            .padding(.top, -10)
                                            .padding(.trailing, -16)
                                    }
                                }
                            
                            Text(searchText.isEmpty && searchFocused ? "Scrivi una lettera per iniziare a cercare" : "Nessun quartiere trovato")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(.gray)
                        .bold()
                        .padding(.all, 60)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    } else {
                        ScrollViewReader { reader in
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(searchResult) { neighbourhood in
                                        Button {
                                            selectedNeighbourhoodStructTempTwo = neighbourhood
                                            withAnimation(.spring(duration: 0.2)) {
                                                camera = MapCameraPosition.camera(.init(centerCoordinate: .init(latitude: neighbourhood.location.latitude, longitude: neighbourhood.location.longitude), distance: camera.camera?.distance ?? 7200))
                                            }
                                        } label: {
                                            HStack(spacing: 8) {
                                                Text(neighbourhood.name)
                                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                NeighbourhoodMarker(isSelected: .constant(true), neighbourhood: .init(name: "", location: .init(), big: false))
                                                    .scaleEffect(0.6)
                                                    .padding(.bottom, -15)
                                                    .opacity(neighbourhood.id == selectedNeighbourhoodStructTempTwo.id ? 1 : 0)
                                            }
                                            .padding(.vertical, -8)
                                            .padding(.leading, 8)
                                        }
                                        .padding(.all, 16)
                                        .background(colorScheme == .dark ? Color(.systemGray6) : .white, in: .rect(cornerRadius: 25))
                                        .id(neighbourhood.id)
                                    }
                                }
                                .padding(.all, 20)
                                .onAppear {
                                    reader.scrollTo(selectedNeighbourhoodStructTempTwo.id, anchor: .top)
                                }
                            }
                            .scrollDismissesKeyboard(.immediately)
                        }
                    }
                }
                .safeAreaPadding(.top, searchFocused ? 70 : 170)
                .safeAreaPadding(.bottom, 100)
                .background(.regularMaterial)
            }
            
            // The Title bar
            VStack {
                VStack(spacing: 0) {
                    if !searchFocused {
                        // The Text
                        HStack(spacing: 8) {
                            Text("Clicca " + (showListNeighbourhood ? "il nome" : "sul marcatore") + " per selezionare il tuo quartiere")
                                .font(.headline)
                            
                            Spacer()
                            
                            NeighbourhoodMarker(isSelected: .constant(false), neighbourhood: .init(name: "", location: .init(), big: true))
                                .padding(.bottom, -25)
                        }
                        .padding(.vertical, 25)
                        .padding(.horizontal, 20)
                        .frame(height: !searchFocused ? 100 : 0)
                        .opacity(!searchFocused ? 1 : 0)
                    }
                    
                    HStack(spacing: 12) {
                        if showListNeighbourhood {
                            ZStack(alignment: .trailing) {
                                Button {
                                    searchText = ""
                                    
                                    showCancel = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        searchFocused = false
                                    }
                                } label: {
                                    Text("Annulla")
                                }
                                .opacity(showCancel ? 1 : 0)
                                .scaleEffect(showCancel ? 1 : 0)
                                
                                HStack(spacing: 8) {
                                    TextField(text: $searchText) {
                                        Text("Cerca")
                                    }
                                    .focused($searchFocused)
                                    
                                    if !searchText.isEmpty {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title3)
                                            .foregroundStyle(.red, .red.opacity(0.2))
                                            .onTapGesture {
                                                searchText = ""
                                            }
                                    }
                                }
                                .frame(height: 45)
                                .padding(.leading, 16)
                                .padding(.trailing, 12)
                                .background(colorScheme == .dark ? Color(.systemGray6) : .white, in: .rect(cornerRadius: 12))
                                .padding(.trailing, searchFocused ? 70 : 0)
                            }
                            .padding(.trailing, 4)
                        } else {
                            Spacer()
                        }
                        
                        Button {
                            showListNeighbourhood.toggle()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                if !searchText.isEmpty {
                                    searchText = ""
                                }
                            }
                            
                            if searchFocused {
                                searchFocused = false
                            }
                            
                            if showCancel {
                                showCancel = false
                            }
                        } label: {
                            Image(systemName: showListNeighbourhood ? "map.fill" : "list.bullet")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .frame(width: 45, height: 45)
                        }
                        .background(
                            Circle()
                                .foregroundStyle(.blue)
                                .shadow(color: showListNeighbourhood ? .clear : .gray.opacity(0.4), radius: 6)
                        )
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 17.5)
                }
                .padding(.bottom, showListNeighbourhood ? 0 : -70)
                .background(.ultraThinMaterial)
                
                Spacer()
            }
        }
        .presentationDragIndicator(.hidden)
        .ignoresSafeArea(.keyboard)
        .overlay {
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
                            .padding(.vertical, searchFocused ? 12 : 15)
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
                            .padding(.vertical, searchFocused ? 12 : 15)
                            .frame(maxWidth: .infinity)
                            .background(selectedNeighbourhoodStructTempTwo.id == selectedNeighbourhoodStructTemp.id ? Color(.systemGray5) : .green, in: .capsule)
                    }
                    .shadow(radius: 10)
                    .disabled(selectedNeighbourhoodStructTempTwo.id == selectedNeighbourhoodStructTemp.id)
                    .hoverEffect(.highlight)
                }
                .padding([.top, .horizontal], 20)
                .padding(.bottom, searchFocused ? 8 : 20)
                .background(.ultraThinMaterial.opacity(showListNeighbourhood ? 0 : 1))
            }
        }
        .animation(.bouncy(duration: 0.4), value: searchFocused)
        .animation(.easeInOut(duration: 0.4), value: showListNeighbourhood)
        .animation(.bouncy(duration: 0.4), value: showCancel)
        .onChange(of: searchFocused) { _, new in
            if new {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showCancel = true
                }
            }
        }
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
