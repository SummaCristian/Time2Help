import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    // Connection to the ViewModel for Data and Location Permissions
    @StateObject private var viewModel = MapViewModel()
    // Connection to the Database that stores the Favors
    @StateObject private var database = Database.shared
    
    @State private var user: User = User(nameSurname: .constant("temp"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue"))
    
    // An Optional<Favor> used as a selector for a Favor:
    // nil => no Favor selected
    // *something* => that Favor is selected
    @State private var selectedFavor: Favor?
    @State private var selectedFavorID: UUID?
    // Integer to keep track of which tab is selected
    @State private var selectedTab: Int = 0 // Track the selected tabEmptyView
    // Boolean value to hanlde the behavior of the "New Favor" sheet
    @State private var isSheetPresented = false // State to control sheet visibility
    
    // Main View
    var body: some View {
        // The main UI of this app is composed of a TabView, meaning the the UI is divided
        // into different tabs, each one containing a portion of the app.
        // Each one of the different screens is then coded inside its own file.
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    Group {
                        // Tab 0: Map
                        MapView(viewModel: viewModel, database: database, selectedFavor: $selectedFavor, selectedFavorID: $selectedFavorID)
                            .tabItem {
                                Label("Mappa", systemImage: "map")
                            }
                            .tag(0) // Tag for the Map tab
                        
                        // Tab 1: New Favor (opens sheet)
                        Text("Nuovo Favore") // A placeholder just for the tab label
                        //NewFavorSheet(isPresented: $isSheetPresented, database: database, mapViewModel: viewModel)
                            .tabItem {
                                Label("Nuovo Favore", systemImage: "plus.rectangle")
                            }
                            .tag(1) // Tag for the Nuovo Favore tab
                            .disabled(true)
                        
                        // Tab 2: Profile
                        ProfileView(database: database, selectedFavor: $selectedFavor, user: $user, isEditable: true)
                            .tabItem {
                                Label("Profilo", systemImage: "person.fill")
                            }
                            .tag(2) // Tag for the Profile tab
                    }
                }
                
                // Invisible Button that covers the middle tab, used to open the "New Favor" sheet
                Button(action: {
                    isSheetPresented = true // Show the sheet when the tab is selected
                }, label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .tint(.blue)
                        .frame(width: (geometry.size.width/3) + 5, height: 65)
                })
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.thinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray3), Color(.systemGray5)] : [Color(.white), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                        }
                )
                .hoverEffect(.lift)
                .offset(y: 5)
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            NewFavorSheet(isPresented: $isSheetPresented, database: database, mapViewModel: viewModel, newFavor: Favor(author: user))
                .interactiveDismissDisabled()
        }
        .sheet(
            item: $selectedFavor,
            onDismiss: {
                selectedFavor = nil
                selectedFavorID = nil
            },
            content: { favor in
                FavorDetailsSheet(database: database, selectedFavor: $selectedFavor, user: user, favor: favor)
            })
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .ignoresSafeArea(.keyboard)
        .tint(.blue)
        .onAppear() {
            // Creates the main User
            user = User(nameSurname: $nameSurname, neighbourhood: $selectedNeighbourhood, profilePictureColor: $selectedColor)
            database.users.append(user)            
            
            // Adds the template Markers to the Map
            database.initialize()
            
            // Accepts a few Favors (for testing)
            var count = 0
            for favor in database.favors {
                if count < 3 && favor.author.id != user.id && favor.helper == nil {
                    favor.helper = user
                    count += 1
                }
            }
            
            // Accept some Favors with other Users (for testing)
            database.favors.last?.helper = database.users.filter({ $0.nameSurname == "Mario Rossi"}).first
            database.favors.first(where: { $0.helper == nil })?.helper = database.users.filter({ $0.nameSurname == "Giuseppe Verdi"}).first
        }
        .sensoryFeedback(.selection, trigger: _selectedTab.wrappedValue)
    }
}
