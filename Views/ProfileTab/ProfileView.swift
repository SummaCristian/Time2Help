import SwiftUI
import MapKit

// This file contains the UI for the Profile screen.

struct ProfileView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    
    let isInExplanationView: Bool
    @Binding var showExplanationTemp: Bool
    
    @ObservedObject var viewModel: MapViewModel
    
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    // An Optional<Favor> used as a selector for a Favor:
    // nil => no Favor selected
    // *something* => that Favor is selected
    @Binding var selectedFavor: Favor?
    
    @Binding var user: User
    
    @Binding var selectedReward: Reward?
    var rewardNameSpace: Namespace.ID
    
    @State var isEditable = false
    
    @Binding var isEditFavorSheetPresented: Bool
    
    @Binding var showInteractedFavorOverlay: Bool
    @Binding var lastFavorInteracted: Favor?
    @Binding var lastInteraction: FavorInteraction?
    
    @State private var selectedNameSurname: String = ""
    @State private var selectedColor: String = "blue"
    @State private var selectedNeighbourhood = "Città Studi"
    
    @State private var nameSurnameTemp: String = ""
    @State private var selectedColorTemp: String = ""
    @State private var selectedNeighbourhoodStructTemp: Neighbourhood = .init(name: "", location: .init(latitude: 0.0, longitude: 0.0))
    
    // Boolean value to handle the behavior of the "Export IPA" sheet
    @State private var isExportSheetPresented: Bool = false
    
    @State private var isModifySheetPresented: Bool = false
    
    @State private var newName: String = ""
    
    @State private var errorNameSurnameEmpty: Bool = false
    
    @State private var averageReviews: Double = 0.0
    
    @State private var showRequestedFavors = false
    @State private var showAcceptedFavors = false
    
    @State private var destination: String? = nil
    
    @State private var isShowingRewardDetails: Bool = false
    
    // Anti-Spam for Rewards (animations can break)
    @State private var canTapOnRewards: Bool = true
    
    @State private var showChat: Bool = false
    
    @Binding var ongoingFavor: Favor?
    
    var body: some View {
        NavigationStack {
            List {
                // Profile View
                HStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            // Profile picture
                            ProfileIconView(username: $selectedNameSurname, color: $selectedColor, size: .extraLarge)
                            
                            // Temporary: need a way to export an IPA file without XCode
                                .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) {
                                    isExportSheetPresented = true
                                }
                            
                            // Info
                            Text(selectedNameSurname)
                                .font(.title.bold())
                            
                            Text("Quartiere: " + selectedNeighbourhood)
                                .font(.body)
                                .foregroundStyle(.gray)
                                .padding(.top, -12)
                        }
                        
                        if isEditable {
                            Button {
                                isModifySheetPresented = true
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "pencil")
                                    Text("Modifica")
                                }
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(selectedColor.toColor()!, in: .capsule)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                // Buttons
                Section(
                    content: {
                        HStack(spacing: 16) {
                            // Requested Favors
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image("RequestedFavorsIcon")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Spacer()
                                }
                                
                                Text("Favori richiesti")
                                    .font(.subheadline.bold())
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color(.systemGray6))
                                    .shadow(color: .gray.opacity(colorScheme == .dark ? 0.2 : 0.4), radius: 6)
//                                    .shadow(radius: 3)
                            }
                            .hoverEffect(.lift)
                            .onTapGesture {
                                //showRequestedFavors = true
                                destination = "Requested Favors"
                            }
                            
                            // Accepted Favors
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image("AcceptedFavorsIcon")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Spacer()
                                }
                                
                                Text("Favori accettati")
                                    .font(.subheadline.bold())
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color(.systemGray6))
                                    .shadow(color: .gray.opacity(colorScheme == .dark ? 0.2 : 0.4), radius: 6)
//                                    .shadow(radius: 3)
                            }
                            .hoverEffect(.lift)
                            .onTapGesture {
                                //showAcceptedFavors = true
                                destination = "Accepted Favors"
                            }
                        }
                    },
                    header: {
                        Text("Favori")
                    },
                    footer: {
                        Text("Controlla i Favori che hai richiesto e che hai accettato")
                    }
                )
                
                // Average of reviews
                Section(
                    content: {
                        if (database.favors.filter({ $0.helpers.contains(where: { $0.id == user.id }) }).count == 0) {
                            Text("Nessuna recensione ricevuta...")
                        } else {
                            StarsView(value: .constant(averageReviews), isInDetailsSheet: false, clickOnGoing: .constant(true))
                        }
                    },
                    header: {
                        Text("Media delle recensioni")
                    }
                )
                .onAppear {
                    let userFavors = database.favors
                        .filter { $0.helpers.contains(where: { $0.id == user.id }) }
                        .compactMap { $0.reviews.isEmpty ? nil : Double($0.reviews.reduce(0) { $0 + $1.rating }) / Double($0.reviews.count) }
                    
                    if !userFavors.isEmpty {
                        averageReviews = userFavors.reduce(0, +) / Double(userFavors.count)
                    } else {
                        averageReviews = 0
                    }
                }
                
                // Rewards Section
                if isEditable {
                    Section(
                        content: {
                            if user.rewards.isEmpty {
                                Text("Ancora nessun riconoscimento...")
                                    .foregroundStyle(.secondary)
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                    ForEach(user.rewards) { reward in
                                        reward.rewardView
                                            .matchedGeometryEffect(id: reward.id, in: rewardNameSpace)
                                            .onTapGesture {
                                                if canTapOnRewards && isEditable {
                                                    var transaction = Transaction()
                                                    transaction.disablesAnimations = false
                                                    
                                                    withTransaction(transaction) {
                                                        withAnimation(.interpolatingSpring) {
                                                            selectedReward = reward
                                                        }
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                        },
                        header: {
                            Text("Riconoscimenti")
                        },
                        footer: {
                            Text("Colleziona le medaglie completando dei Favori")
                                .padding(.bottom, isEditable ? 20 : 0)
                        }
                    )
                }
                
                // Chat Button
//                if !isEditable {
//                    Button {
//                        showChat = true
//                    } label: {
//                        Label("Chat", systemImage: "paperplane.fill")
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//                            .foregroundColor(.white)
//                            .background {
//                                Capsule()
//                                    .foregroundStyle(user.profilePictureColor.toColor()!.gradient)
//                            }
//                    }
//                    .listRowBackground(Color.clear)
//                    .padding(.bottom, 20)
//                }
            }
            .navigationTitle("Profilo")
            .navigationDestination(item: $destination) { destination in
                switch destination {
                case "Requested Favors":
                    RequestedFavorsView(viewModel: viewModel, database: database, user: $user, selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, isEditFavorSheetPresented: $isEditFavorSheetPresented, showInteractedFavorOverlay: $showInteractedFavorOverlay, lastFavorInteracted: $lastFavorInteracted, lastInteraction: $lastInteraction, ongoingFavor: $ongoingFavor)
                case "Accepted Favors":
                    AcceptedFavorsView(viewModel: viewModel, database: database, user: $user, selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, isEditFavorSheetPresented: $isEditFavorSheetPresented, showInteractedFavorOverlay: $showInteractedFavorOverlay, lastFavorInteracted: $lastFavorInteracted, lastInteraction: $lastInteraction, ongoingFavor: $ongoingFavor)
                case "faqs":
                    FaqScreen(isInExplanationView: isInExplanationView, showExplanationTemp: $showExplanationTemp)
                default:
                    Text("Unknown")
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: !isEditable ? 4 : 12) {
                        if isEditable {
                            // FAQs
                            Button(
                                action: {
                                    destination = "faqs"
                                }, label: {
                                    Label("Aiuto", systemImage: "questionmark.circle")
                                        .font(.title3)
                                }
                            )
                            
                            // App Settings
                            Button {
                                let settingsString = UIApplication.openSettingsURLString
                                if let settingsURL = URL(string: settingsString) {
                                    openURL(settingsURL)
                                }
                            } label: {
                                Label("Impostazioni", systemImage: "gearshape.circle")
                                    .font(.title3)
                            }
                            .disabled(isInExplanationView)
                        } else {
                            // Chat Button
                            Button {
                                showChat = true
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "paperplane.fill")
                                    
                                    Text("Chat")
                                }
                                .font(.subheadline)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .foregroundColor(.white)
                                .background {
                                    Capsule()
                                        .foregroundStyle(user.profilePictureColor.toColor()!.gradient)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: selectedReward) { _, _ in
            if selectedReward == nil {
                // Set a delay before a new Reward can be tapped
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    canTapOnRewards = true
                }
            } else {
                // Blocks tap gesture on Rewards
                canTapOnRewards = false
            }
        }
        .sheet(isPresented: $isExportSheetPresented, onDismiss: {}) {
            ExportView()
        }
        .sheet(isPresented: $isModifySheetPresented, content: {
            ModifyProfileView(isInExplanationView: isInExplanationView, viewModel: viewModel, isModifySheetPresented: $isModifySheetPresented, user: $user, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodStructTemp: $selectedNeighbourhoodStructTemp)
                .interactiveDismissDisabled()
        })
        .sheet(isPresented: $showChat, content: {
            ChatView(other: $user, showChat: $showChat)
//                .interactiveDismissDisabled()
        })
        .onAppear {
            selectedNameSurname = user.nameSurname
            selectedColor = user.profilePictureColor
            selectedNeighbourhood = user.neighbourhood
            
            nameSurnameTemp = user.nameSurname
            selectedColorTemp = user.profilePictureColor
            selectedNeighbourhoodStructTemp = Database.neighbourhoods.first(where: { $0.name == user.neighbourhood })!
        }
        .onChange(of: isModifySheetPresented) {
            selectedNameSurname = user.nameSurname
            selectedColor = user.profilePictureColor
            selectedNeighbourhood = user.neighbourhood
        }
    }
}
