import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var selectedTab: Int = 0 // Track the selected tab
    @State private var isSheetPresented = false // State to control sheet visibility
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .mapControlVisibility(.visible)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                    MapPitchToggle()
                }
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
                .tabItem {
                    Label("Mappa", systemImage: "map")
                }
                .tag(0) // Tag for the Map tab
            
            Text("Nuovo Favore") // A placeholder just for the tab label
                .tabItem {
                    Label("Nuovo Favore", systemImage: "plus.rectangle")
                }
                .tag(1) // Tag for the Nuovo Favore tab
                .onChange(of: selectedTab) { newValue in
                    if newValue == 1 {
                        isSheetPresented = true // Show the sheet when the tab is selected
                        selectedTab = 0 // Return to the previous tab
                    }
                }
            
            ProfileView()
                .tabItem {
                    Label("Profilo", systemImage: "person.fill")
                }
                .tag(2) // Tag for the Profile tab
        }
        .sheet(isPresented: $isSheetPresented, onDismiss: {}) {
            NewFavorSheet() // The sliding sheet content
        }
        .accentColor(.blue)
    }
}

struct NewFavorSheet: View {
    var body: some View {
        VStack {
            Text("Nuovo Favore")
                .font(.title)
                .padding()
            
            // Add more form fields or content here
            Text("Here you can create a new favor")
                .padding()
            
            Spacer()
        }
        .presentationDetents([.medium, .large]) // Available on iOS 16+ for adjusting sheet size
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profilo View")
    }
}
