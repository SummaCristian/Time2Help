import SwiftUI
import MapKit

// This file contains the UI for the New Favor sheet.

struct NewFavorSheet: View {
    // Used to control the dismissal mechanism from inside the sheet
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
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
    @StateObject var newFavor: Favor
    
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
                                TextField("Titolo", text: $newFavor.title)
                                    .font(.title3.bold())
                                    .textInputAutocapitalization(.sentences)
                                    .onChange(of: newFavor.title) { _, _ in
                                        newFavor.title = String(newFavor.title.prefix(50))
                                    }
                                
                                Text("\(newFavor.title.count)/50")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.gray)
                                
                                if !newFavor.title.isEmpty {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.red, .red.opacity(0.2))
                                        .onTapGesture {
                                            newFavor.title = ""
                                        }
                                }
                            }
                            .padding(.vertical, 8)
                            
                            HStack(alignment: .top, spacing: 8) {
                                TextField("Descrizione", text: $newFavor.description, axis: .vertical)
                                    .font(.callout)
                                    .textInputAutocapitalization(.sentences)
                                    .lineLimit(5 ... 5)
                                
                                if !newFavor.description.isEmpty {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.red, .red.opacity(0.2))
                                        .onTapGesture {
                                            newFavor.description = ""
                                        }
                                }
                            }
                            .padding(.vertical, 6)
                        },
                        header: {
                            Text("TITOLO E DESCRIZIONE")
                        })
                    
                    // Private vs Public selector
                    Section(
                        content: {
                            Picker(
                                selection: $newFavor.type, 
                                content: {
                                    ForEach(FavorType.allCases) { type in
                                        Label(type.string, systemImage: type.icon)
                                            .tag(type)
                                    }
                                }, 
                                label: {
                                    //Text("Tipo di Favore")
                                })
                            .pickerStyle(.inline)
                            .listItemTint(newFavor.color)
                            
                        },
                        header: {
                            Text("Tipo di Favore")
                        }
                    )
                    
                    // Category
                    Section(
                        content: {
                            Picker(
                                selection: $newFavor.category, 
                                label: 
                                    Text(newFavor.category.description)
                                        .font(.subheadline)
                            ) {
                                ForEach(FavorCategory.allCases.filter({$0 != .all})) { category in
                                    Label(category.name, systemImage: category.icon).tag(category)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(newFavor.color)
                        },
                        header: {
                            Text("Categoria")
                        }
                    )
                    
                    // Date selectors
                    Section(
                        content: {
                            Toggle(isOn: $newFavor.isAllDay, label: {
                                Text("Tutto il giorno")
                            })
                            .tint(.green)
                            .onChange(of: newFavor.isAllDay) { old, new in
                                if new {
                                    // Is All Day
                                    newFavor.startingDate = Calendar.current.startOfDay(for: newFavor.startingDate)
                                    newFavor.endingDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: newFavor.endingDate) ?? Calendar.current.startOfDay(for: newFavor.endingDate)
                                } else {
                                    // Not All Day
                                    newFavor.startingDate = .now
                                    newFavor.endingDate = .now.addingTimeInterval(3600)
                                }
                            }
                            .padding(.vertical, 4)
                            
                            DatePicker(
                                "Inizio",
                                selection: $newFavor.startingDate,
                                displayedComponents: newFavor.isAllDay ? .date : [.date, .hourAndMinute]
                            )
                            .tint(.green)
                            .padding(.vertical, 4)
                            
                            DatePicker(
                                "Fine",
                                selection: $newFavor.endingDate,
                                displayedComponents: newFavor.isAllDay ? .date : [.date, .hourAndMinute]
                            )
                            .tint(.green)
                            .padding(.vertical, 4)
                        },
                        header: {
                            Text("DATA E ORA")
                        })
                    
                    // Additional infos
                    Section(
                        content: {
                            Toggle(isOn: $newFavor.isCarNecessary, label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "car.fill")
                                        .foregroundStyle(Color(.white))
                                        .frame(width: 30, height: 30)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color(.systemRed))
                                        }
                                    
                                    Text("Auto Necessaria")
                                }
                            })
                            .padding(.vertical, 4)
                            
                            Toggle(isOn: $newFavor.isHeavyTask, label: {
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
                            .padding(.vertical, 4)
                        },
                        header: {
                            Text("INFO AGGIUNTIVE")
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
                                    .foregroundColor(.green)
                                }
                                
                                Map(
                                    bounds: MapCameraBounds(minimumDistance: 800, maximumDistance: 800),
                                    interactionModes: [] // No interactions allowed
                                ) {
                                    Annotation("", coordinate: newFavor.location, content: {
                                        // Only this Favor is shown in this mini-Map
                                        FavorMarker(favor: newFavor, isSelected: .constant(true), isInFavorSheet: true)
                                    })
                                }
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
                            Text("POSIZIONE")
                        }
                    )
                    
                    // Reward
                    /*
                     Section(
                     content: {
                     VStack(spacing: 20) {
                     HStack(spacing: 8) {
                     Image(systemName: "dollarsign.circle.fill")
                     .foregroundStyle(Color(.white))
                     .frame(width: 30, height: 30)
                     .background {
                     RoundedRectangle(cornerRadius: 5)
                     .foregroundStyle(Color(.systemYellow))
                     }
                     
                     Text("Ricompensa")
                     
                     Spacer()
                     
                     Image(systemName: "info.circle")
                     .onTapGesture {
                     isRewardInfoDialogPresented = true
                     }
                     }
                     
                     HStack(spacing: 12) {
                     ZStack {
                     Circle()
                     .frame(width: 50, height: 50)
                     .foregroundStyle(newFavor.reward > 0 ? Color(.systemYellow) : Color(.systemGray2))
                     .opacity(0.6)
                     
                     Image(systemName: "minus")
                     .resizable()
                     .scaledToFit()
                     .foregroundStyle(newFavor.reward > 0 ? .white : Color(.systemGray))
                     .frame(width: 20, height: 20)
                     .bold()
                     }
                     .hoverEffect(.lift)
                     .onTapGesture {
                     if newFavor.reward > 0 {
                     lastRewardValue = newFavor.reward
                     withAnimation {
                     newFavor.reward -= 1
                     }
                     }
                     }
                     
                     ZStack {
                     Circle()
                     .frame(width: 120, height: 120)
                     .foregroundStyle(Color(.systemYellow))
                     .opacity(0.3)
                     
                     CreditNumberView(favor: newFavor)
                     .contentTransition(.numericText(countsDown: newFavor.reward > lastRewardValue))
                     .sensoryFeedback(.impact, trigger: newFavor.reward)
                     }
                     
                     ZStack {
                     Circle()
                     .frame(width: 50, height: 50)
                     .foregroundStyle(Color(.systemYellow))
                     .opacity(0.6)
                     
                     Image(systemName: "plus")
                     .resizable()
                     .scaledToFit()
                     .foregroundStyle(.white)
                     .frame(width: 20, height: 20)
                     .bold()
                     }
                     .hoverEffect(.lift)
                     .onTapGesture {
                     lastRewardValue = newFavor.reward
                     withAnimation {
                     newFavor.reward += 1
                     }
                     }
                     }
                     }
                     .padding(.vertical, 4)
                     },
                     header: {
                     Text("RICOMPENSA")
                     }
                     )*/
                    
                    Text("") // To leave space for popup button
                        .frame(height: 0)
                        .listRowBackground(Color.clear)
                        .safeAreaPadding(.bottom, 34)
                }
                .scrollDismissesKeyboard(.immediately)
                .onAppear {
                    if let location = viewModel.locationManager.location?.coordinate {
                        newFavor.location = location
                    } else {
                        // Handle the case where the location is unavailable
                        print("Location not available yet.")
                        // Optionally show an alert to the user
                    }
                }
                .onDisappear() {
                    isConfirmationDialogPresented = true
                }
                .sheet(isPresented: $isLocationSelectorPresented, content: {
                    // Shows the Location Selector sheet
                    LocationSelector(viewModel: viewModel, newFavor: newFavor)
                        .interactiveDismissDisabled()
                })
                .alert("Tornare indietro?", isPresented: $isConfirmationDialogPresented) {
                    Button("No", role: .cancel) {}
                    Button("Sì", role: .destructive) {
                        //dismiss()
                        isPresented = false
                    }
                } message: {
                    Text("I dettagli che hai inserito andranno persi")
                }
                .onChange(of: newFavor.title) {
                    if newFavor.title != "" {
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
                            newFavor.neighbourhood = newFavor.author.neighbourhood
                            
                            database.addFavor(favor: newFavor)
                            //dismiss()
                            isPresented = false
                        }) {
                            Label("Richiedi Favore", systemImage: "plus")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 45)
                                .background(.blue, in: .capsule)
                        }
                        .shadow(radius: 10)
                        .disabled(!canBeCreated)
                        .opacity(canBeCreated ? 1 : 0)
                        .offset(y: canBeCreated ? 0 : 50)
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
                        Text("Nuovo Favore")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    // Favor's Icon
                    ZStack {
                        Circle()
                            .foregroundStyle(newFavor.color.gradient)
                            .frame(width: 35, height: 35)
                            .shadow(radius: 3)
                        Image(systemName: newFavor.icon)
                            .resizable()
                            .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                    .hoverEffect(.lift)
                }
            })
        }
        .sensoryFeedback(.selection, trigger: newFavor.category)
        .sensoryFeedback(.selection, trigger: newFavor.type)
    }
}

#Preview {    
    NewFavorSheet(isPresented: .constant(true), database: Database(), viewModel: MapViewModel(), newFavor: Favor(author: User(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue"))))
}
