import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // The ViewModel, where the Data and Permission are handled.
    @ObservedObject var viewModel: MapViewModel
    
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    // An Optional<Favor> used as a selector for a Favor:
    // nil => no Favor selected
    // *something* => that Favor is selected
    @Binding var selectedFavor: Favor?
    // An Optional<FavorMarker> used as a buffer for the last selected Favor.
    // This is used to deselect the Favor once it's not selected anymore
//    @Binding var selectedFavorID: UUID?
    
    let selectedNeighbourhood: String
    
    @Binding var user: User
    
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    @AppStorage("showList") private var showList: Bool = false
    
    // A NameSpace needed for certain Map features
    @Namespace private var mapNameSpace
    
    // The MapCameraPosition used to center around the User's Location
    @State private var camera: MapCameraPosition = MapCameraPosition.automatic
    @State private var cameraSupport: MapCameraPosition = MapCameraPosition.automatic
    
    // The list of Map Elements from Apple's MapKit database
    @State private var selection: MapFeature? = nil
    
    @StateObject private var filter: FilterModel = FilterModel()
    @State private var isAdvancedFiltersViewShowing: Bool = false
    
    @State private var showTitles: Bool = true
    
    @Binding var ongoingFavor: Favor?
    
    // The UI
    var body: some View {
        ZStack {
            // The Map, centered around ViewModel's region, and showing the User's position when possible
            Map(
                position: $camera,
                bounds: MapCameraBounds(minimumDistance: 0.008, maximumDistance: .infinity),
                interactionModes: .all,
                selection: $selection,
                scope: mapNameSpace
            ) {
                if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
                    // The User's position
                    UserAnnotation()
                        .mapOverlayLevel(level: .aboveRoads)
                }
                
                // All the Favors
                ForEach(database.favors.filter({ $0.neighbourhood == selectedNeighbourhood})) { favor in
                    if (
                        filter.isFavorIncluded(favor: favor)
                    ) {
                        if favor.type == .group {
                            MapCircle(center: favor.location, radius: 35)
                                .foregroundStyle(favor.category.color.opacity(0.2))
                                .stroke(favor.category.color, lineWidth: 3)
                                .mapOverlayLevel(level: .aboveRoads)
                        }
//
                        Annotation(
                            coordinate: favor.location,
                            content: {
                                FavorMarker(favor: favor, isSelected: .constant(selectedFavor?.id == favor.id), isInFavorSheet: showTitles, isOwner: user.id == favor.author.id)
                                    .onTapGesture {
                                        // Selects the Favor and triggers the showing of the sheet
                                        selectedFavor = favor
                                    }
                            },
                            label: {
                                // Label(favor.title, systemImage: favor.icon.icon)
                            }
                        )
                    }
                }
            }
            .mapControlVisibility(.hidden)
            .mapStyle(
                isSatelliteMode ? .hybrid(elevation: .realistic, pointsOfInterest: .all) : .standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)
            )
            
            
            if showList {
                ZStack {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                            .ignoresSafeArea()
                        
                        if database.favors.filter({ $0.neighbourhood == selectedNeighbourhood }).isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "eyes")
                                    .font(.system(size: 80))
                                    .overlay(alignment: .topTrailing) {
                                        Image(systemName: "questionmark")
                                            .font(.system(size: 30))
                                            .padding(.top, -10)
                                            .padding(.trailing, -16)
                                    }
                                
                                Text("Nessun favore trovato nel tuo quartiere")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundStyle(.gray)
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.all, 60)
                            .padding(.bottom, 105)
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(database.favors.filter({ $0.neighbourhood == selectedNeighbourhood })) { favor in
                                        if (
                                            filter.isFavorIncluded(favor: favor)
                                        ) {
                                            FavorListRow(favor: favor)
                                                .onTapGesture {
                                                    // Selects the Favor and triggers the showing of the sheet
                                                    selectedFavor = favor
//                                                    selectedFavorID = favor.id
                                                }
                                        }
                                    }
                                }
                                .padding(.vertical, 20)
                            }
                            .padding(.bottom, 85)
                        }
                    }
                    
                    VStack {
                        Rectangle()
                            .foregroundStyle(.ultraThinMaterial)
                            .ignoresSafeArea()
                            .frame(height: 0)
                        
                        Spacer()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .tint(.blue)
        .safeAreaPadding(.top, showList ? 150 : 85)
        .safeAreaPadding(.leading, 10)
        .safeAreaPadding(.trailing, 10)
        .safeAreaPadding(.bottom, 85)
        .sensoryFeedback(.selection, trigger: filter.selectedCategories)
        .sensoryFeedback(.impact, trigger: selection)
        .overlay {
            if !showList {
                VStack(spacing: 10) {
                    HStack(spacing: 0) {
                        Spacer()
                        
                        MapButtonsView(viewModel: viewModel, camera: $camera, cameraSupport: $cameraSupport, selectedCLLocationCoordinate: Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!.location, mapNameSpace: mapNameSpace)
                    }
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        MapCompass(scope: mapNameSpace)
                            .padding(.trailing, 3)
                    }
                    
                    Spacer()
                }
                .padding(.top, 140)
                .padding(.trailing, 15)
            }
        }
        .onMapCameraChange(frequency: .continuous) { camera in
            self.cameraSupport = MapCameraPosition.camera(.init(centerCoordinate: camera.camera.centerCoordinate, distance: camera.camera.distance, heading: camera.camera.heading, pitch: camera.camera.pitch))
            
            // Hides the FavorMarker's titles when zoomed out, and shows them when zoomed in enough
            withAnimation {
                showTitles = camera.camera.distance > 3000
            }
        }
        .mapScope(mapNameSpace)
        .animation(.easeInOut, value: camera)
        .overlay {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    MapListSelector(isListSelected: $showList)
                    
                    Spacer()
                    
//                    Button {
//                        withAnimation {
//                            showList.toggle()
//                        }
//                    } label: {
//                        Image(systemName: showList ? "map.fill" : "list.bullet")
//                            .font(.title3.bold())
//                            .foregroundStyle(.white)
//                            .frame(width: 45, height: 45)
//                    }
//                    .background(
//                        Circle()
//                            .foregroundStyle(.blue)
//                    )
                }
                
                Spacer()
            }
            .safeAreaPadding(.top, 20)
        }
        .overlay {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    if ongoingFavor != nil && !isAdvancedFiltersViewShowing {
                        OngoingFavorBoxView(favor: ongoingFavor!)
                            .shadow(radius: 3)
                            .onTapGesture {
                                selectedFavor = ongoingFavor
                            }
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal)
        }
        .overlay {
            VStack {
                CategoryFiltersView(filter: filter, isAdvancedFiltersViewShowing: $isAdvancedFiltersViewShowing)
            }
            .padding(.top, 78)
        }
        .onAppear {
            verifyLocationStatus()
            
            // Set endingDate (for filtering) to 23.59 today
            filter.endingDate = Calendar.current.startOfDay(for: filter.startingDate)
            filter.endingDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: filter.endingDate) ?? Calendar.current.startOfDay(for: filter.endingDate)
            
            ongoingFavor = database.favors.first(where: { $0.helpers.contains(where: { $0.id == user.id }) && $0.status == .ongoing })
        }
        .onChange(of: viewModel.locationManager.authorizationStatus) {
            verifyLocationStatus()
        }
    }
    
    func verifyLocationStatus() {
        // To avoid UserLocation button to not appear
        if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
            let coordinates = CLLocationCoordinate2D(latitude: Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!.location.latitude - 0.001, longitude: Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!.location.longitude)
            camera = MapCameraPosition.camera(.init(centerCoordinate: coordinates, distance: 3200))
//            camera = .userLocation(followsHeading: false, fallback: .automatic)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            camera = MapCameraPosition.camera(.init(centerCoordinate: Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!.location, distance: 3200))
        
            cameraSupport = camera
        }
    }
}
