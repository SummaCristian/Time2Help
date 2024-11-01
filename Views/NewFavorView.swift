import SwiftUI

// This file contains the UI for the New Favor sheet.

struct NewFavorSheet: View {    
    // Used to control the dismissal mechanism from inside the sheet
    @Environment(\.dismiss) var dismiss
    
    // Boolean value that controls the appearing of the second sheet, used to edit the Favor's Icon
    @State private var isEditIconSheetPresented = false
    // Boolean value that controls the appearing of the Dialog, asking the User if he wants to quit the creation process
    @State private var isConfirmationDialogPresented = false
    // Boolean value that controls whether the newly created Favor can be added to the Database, or if the data is not enough
    @State private var canBeCreated = false        
    
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
        GeometryReader {_ in
            // ScrollView is needed to be able to scroll the UI
            ScrollView {
                VStack(spacing: 20) {
                    // Title Button
                    HStack {
                        Button(
                            role: .cancel, 
                            action: {
                                // Shows the Dialog, asking for the User's confirmation
                                isConfirmationDialogPresented = true
                            },
                            label: {
                                Text("Annulla")
                                    .foregroundStyle(.red)
                            })
                        .padding(20)
                        Spacer()
                    }
                    
                    // Title Bar
                    HStack {
                        Text("Richiedi un nuovo Favore")
                            .font(.headline)
                        
                        Spacer()
                        
                        // Favor's Icon selector Button
                        HStack {
                            Image(systemName: "arrowtriangle.down.circle")
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color(newFavor.color.color))
                                    .frame(width: 40, height: 40)
                                    .shadow(radius: 3)
                                Image(systemName: newFavor.icon.icon)
                                    .resizable()
                                    .foregroundStyle(.white)
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)                        
                            }
                        }
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(Rectangle())
                        .cornerRadius(5)
                        
                    }
                    .onTapGesture(perform: {
                        // Shows the second sheet, where the User can edit the Icon
                        isEditIconSheetPresented = true
                    })
                    
                    // Title and Description
                    VStack(spacing: 0) {
                        TextField("Titolo", text: $newFavor.title)
                            .padding(12)
                            .font(.body)
                            .padding(.horizontal)
                            .background(Color(.secondarySystemBackground))
                            .textInputAutocapitalization(.sentences)
                        
                        Divider()
                        
                        TextField("Descrizione", text: $newFavor.description)
                            .padding(12)
                            .font(.body)
                            .padding(.horizontal)
                            .background(Color(.secondarySystemBackground))           
                            .textInputAutocapitalization(.sentences)
                    }
                    .cornerRadius(8)
                    
                    // Date selectors
                    VStack(spacing: 0) {
                        HStack {
                            Toggle(isOn: $newFavor.isAllDay, label: {
                                Text("Tutto il giorno")
                            })
                            .tint(.green)
                        }
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
                        .padding()
                        
                        Divider()
                        
                        HStack {
                            DatePicker(
                                "Inizio", 
                                selection: $newFavor.startingDate,
                                displayedComponents: newFavor.isAllDay ? .date : [.date, .hourAndMinute]
                            )
                            .tint(.green)
                        }
                        .background(Color(.secondarySystemBackground))
                        .padding()
                        
                        Divider()
                        
                        HStack {
                            DatePicker(
                                "Fine", 
                                selection: $newFavor.endingDate, 
                                displayedComponents: newFavor.isAllDay ? .date : [.date, .hourAndMinute]
                            )
                            .tint(.green)
                        }
                        .padding()
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    
                    // Additional infos
                    VStack(spacing: 0) {
                        Toggle(isOn: $newFavor.isCarNecessary, label: {
                            HStack {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color(.systemRed))
                                    Image(systemName: "car.fill")
                                        .foregroundStyle(Color(.white))
                                        .frame(width: 20, height: 20)
                                        .scaledToFit()
                                }
                                .cornerRadius(3)
                                
                                Text("Auto Necessaria")
                            }
                        })
                        .padding()
                        
                        Divider()
                        
                        Toggle(isOn: $newFavor.isHeavyTask, label: {
                            HStack {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color(.systemGreen))
                                    Image(systemName: "hammer.fill")
                                        .foregroundStyle(Color(.white))
                                        .frame(width: 20, height: 20)
                                        .scaledToFit()
                                }
                                .cornerRadius(3)
                                
                                Text("Faticoso")
                            }
                        })
                        .padding()
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .tint(.green)   
                    
                    // Location Selector
                    HStack {
                        Text("Luogo")
                            .padding(.vertical)
                        
                        Spacer()
                        
                        Button {
                            // Your action here
                        } label: {
                            Label("Scegli", systemImage: "pin.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        
                        Spacer().frame(width: 10)
                        
                    }
                    .padding(.horizontal)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    
                    // Reward
                    VStack (spacing: 20) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(Color(.systemYellow))
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundStyle(Color(.white))
                                    .frame(width: 20, height: 20)
                                    .scaledToFit()
                            }
                            .cornerRadius(3)
                            
                            Text("Ricompensa")
                            Spacer()
                        }
                        
                        HStack {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color(.systemYellow))
                                    .opacity(0.6)
                                
                                Image(systemName: "minus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 20, height: 20)
                                    .bold()
                            }
                            .onTapGesture {
                                if newFavor.reward > 0 {
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
                                
                                Text(String(newFavor.reward))
                                    .font(.system(size: 60, weight: .black, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(
                                                colors: [ Color(hex: 0xDBB400),
                                                          Color(hex: 0xEFAF00),
                                                          Color(hex: 0xF5D100),
                                                          Color(hex: 0xF5D100),
                                                          Color(hex: 0xD1AE15),
                                                          Color(hex: 0xDBB400)
                                                        ]
                                            ), 
                                            startPoint: .top, 
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(radius: 10)
                                    .contentTransition(.numericText())
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
                            .onTapGesture {
                                withAnimation {
                                    newFavor.reward += 1
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    
                    Spacer()
                        .frame(height: 50)
                }
                .padding()
            }
            .scrollDismissesKeyboard(.immediately)
            .onAppear() {
                // Retrieves the User's current Location and sets it as the Favor's location
                newFavor.location = mapViewModel.region.center
            }
            .onDisappear() {
                isConfirmationDialogPresented = true
            }
            .sheet(isPresented: $isEditIconSheetPresented, content: {
                // Shows the Edit Icon sheet
                NewFavorIconSheet(newFavor: newFavor)
            })
            .alert("Tornare indietro?", isPresented: $isConfirmationDialogPresented) {
                Button("No", role: .cancel) {}
                Button("Sì", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("I dettagli che hai inserito andranno persi")
            }
            .presentationDragIndicator(.visible)
            .onChange(of: newFavor.title) {
                if newFavor.title != "" {
                    canBeCreated = true
                } else {
                    canBeCreated = false
                }
            }
            
            // Create Button: only shown if it can be pressed
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        database.favors.append(newFavor)
                        dismiss()
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
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
}
