import SwiftUI
import MapKit

// This file contains the UI for the New Favor sheet.

struct NewFavorSheet: View {
    // Used to control the dismissal mechanism from inside the sheet
    @Environment(\.dismiss) var dismiss
    
    @Binding var isPresented: Bool
    
    // Boolean value that controls the appearing of the second sheet, used to edit the Favor's Icon
    @State private var isEditIconSheetPresented = false
    // Boolean value that controls the appearing of the second sheet, used to edit the Favor's Location
    @State private var isLocationSelectorPresented = false
    // Boolean value that controls the appearing of the Dialog, asking the User if he wants to quit the creation process
    @State private var isConfirmationDialogPresented = false
    // Boolean value that controls whether the newly created Favor can be added to the Database, or if the data is not enough
    @State private var canBeCreated = false
    // A buffer to save the last reward value, to use for aniamtion purposes
    @State private var lastRewardValue = 0
    
    // Connection to the Database, where Favors are stored
    @ObservedObject var database: Database
    // Connection to the MapViewModel, used to retrieve the User's Location
    @ObservedObject var mapViewModel: MapViewModel
    
    // New Favor: this is the Favor that the user is creating, whose details can be edited in here.
    // At the end of the creation process, if the User confirms it, it will be added to the Database
    @StateObject private var newFavor: Favor = Favor()
    
    // The UI
    var body: some View {
        // GeometryReader is used to set the UI with a top alignment
        NavigationStack {
            GeometryReader {_ in
                
                // Form is needed to build the UI
                Form {
                    
                    // Title and Description
                    Section(
                        content: {
                            TextField("Titolo", text: $newFavor.title)
                                .padding(.vertical, 8)
                                .font(.title3.bold())
                                .textInputAutocapitalization(.sentences)
                            
                            TextField("Descrizione", text: $newFavor.description, axis: .vertical)
                                .padding(.vertical, 6)
                                .font(.callout)
                                .textInputAutocapitalization(.sentences)
                                .lineLimit(5 ... 5)
                        },
                        header: {
                            Text("TITOLO E DESCRIZIONE")
                        })
                    
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
                                    Text("Luogo")
                                    
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
                                        FavorMarker(favor: newFavor, isSelected: .constant(true))
                                    })
                                }
                                .frame(height: 200)
                                .cornerRadius(10)
                                .hoverEffect(.lift)
                            }
                            .padding(.vertical, 4)
                            .onTapGesture {
                                isLocationSelectorPresented = true
                            }
                        },
                        header: {
                            Text("POSIZIONE")
                        }
                    )
                    
                    // Reward
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
                    )
                }
                .scrollDismissesKeyboard(.immediately)
                .onAppear() {
                    // Retrieves the User's current Location and sets it as the Favor's location
                    newFavor.location = mapViewModel.region.center
                    
                    // Writes the User's username as the Favor's Owner
                    newFavor.author = database.userName
                }
                .onDisappear() {
                    isConfirmationDialogPresented = true
                }
                .sheet(isPresented: $isEditIconSheetPresented, content: {
                    // Shows the Edit Icon sheet
                    NewFavorIconSheet(newFavor: newFavor)
                })
                .sheet(isPresented: $isLocationSelectorPresented, content: {
                    // Shows the Location Selector sheet
                    LocationSelector(newFavor: newFavor)
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
                
                // Create Button: only shown if it can be pressed
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button(action: {
                            database.addFavor(favor: newFavor)
                            //dismiss()
                            isPresented = false
                        }) {
                            Label("Richiedi Favore", systemImage: "plus")
                                .bold()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.blue)
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
                .padding()
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
                    // Favor's Icon selector Button
                    HStack(spacing: 6) {
                        Image(systemName: "arrowtriangle.down.circle")
                            .font(.caption)
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(newFavor.color.color).gradient)
                                .frame(width: 35, height: 35)
                                .shadow(radius: 3)
                            Image(systemName: newFavor.icon.icon)
                                .resizable()
                                .foregroundStyle(.white)
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                        }
                    }
                    .onTapGesture(perform: {
                        // Shows the second sheet, where the User can edit the Icon
                        isEditIconSheetPresented = true
                    })
                    .hoverEffect(.lift)
                }
            })
        }
    }
}
