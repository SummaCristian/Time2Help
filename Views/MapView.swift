import SwiftUI
import MapKit

// This file contains the UI of the Map screen.

struct MapView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) private var openURL
    
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
    
    // A NameSpace needed for certain Map features
    @Namespace private var mapNameSpace
    
    // The MapCameraPosition used to center around the User's Location
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    // The list of Map Elements from Apple's MapKit database
    @State private var selection: MapFeature? = nil
    
    @State private var selectedCategories: [FavorCategory] = [.all]
    
    // The UI
    var body: some View {
        // The Map, centered around ViewModel's region, and showing the User's position when possible
        Map(
            initialPosition: mapCameraPosition,
            bounds: MapCameraBounds(minimumDistance: 0.008, maximumDistance: .infinity),
            interactionModes: .all,
            selection: $selection,
            scope: mapNameSpace) {
                // The User's position
                UserAnnotation()
                
                // All the Favors
                ForEach(database.favors.filter({ $0.neighbourhood == selectedNeighbourhood})) { favor in
                    if isCategorySelected(category: favor.category) {
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
                        .mapOverlayLevel(level: .aboveLabels)
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
                    pointsOfInterest: .all
                )
            )
            .edgesIgnoringSafeArea(.bottom)
            .tint(.blue)
            .safeAreaPadding(.top, 80)
            .safeAreaPadding(.leading, 5)
            .safeAreaPadding(.trailing, 10)
            .overlay {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(FavorCategory.allCases) { category in
                                CategoryCapsule(selectedCategories: $selectedCategories, category: category)
                                    .onTapGesture {
                                        if category == .all {
                                            // The "Tutte" capsule
                                            selectCategory(category: .all)
                                        } else {
                                            // The real categories
                                            if selectedCategories.contains(category) {
                                                deselectCategory(category: category)
                                            } else {
                                                selectCategory(category: category)
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .blur(radius: viewModel.error ? 10 : 0)
            .disabled(viewModel.error)
            .overlay {
                if viewModel.error {
                    Rectangle()
                        .foregroundStyle(.black)
                        .opacity(0.2)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Text(viewModel.errorMessage)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                        
                        Button(action: {
                            let settingsString = UIApplication.openSettingsURLString
                            if let settingsURL = URL (string: settingsString) {
                                openURL(settingsURL)
                            }
                        }, label: {
                            Text("Vai alle impostazioni")
                                .bold()
                                .foregroundStyle(.blue)
                        })
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .foregroundStyle(colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray6))
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray4), Color(.systemGray5)] : [Color(.systemGray6), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray3), Color(.systemGray5)] : [Color(.white), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                            }
                    )
                    .padding(.horizontal, 60)
                }
            }
    }
    
    func isCategorySelected(category: FavorCategory) -> Bool {
        return (selectedCategories.contains(.all) || selectedCategories.contains(category))
    }
    
    func selectCategory(category: FavorCategory) {
        if category != .all {
            if selectedCategories.contains(.all) {
                // Selects onlt the clicked category
                selectedCategories.removeAll()
            }
            if !selectedCategories.contains(category) {
                if selectedCategories.count == FavorCategory.allCases.count - 2 {
                    // All Categories have been selected, switch to .all
                    selectedCategories.removeAll()
                    selectedCategories.append(.all)
                } else {
                    // Adds the current category to the selection
                    selectedCategories.append(category)
                }
            }
        } else {
            selectedCategories.removeAll()
            selectedCategories.append(.all)
        }
    }
    
    func deselectCategory(category: FavorCategory) {
        if category != .all {
            if selectedCategories.contains(category) {
                if selectedCategories.count > 1 {
                    // There are still selected categories excluding this one
                    selectedCategories.removeAll {$0 == category}
                } else {
                    // This one was the only one selected, returning to .all
                    selectedCategories.removeAll()
                    selectedCategories.append(.all)
                }
            }
        }
    }
}
