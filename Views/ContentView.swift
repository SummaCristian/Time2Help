import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace private var rewardNameSpace
        
    // Connection to the ViewModel for Data and Location Permissions
    @ObservedObject var viewModel: MapViewModel
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
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
    
    @State private var selectedReward: Reward?
    
    @State private var reduceRewardBadge = false
    @State private var showRewardTexts = false
    
    @State private var lastInteractedFavor: Favor?
    @State private var showInteractionOverlay = false
    @State private var lastFavorInteraction: FavorInteraction?
    
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
                        MapView(viewModel: viewModel, database: database, selectedFavor: $selectedFavor, selectedFavorID: $selectedFavorID, selectedNeighbourhood: selectedNeighbourhood, user: $user)
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
                            .disabled(true)
                        
                        // Tab 2: Profile
                        ProfileView(viewModel: viewModel, database: database, selectedFavor: $selectedFavor, user: $user, selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, isEditable: true, showInteractedFavorOverlay: $showInteractionOverlay, lastFavorInteracted: $lastInteractedFavor, lastInteraction: $lastFavorInteraction)
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
            NewFavorSheet(isPresented: $isSheetPresented, database: database, viewModel: viewModel, newFavor: Favor(author: user), showCreatedFavorOverlay: $showInteractionOverlay, lastFavorCreated: $lastInteractedFavor, lastInteraction: $lastFavorInteraction)
                .interactiveDismissDisabled()
        }
        .sheet(
            item: $selectedFavor,
            onDismiss: {
                selectedFavor = nil
                selectedFavorID = nil
            },
            content: { favor in
                FavorDetailsSheet(viewModel: viewModel, database: database, selectedFavor: $selectedFavor, user: user, favor: favor, selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, showInteractedFavorOverlay: $showInteractionOverlay, lastFavorInteracted: $lastInteractedFavor, lastInteraction: $lastFavorInteraction)
            })
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        // Reward Details Overlay
        .overlay {
            if selectedReward != nil {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                        .overlay {
                            // Background Gradient
                            LinearGradient(
                                gradient: Gradient( colors: [.indigo, .purple, .pink, .red, .orange, .yellow, .green, .cyan]), 
                                startPoint: .topLeading, 
                                endPoint: .bottomTrailing
                            )
                                .opacity(0.4)
                        }
                        .ignoresSafeArea()

                    VStack(spacing: 40) {
                        Spacer().frame(height: 100)
                        
                        // Reward Icon
                        selectedReward!.rewardView
                            .matchedGeometryEffect(id: selectedReward!.id, in: rewardNameSpace)
                            .scaleEffect(reduceRewardBadge ? 0.5 : 2.2)
                            .padding(.bottom, 20)
                            .zIndex(1)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(height: 300)
                                .foregroundStyle(LinearGradient(
                                    gradient: Gradient( colors: [selectedReward?.color.opacity(0.3) ?? .white, selectedReward?.color ?? .white]), 
                                    startPoint: .topLeading, 
                                    endPoint: .bottomTrailing
                                ))
                            
                            VStack(spacing: 50) {
                                // Reward Title
                                Text(selectedReward!.title)
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 5)
                                    .scaleEffect(showRewardTexts ? 1 : 0)
                                
                                // Reward description
                                Text(selectedReward!.description)
                                    .scaleEffect(showRewardTexts ? 1 : 0)
                            }
                            .padding()
                        }
                        .offset(y: -90)
                        .padding()
                        
                        Spacer()
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                showRewardTexts = true
                            }
                        }
                    }
                    .onDisappear {
                        showRewardTexts = false
                    }
                }
                .onTapGesture {
                    withAnimation {
                        reduceRewardBadge = true
                    }
                    withAnimation(.interpolatingSpring) {
                        selectedReward = nil
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        reduceRewardBadge = false
                    }
                }
            }
        }
        .overlay {
            if showInteractionOverlay {
                FavorFeedbackOverlay(favor: lastInteractedFavor!, type: lastFavorInteraction ?? .created)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            showInteractionOverlay = false
                        }
                    }
            }
        }
        .ignoresSafeArea(.keyboard)
        .tint(.blue)
        .onAppear() {
            // Creates the main User
            user = User(nameSurname: $nameSurname, neighbourhood: $selectedNeighbourhood, profilePictureColor: $selectedColor)
            
            user.rewards.append(.numberTen)
            user.rewards.append(.numberTwenty)
            user.rewards.append(.numberFifty)
            user.rewards.append(.numberHundred)
            user.rewards.append(.gardeningCategory)
            user.rewards.append(.jobCategory)
            
            database.users.append(user)
            
            // Adds the template Markers to the Map
            database.initialize()
        }
        .sensoryFeedback(.selection, trigger: _selectedTab.wrappedValue)
    }
}
