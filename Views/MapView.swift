import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isSatelliteMode: Bool
    
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
    @Binding var selectedFavorID: UUID?
    
    let selectedNeighbourhood: String
    
    @Binding var user: User
    
    // A NameSpace needed for certain Map features
    @Namespace private var mapNameSpace
    
    // The MapCameraPosition used to center around the User's Location
    @State private var camera: MapCameraPosition = MapCameraPosition.automatic
    @State private var cameraSupport: MapCameraPosition = MapCameraPosition.automatic
    
    // The list of Map Elements from Apple's MapKit database
    @State private var selection: MapFeature? = nil
    
    @StateObject private var filter: FilterModel = FilterModel()
        
    // The UI
    var body: some View {
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
                    if favor.type == .publicFavor {
                        MapCircle(center: favor.location, radius: 35)
                            .foregroundStyle(favor.category.color.opacity(0.2))
                            .stroke(favor.category.color, lineWidth: 3)
                            .mapOverlayLevel(level: .aboveRoads)
                    }
                    
                    Annotation(
                        coordinate: favor.location,
                        content: {
                            FavorMarker(favor: favor, isSelected: .constant(selectedFavorID == favor.id), isInFavorSheet: false, isOwner: user.id == favor.author.id)
                                .onTapGesture {
                                    // Selects the Favor and triggers the showing of the sheet
                                    selectedFavor = favor
                                    selectedFavorID = favor.id
                                }
                        },
                        label: {
                            //Label(favor.title, systemImage: favor.icon.icon)
                        }
                    )
                }
                    
            }
        }
        .mapControlVisibility(.visible)
        .mapControls {
            MapScaleView()
        }
        .mapStyle(
            isSatelliteMode ? .hybrid(elevation: .realistic, pointsOfInterest: .all) : .standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)
        )
        .edgesIgnoringSafeArea(.bottom)
        .tint(.blue)
        .safeAreaPadding(.top, 80)
        .safeAreaPadding(.leading, 5)
        .safeAreaPadding(.trailing, 10)
        .safeAreaPadding(.bottom, 80)
        .overlay {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    
                    MapButtonsView(viewModel: viewModel, camera: $camera, cameraSupport: $cameraSupport, isSatelliteMode: $isSatelliteMode, selectedCLLocationCoordinate: Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!.location, mapNameSpace: mapNameSpace)
                }
                    
                Spacer()
            }
            .padding(.top, 80)
            .padding(.trailing, 10)
        }
        .onMapCameraChange(frequency: .continuous) { camera in
            self.cameraSupport = MapCameraPosition.camera(.init(centerCoordinate: camera.camera.centerCoordinate, distance: camera.camera.distance, heading: camera.camera.heading, pitch: camera.camera.pitch))
        }
        .mapScope(mapNameSpace)
        .animation(.easeInOut, value: camera)
        .sensoryFeedback(.selection, trigger: filter.selectedCategories)
        .sensoryFeedback(.impact, trigger: selection)
        .overlay {
            VStack {
                CategoryFiltersView(filter: filter)
            }
            .padding(.top, 20)
        }
        .onAppear {
            verifyLocationStatus()
            
            // Set endingDate (for filtering) to 23.59 today
            filter.endingDate = Calendar.current.startOfDay(for: filter.startingDate)
            filter.endingDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: filter.endingDate) ?? Calendar.current.startOfDay(for: filter.endingDate)
        }
        .onChange(of: viewModel.locationManager.authorizationStatus) {
            verifyLocationStatus()
        }
    }
    
    func verifyLocationStatus() {
        if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
            camera = .userLocation(followsHeading: true, fallback: .automatic)
        } else {
            camera = MapCameraPosition.camera(.init(centerCoordinate: Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!.location, distance: 3200))
        }
    }
}
