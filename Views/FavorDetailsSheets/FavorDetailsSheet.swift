import SwiftUI
import MapKit

// This file contains the UI for the Favor's Details sheet, that appears when clicking on an existing Favor

struct FavorDetailsSheet: View {
//    @Environment(\.dismiss) var dismiss
    
    let isInExplanationView: Bool
    
    @ObservedObject var viewModel: MapViewModel
    
    @ObservedObject var database: Database
    @Binding var selectedFavor: Favor?
    @State var user: User
    
    // The Favor whose details are being showed
    @State var favor: Favor
    
    @Binding var selectedReward: Reward?
    var rewardNameSpace: Namespace.ID
    
    @State private var isAuthorProfileSheetPresented = false
    @State private var isHelperProfileSheetPresented = false
    
    @State private var value: Double = 0.0
    @State private var clickOnGoing: Bool = false
    
    @State private var isCarNeededAlertShowing = false
    @State private var isHeavyTaskAlertShowing = false
    
    @State private var isHelpersMenuExpanded = false
    
    @State private var selectedUser: User? = nil
    
//    @State private var isEditFavorSheetPresented: Bool = false
    @Binding var isEditFavorSheetPresented: Bool
    @State private var showDeletePopUp: Bool = false
    
    @Binding var showInteractedFavorOverlay: Bool
    @Binding var lastFavorInteracted: Favor?
    @Binding var lastInteraction: FavorInteraction?
    
    @Binding var ongoingFavor: Favor?
    
    // The UI
    var body: some View {
        // The GeometryReader is used to achieve a top alignment for the UI
        GeometryReader { _ in
            Form {
                if user.id == favor.author.id {
                    Section {
                        HStack {
                            Text("Modifica")
                                .font(.callout)
                                .foregroundStyle(.orange)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(.orange.opacity(0.2), in: .capsule)
                                .onTapGesture {
                                    isEditFavorSheetPresented = true
                                }
                                .disabled(isInExplanationView)
                            
                            Spacer()
                            
                            Text("Elimina")
                                .font(.callout)
                                .foregroundStyle(.red)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(.red.opacity(0.2), in: .capsule)
                                .onTapGesture {
                                    showDeletePopUp = true
                                }
                        }
                    }
                    .padding(.vertical, -20)
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    HStack(spacing: 12) {
                        // The Favor's Title
                        VStack(alignment: .leading, spacing: 16) {
                            Spacer().frame(height: 15)
                            
                            Text(favor.title)
                                .font(.title)
                                .fontWeight(.black)
                            
                            HStack(spacing: 8) {
                                ProfileIconView(username: favor.author.$nameSurname, color: favor.author.$profilePictureColor, size: .small)
                                
                                // The Favor's Author's Name
                                Text(favor.author.nameSurname)
                                    .font(.system(size: 15))
                                    .fontWidth(.compressed)
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                            }
                            .padding(.vertical, 7)
                            .padding(.leading, 8)
                            .padding(.trailing, 11)
                            .foregroundStyle(.primary)
                            .background(
                                Capsule()
                                    .foregroundStyle(favor.author.profilePictureColor.toColor()!.opacity(0.2))
                            )
                            .hoverEffect(.lift)
                            .onTapGesture {
                                selectedUser = favor.author
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: favor.type.icon)
                                
                                Text(favor.type.string)
                            }
                            .font(.subheadline)
                            .offset(x: 12)
                        }
                        
                        Spacer()
                        
                        FavorMarker(favor: favor, isSelected: .constant(true), isInFavorSheet: true, isOwner: user.id == favor.author.id)
                            .offset(x: -5, y: 45)
                            .frame(width: 100, height: 120)
                    }
                    .cornerRadius(10)
                    .padding(.top, user.id == favor.author.id ? -32 : 0)
                }
                .listRowBackground(Color.clear)
                
                // The User who accepted it
                if !favor.helpers.isEmpty {
                    Section(
                        content: {
                            if favor.helpers.count > 1 {
                                DisclosureGroup(String(favor.helpers.count) + " utenti", isExpanded: $isHelpersMenuExpanded) {
                                    ForEach(favor.helpers) { helper in
                                        HStack(spacing: 5) {
                                            ProfileIconView(
                                                username: helper.$nameSurname,
                                                color: helper.$profilePictureColor,
                                                size: .small
                                            )
                                            
                                            // The Favor's Helper's Name
                                            Text(helper.nameSurname)
                                                .fontWidth(.compressed)
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                                .textCase(.uppercase)
                                        }
                                        .padding(.vertical, 7)
                                        .padding(.leading, 8)
                                        .padding(.trailing, 11)
                                        .foregroundStyle(.primary)
                                        .background(
                                            Capsule()
                                                .foregroundStyle(helper.profilePictureColor.toColor()!.opacity(0.2))
                                        )
                                        .hoverEffect(.lift)
                                        .onTapGesture {
                                            selectedUser = helper
                                            isHelperProfileSheetPresented = true
                                        }
                                    }
                                }
                            } else {
                                HStack(spacing: 5) {
                                    ProfileIconView(
                                        username: favor.helpers.first!.$nameSurname,
                                        color: favor.helpers.first!.$profilePictureColor,
                                        size: .small
                                    )
                                    
                                    // The Favor's Helper's Name
                                    Text(favor.helpers.first!.nameSurname)
                                        .fontWidth(.compressed)
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                }
                                .padding(.vertical, 7)
                                .padding(.leading, 8)
                                .padding(.trailing, 11)
                                .foregroundStyle(.primary)
                                .background(
                                    Capsule()
                                        .foregroundStyle(favor.helpers.first!.profilePictureColor.toColor()!.opacity(0.2))
                                )
                                .hoverEffect(.lift)
                                .onTapGesture {
                                    if favor.helpers.first!.id != user.id {
                                        selectedUser = favor.helpers.first!
                                        isHelperProfileSheetPresented = true
                                    }
                                }
                            }
                        },
                        header: {
                            Text("Accettato da")
                        }
                    )
                }
                
                // The Favor's Description
                Section(
                    content: {
                        Text(favor.description)
                    },
                    header: {
                        Text("Descrizione")
                    }
                )
                
                // The Favor's reviews
                if favor.status == .completed {
                    Section(
                        content: {
                            StarsView(
                                value: $value,
                                isInDetailsSheet: true,
                                clickOnGoing: favor.author.id != user.id ? .constant(true) : $clickOnGoing,
                                reviews: favor.reviews
                            )
                            .onAppear {
                                if favor.author.id != user.id {
                                    let sumOfReviews = favor.reviews.reduce(0) { $0 + $1.rating}
                                    let averageOfReviews = sumOfReviews / Double(favor.reviews.count)
                                    value = averageOfReviews
                                }
                            }
                        },
                        header: {
                            Text("Recensione")
                        }
                    )
                }
                
                Section(
                    content: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Stato")
                                    .font(.title2)
                                    .bold()
                                Text(favor.status.textualForm)
                            }
                            
                            Spacer()
                            
                            CircularProgressView(value: favor.status.progressPercentage, size: .large, numberColor: favor.color, progressColor: favor.color)
                        }
                    },
                    header: {
                        Text("Stato di avanzamento")
                    }
                )
                
                // The Favor's Time slots data
                Section(
                    content: {
                        TimeSlotsList(slots: $favor.timeSlots, isEditable: false, tint: favor.color)
                    },
                    header: {
                        Text("Fasce orarie")
                    }
                )
                
                // The Additional Infos (only shown if needed)
                if favor.isCarNecessary || favor.isHeavyTask {
                    Section(
                        content: {
                            // Is Car Necessary
                            HStack() {
                                if favor.isCarNecessary {
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .foregroundStyle(.white)
                                            .bold()
                                        
                                        Text("Auto")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                    .frame(height: 50)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemRed).gradient)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        isCarNeededAlertShowing = true
                                    }
                                }
                                
                                // Is Heavy Task
                                if favor.isHeavyTask {
                                    HStack {
                                        Image(systemName: "hammer.fill")
                                            .foregroundStyle(.white)
                                            .bold()
                                        
                                        Text("Faticoso")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                    .frame(height: 50)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGreen).gradient)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        isHeavyTaskAlertShowing = true
                                    }
                                }
                            }
                        },
                        header: {
                            Text("Info")
                        })
                }
                
                // The Favor's Location
                Section(
                    content: {
                        // A Map to show a preview of the Location
                        Map(
                            bounds: MapCameraBounds(minimumDistance: 800, maximumDistance: 800),
                            interactionModes: [] // No interactions allowed
                        ) {
                            Annotation("", coordinate: favor.location, content: {
                                // Only this Favor is shown in this mini-Map
                                FavorMarker(favor: favor, isSelected: .constant(true), isInFavorSheet: true, isOwner: user.id == favor.author.id)
                            })
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                    },
                    header: {
                        Text("Posizione")
                    }
                )
                
                Text("") // To leave space for popup button
                    .frame(height: 0)
                    .listRowBackground(Color.clear)
                    .safeAreaPadding(.bottom, 34)
            }
            
            // The Accept Favor Button
            // it is outside the ScrollView, because it hovers on top of the rest of the UI.
            // This allows to have it always in the same spot, always accessible
//            if (
//                favor.helpers.contains(where: { $0.id == user.id }) &&
//                favor.status == .accepted
//            ) {
//                VStack{
//                    Spacer()
//
//                    HStack {
//                        Spacer()
//
//                        Button(action: {
//                            // Accepting the Favor
//                            favor.status = .justStarted
//
//                            lastInteraction = .started
//                            lastFavorInteracted = favor
//                            showInteractedFavorOverlay = true
//
//                            selectedFavor = nil
//
//                            withAnimation {
//                                ongoingFavor = favor
//                            }
//                        }) {
//                            Label("Inizia Favore", systemImage: "play.fill")
//                                .font(.body.bold())
//                                .foregroundStyle(.white)
//                                .padding(.vertical, 15)
//                                .padding(.horizontal, 45)
//                                .background(.blue, in: .capsule)
//                        }
//                        .shadow(radius: 10)
//                        .hoverEffect(.highlight)
//
//                        Spacer()
//                    }
//                }
//            }
            
            if favor.canBeAccepted(userID: user.id) && favor.status != .completed && favor.status != .expired {
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Accepting the Favor
                            favor.helpers.append(user)
                            if favor.status == .notAcceptedYet {
                                favor.status = .waitingToStart
                            }
                            
                            lastInteraction = .accepted
                            lastFavorInteracted = favor
                            showInteractedFavorOverlay = true
                            
                            selectedFavor = nil
                        }) {
                            Label("Accetta favore", systemImage: "checkmark")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 45)
                                .background(.blue, in: .capsule)
                        }
                        .shadow(radius: 10)
                        .hoverEffect(.highlight)
                        
                        Spacer()
                    }
                }
            } else if favor.hasBeenAccepted(userID: user.id) && favor.status == .waitingToStart {
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Accepting the Favor
                            selectedFavor = nil
                            
                            favor.helpers.removeAll(where: { $0.id == user.id })
                            if favor.helpers.count == 0 {
                                favor.status = .notAcceptedYet
                            }
                            
                            lastInteraction = .removed
                            lastFavorInteracted = favor
                            showInteractedFavorOverlay = true
                        }) {
                            Label("Esci dal favore", systemImage: "figure.walk.departure")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 45)
                                .background(.red, in: .capsule)
                        }
                        .shadow(radius: 10)
                        .hoverEffect(.highlight)
                        
                        Spacer()
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large])
        .alert("Vuoi eliminarlo?", isPresented: $showDeletePopUp) {
            Button("No", role: .cancel) {}
            Button("Sì", role: .destructive) {
//                    database.favors.removeAll(where: { $0.id ==  })
                database.removeFavor(id: favor.id)
                
                lastInteraction = .deleted
                lastFavorInteracted = favor
                showInteractedFavorOverlay = true
                
                selectedFavor = nil
                
//                dismiss()
            }
            .disabled(isInExplanationView)
        } message: {
            Text("Il favore verrà cancellato definitivamente")
        }
        .alert(
            "Auto Necessaria",
            isPresented: $isCarNeededAlertShowing,
            actions: {
                Button("Chiudi", role: .cancel, action: {})
            },
            message: {
                Text("L'utente che ha richiesto questo Favore ha segnalato la necessità di possedere un'auto e di essere abilitati alla guida.\nTime2Help ricorda l'importanza di mettersi alla guida solo se si è in condizioni di guidare, ovvero non in stato di ebbrezza e/o sotto effetto di sostanze stupefacenti, nonchè l'obbligo di rispettare il Codice della Strada.")
            }
        )
        .alert(
            "Lavoro Faticoso",
            isPresented: $isHeavyTaskAlertShowing,
            actions: {
                Button("Chiudi", role: .cancel, action: {})
            },
            message: {
                Text("L'utente che ha richiesto questo Favore ha segnalato che si tratta di un lavoro fisico potenzialmente pesante.\nAccetta questo Favore solo se ritieni di poterlo fare.\nTime2Help non è responsabile per alcun danno diretto o indiretto causato dall'esecuzione di un Favore.")
            }
        )
        .sheet(isPresented: $isAuthorProfileSheetPresented, content: {
            ProfileView(isInExplanationView: isInExplanationView, showExplanationTemp: .constant(false), viewModel: viewModel, database: database, selectedFavor: $selectedFavor, user: $favor.author, selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, isEditFavorSheetPresented: $isEditFavorSheetPresented, showInteractedFavorOverlay: $showInteractedFavorOverlay, lastFavorInteracted: $lastFavorInteracted, lastInteraction: $lastInteraction, ongoingFavor: $ongoingFavor)
        })
        .sheet(item: $selectedUser) { helper in
            ProfileView(isInExplanationView: isInExplanationView, showExplanationTemp: .constant(false), viewModel: viewModel, database: database, selectedFavor: $selectedFavor, user: .constant(helper), selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, isEditFavorSheetPresented: $isEditFavorSheetPresented, showInteractedFavorOverlay: $showInteractedFavorOverlay, lastFavorInteracted: $lastFavorInteracted, lastInteraction: $lastInteraction, ongoingFavor: $ongoingFavor)
        }
        .sheet(isPresented: $isEditFavorSheetPresented, content: {
            EditFavorSheet(isPresented: $isEditFavorSheetPresented, database: database, viewModel: viewModel, editFavorId: favor.id, showEditedFavorOverlay: $showInteractedFavorOverlay, lastFavor: $lastFavorInteracted, lastInteraction: $lastInteraction)
        })
        .sensoryFeedback(.impact, trigger: isHelpersMenuExpanded)
        .sensoryFeedback(.impact, trigger: isHeavyTaskAlertShowing)
        .sensoryFeedback(.impact, trigger: isCarNeededAlertShowing)
    }
}

// Extension of Color, used to define colors using hex
extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) % 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double((hex & 0xFF)) / 255.0,
            opacity: alpha
        )
    }
}
