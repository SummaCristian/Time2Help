import SwiftUI
import MapKit

struct ContentView: View {
    // Connection to the ViewModel for Data and Location Permissions
    @StateObject private var viewModel = MapViewModel()
    
    // Integer to keep track of which tab is selected
    @State private var selectedTab: Int = 0 // Track the selected tabEmptyView
    // Boolean value to hanlde the behavior of the "New Favor" sheet
    @State private var isSheetPresented = false // State to control sheet visibility
    @State private var isExportSheetPresented = false
    // Main View
    var body: some View {
        // The main UI of this app is composed of a TabView, meaning the the UI is divided
        // into different tabs, each one containing a portion of the app.
        // Each one of the different screens is then coded inside its own file.
        TabView(selection: $selectedTab) {
            Group {
                // Tab 0: Map
                MapView(viewModel: viewModel)
                    .tabItem {
                        Label("Mappa", systemImage: "map")
                    }
                    .tag(0) // Tag for the Map tab
                
                // Tab 1: New Favor (opens sheet)
                Text("Nuovo Favore") // A placeholder just for the tab label
                    .tabItem {
                        Label("Nuovo Favore", systemImage: "plus.rectangle")
                    }
                    .tag(1) // Tag for the Nuovo Favore tab
                    .onChange(of: selectedTab) { oldValue, newValue in
                        if newValue == 1 {
                            isSheetPresented = true // Show the sheet when the tab is selected
                            selectedTab = oldValue // Return to the previous tab
                        }
                    }
                
                // Tab 2: Profile
                ProfileView()
                    .tabItem {
                        Label("Profilo", systemImage: "person.fill")
                    }
                    .tag(2) // Tag for the Profile tab
                // Temporary: need a way to export an IPA file without XCode
                    .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) { 
                        isExportSheetPresented = true
                    }
                
            }
            .sheet(isPresented: $isSheetPresented, onDismiss: {}) {
                NewFavorSheet() // The sliding sheet content
            }
            .sheet(isPresented: $isExportSheetPresented, onDismiss: {}) {
                ExportView()
            }
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                    }
        .tint(.blue)
   }
}
