import SwiftUI
import MapKit

// This file contains the UI for the New Favor sheet.

struct EditFavorSheet: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    
    @Binding var isPresented: Bool
    
    // Boolean value that controls the appearing of the second sheet, used to edit the Favor's Location
    @State private var isLocationSelectorPresented = false
    // Boolean value that controls the appearing of the Dialog, asking the User if he wants to quit the creation process
    @State private var isConfirmationDialogPresented = false
    // Boolean value that controls the appearing of the Dialog that explains what the Reward is
    @State private var isRewardInfoDialogPresented = false
    // Boolean value that controls whether the newly created Favor can be added to the Database, or if the data is not enough
    @State private var canBeCreated = false
    // A buffer to save the last reward value, to use for aniamtion purposes
    @State private var lastRewardValue = 0
    
    // Connection to the Database, where Favors are stored
    @ObservedObject var database: Database
    // Connection to the MapViewModel, used to retrieve the User's Location
    @ObservedObject var viewModel: MapViewModel
    
    // New Favor: this is the Favor that the user is creating, whose details can be edited in here.
    // At the end of the creation process, if the User confirms it, it will be added to the Database
    let editFavorId: UUID
    
    @Binding var selectedFavor: Favor?
    
    @Binding var showEditedFavorOverlay: Bool
    @Binding var lastFavor: Favor?
    @Binding var lastInteraction: FavorInteraction?
    
    @Binding var favor: Favor
    @StateObject private var tempFavor: Favor = Favor(author: User(nameSurname: .constant("Nome Cognome"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")))
    
    // The UI
    var body: some View {
        // GeometryReader is used to set the UI with a top alignment
        NavigationStack {
            GeometryReader { _ in
                
                // Form is needed to build the UI
                Form {
                    
                    // Title and Description
                    Section(
                        content: {
                            HStack(spacing: 8) {
                                TextField("Titolo", text: $tempFavor.title)
                                    .font(.title3.bold())
                                    .textInputAutocapitalization(.sentences)
                                    .onChange(of: tempFavor.title) { _, _ in
                                        favor.title = String(favor.title.prefix(50))
                                    }
                                
                                Text("\(tempFavor.title.count)/50")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.gray)
                                
                                if !tempFavor.title.isEmpty {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.red, .red.opacity(0.2))
                                        .onTapGesture {
                                            tempFavor.title = ""
                                        }
                                }
                            }
                            .padding(.vertical, 8)
                            
                            HStack(alignment: .top, spacing: 8) {
                                TextField("Descrizione", text: $tempFavor.description, axis: .vertical)
                                    .font(.callout)
                                    .textInputAutocapitalization(.sentences)
                                    .lineLimit(5 ... 5)
                                
                                if !tempFavor.description.isEmpty {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.red, .red.opacity(0.2))
                                        .onTapGesture {
                                            tempFavor.description = ""
                                        }
                                }
                            }
                            .padding(.vertical, 6)
                        },
                        header: {
                            Text("Titolo e descrizione")
                        })
                    
                    // Private vs Public selector
                    Section(
                        content: {
                            Picker(
                                selection: $tempFavor.type,
                                content: {
                                    ForEach(FavorType.allCases) { type in
                                        VStack (alignment: .leading, spacing: 8) {
                                            Label(type.string, systemImage: type.icon)
                                                .padding(.leading, 8)
                                            Text(type.description)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .tag(type)
                                    }
                                },
                                label: {
                                    //Text("Tipo di Favore")
                                })
                            .pickerStyle(.inline)
                            .listItemTint(tempFavor.color)
                            
                        },
                        header: {
                            Text("Modalità di partecipazione")
                        }
                    )
                    
                    // Category
                    Section(
                        content: {
                            Picker(
                                selection: $tempFavor.category,
                                label:
                                    Text(tempFavor.category.description)
                                    .font(.subheadline)
                            ) {
                                ForEach(FavorCategory.allCases.filter({$0 != .all})) { category in
                                    Label(category.name, systemImage: category.icon)
                                        .tag(category)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(tempFavor.color)
                        },
                        header: {
                            Text("Categoria")
                        }
                    )
                    
                    // Date selectors
                    Section(
                        content: {
                            TimeSlotsList(slots: $tempFavor.timeSlots)
                                .tint(tempFavor.color)
                        },
                        header: {
                            Text("Fasce orarie")
                        }
                    )
                    
                    // Additional infos
                    Section(
                        content: {
                            Toggle(isOn: $tempFavor.isCarNecessary, label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "car.fill")
                                        .foregroundStyle(Color(.white))
                                        .frame(width: 30, height: 30)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color(.systemRed))
                                        }
                                    
                                    Text("Auto necessaria")
                                }
                            })
                            .tint(.red)
                            .padding(.vertical, 4)
                            
                            Toggle(isOn: $tempFavor.isHeavyTask, label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "hammer.fill")
                                        .foregroundStyle(Color(.white))
                                        .frame(width: 30, height: 30)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color(.systemGreen))
                                        }
                                    
                                    Text("Faticoso")
                                }
                            })
                            .tint(.green)
                            .padding(.vertical, 4)
                        },
                        header: {
                            Text("Info aggiuntive")
                        }
                    )
                    .tint(.green)
                    
                    // Location Selector
                    Section(
                        content: {
                            VStack(spacing: 12) {
                                HStack(spacing: 0) {
                                    Text("Seleziona il luogo")
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 6) {
                                        Image(systemName: "pin.fill")
                                            .font(.subheadline)
                                        Text("Scegli")
                                    }
                                    .foregroundColor(tempFavor.color)
                                }
                                
                                Map(
                                    bounds: MapCameraBounds(minimumDistance: 800, maximumDistance: 800),
                                    interactionModes: [] // No interactions allowed
                                ) {
                                    Annotation("", coordinate: tempFavor.location, content: {
                                        // Only this Favor is shown in this mini-Map
                                        FavorMarker(favor: tempFavor, isSelected: .constant(true), isInFavorSheet: true, isOwner: true)
                                    })
                                }
                                .mapStyle(
                                    isSatelliteMode ? .hybrid(elevation: .realistic, pointsOfInterest: .all) : .standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)
                                )
                                .frame(height: 200)
                                .cornerRadius(10)
                                .hoverEffect(.lift)
                                .shadow(color: .primary.opacity(0.1), radius: 10)
                            }
                            .padding(.vertical, 4)
                            .contentShape(.rect)
                            .onTapGesture {
                                isLocationSelectorPresented = true
                            }
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
                .scrollDismissesKeyboard(.immediately)
                .onDisappear() {
                    isConfirmationDialogPresented = true
                }
                .sheet(isPresented: $isLocationSelectorPresented, content: {
                    // Shows the Location Selector sheet
                    LocationSelector(viewModel: viewModel, favor: tempFavor)
                        .interactiveDismissDisabled()
                })
                .alert("Tornare indietro?", isPresented: $isConfirmationDialogPresented) {
                    Button("No", role: .cancel) {}
                    Button("Sì", role: .destructive) {
                        // dismiss()
                        isPresented = false
                    }
                } message: {
                    Text("I dettagli che hai inserito andranno persi")
                }
                .onChange(of: tempFavor.title) {
                    if tempFavor.title != "" && tempFavor.description != "" {
                        canBeCreated = true
                    } else {
                        canBeCreated = false
                    }
                }
                .onChange(of: tempFavor.description) {
                    if tempFavor.title != "" && tempFavor.description != "" {
                        canBeCreated = true
                    } else {
                        canBeCreated = false
                    }
                }
                .alert("Cos'è una ricompensa?", isPresented: $isRewardInfoDialogPresented) {
                    Button("Chiudi", role: .cancel) {}
                } message: {
                    Text("La Ricompensa rappresenta il numero di Crediti di Tempo che la persona che completa il Favore riceverà.\nOgni Credito equivale a circa 30 minuti, ma è possibile aggiungere ulteriori Crediti se ritenuti adeguati.")
                        .multilineTextAlignment(.leading)
                }
                
                // Create Button: only shown if it can be pressed
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button(action: {
                            favor.title = tempFavor.title
                            favor.description = tempFavor.description
                            favor.author = tempFavor.author
                            favor.neighbourhood = tempFavor.neighbourhood
                            favor.type = tempFavor.type
                            favor.location = tempFavor.location
                            favor.isCarNecessary = tempFavor.isCarNecessary
                            favor.isHeavyTask = tempFavor.isHeavyTask
                            favor.status = tempFavor.status
                            favor.category = tempFavor.category
                            favor.timeSlots = tempFavor.timeSlots
                            
                            lastFavor = favor
                            lastInteraction = .edited
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showEditedFavorOverlay = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    withAnimation {
                                        showEditedFavorOverlay = false
                                    }
                                }
                            }
                            
                            // Close sheets
                            isPresented = false
                            selectedFavor = nil
                        }) {
                            Label("Salva", systemImage: "square.and.arrow.down")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 45)
                                .background(canBeCreated ? .blue : .gray, in: .capsule)
                        }
                        .shadow(radius: 10)
                        .disabled(!canBeCreated)
                        .animation(.easeInOut, value: canBeCreated)
                        .sensoryFeedback(.pathComplete, trigger: canBeCreated)
                        .hoverEffect(.highlight)
                        
                        Spacer()
                    }
                }
                .padding(.all, 20)
            }
            .presentationDragIndicator(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla", role: .cancel) {
                        isConfirmationDialogPresented = true
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Modifica Favore")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    // Favor's Icon
                    ZStack {
                        Circle()
                            .foregroundStyle(tempFavor.color.gradient)
                            .frame(width: 35, height: 35)
                            .shadow(radius: 3)
                        Image(systemName: tempFavor.icon)
                            .resizable()
                            .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                    .hoverEffect(.lift)
                }
            })
        }
        .sensoryFeedback(.selection, trigger: tempFavor.category)
        .sensoryFeedback(.selection, trigger: tempFavor.type)
        .onAppear {
            tempFavor.title = favor.title
            tempFavor.description = favor.description
            tempFavor.author = favor.author
            tempFavor.neighbourhood = favor.neighbourhood
            tempFavor.type = favor.type
            tempFavor.location = favor.location
            tempFavor.isCarNecessary = favor.isCarNecessary
            tempFavor.isHeavyTask = favor.isHeavyTask
            tempFavor.status = favor.status
            tempFavor.category = favor.category
            tempFavor.timeSlots = favor.timeSlots
        }
    }
}

#Preview {
    EditFavorSheet(isPresented: .constant(true), database: Database(), viewModel: MapViewModel(), editFavorId: UUID(), selectedFavor: .constant(nil), showEditedFavorOverlay: .constant(true), lastFavor: .constant(nil), lastInteraction: .constant(.created), favor: .constant(Favor(author: User(nameSurname: .constant("Nome Cognome"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")))))
}
