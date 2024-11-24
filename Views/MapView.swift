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
    @Binding var selectedFavorID: UUID?
    
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    
    let selectedNeighbourhood: String
    
    // A NameSpace needed for certain Map features
    @Namespace private var mapNameSpace
    
    // The MapCameraPosition used to center around the User's Location
    @State private var mapCameraPosition: MapCameraPosition = MapCameraPosition.automatic
    // The list of Map Elements from Apple's MapKit database
    @State private var selection: MapFeature? = nil
    
    @State private var selectedCategories: [FavorCategory] = [.all]
    
    // The UI
    var body: some View {
        // The Map, centered around ViewModel's region, and showing the User's position when possible
        Map(
            position: $mapCameraPosition,
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
                if isCategorySelected(category: favor.category) {
                    
                    if favor.type == .publicFavor {
                        MapCircle(center: favor.location, radius: 35)
                            .foregroundStyle(favor.category.color.opacity(0.2))
                            .stroke(favor.category.color, lineWidth: 3)
                            .mapOverlayLevel(level: .aboveRoads)
                    }
                    
                    Annotation(
                        coordinate: favor.location,
                        content: {
                            FavorMarker(favor: favor, isSelected: .constant(selectedFavorID == favor.id), isInFavorSheet: false)
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
            if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
                MapUserLocationButton()
            }
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
        .overlay {
            VStack() {
                HStack {
                    Button(action: {
                        isSatelliteMode = !isSatelliteMode
                    }) {
                        MapStyleButton(isSatelliteSelected: $isSatelliteMode)
                            .contextMenu(menuItems: {
                                Button("Semplificata", systemImage: isSatelliteMode ? "map" : "map.fill") {
                                    isSatelliteMode = false
                                }
                                
                                Button("Satellite", systemImage: isSatelliteMode ? "globe.europe.africa.fill" : "globe.europe.africa") {
                                    isSatelliteMode = true
                                }
                            })
                    }
                    .frame(width: 44, height: 44)
                    .offset(x: 5, y: 60)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .mapStyle(
            isSatelliteMode ? .hybrid(elevation: .realistic, pointsOfInterest: .all) : .standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)
        )
        .edgesIgnoringSafeArea(.bottom)
        .tint(.blue)
        .safeAreaPadding(.top, 80)
        .safeAreaPadding(.leading, 5)
        .safeAreaPadding(.trailing, 10)
        .sensoryFeedback(.selection, trigger: selectedCategories)
        .sensoryFeedback(.impact, trigger: selection)
        .overlay {
            VStack {
                CategoryFiltersView(selectedCategories: $selectedCategories)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .onAppear {
            verifyLocationStatus()
        }
        .onChange(of: viewModel.locationManager.authorizationStatus) {
            verifyLocationStatus()
        }
    }
    
    func verifyLocationStatus() {
        if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
            mapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
        } else {
            mapCameraPosition = MapCameraPosition.camera(.init(centerCoordinate: Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!.location, distance: 3200))
        }
    }
    
    func isCategorySelected(category: FavorCategory) -> Bool {
        return (selectedCategories.contains(.all) || selectedCategories.contains(category))
    }
}
