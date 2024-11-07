import SwiftUI

// This file contains the UI for the Profile screen.

struct ProfileView: View {
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    // An Optional<Favor> used as a selector for a Favor: 
    // nil => no Favor selected
    // *something* => that Favor is selected
    @Binding var selectedFavor: Favor?
        
    // Boolean value to handle the behavior of the "Export IPA" sheet
    @State private var isExportSheetPresented = false
    
    @State private var isChangeNameAlertPresented = false
    
    @State private var newName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // Profile View
                HStack(spacing: 20) {
                    // Profile picture
                    ZStack {
                        // Background
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.cyan.gradient)
                        
                        // Icon
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                    }
                    // Temporary: need a way to export an IPA file without XCode
                    .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) { 
                        isExportSheetPresented = true
                    }
                    
                    // Info
                    VStack() {
                        Text(database.userName)
                            .font(.title2)
                            .bold()
                            .onLongPressGesture() {
                                isChangeNameAlertPresented = true
                            }
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
                .listRowBackground(Color.clear)
                
                // Rewards Section
                Section(
                    content: {
                        HStack {}
                    },
                    header: {
                        Text("Riconoscimenti")
                    }, 
                    footer: {
                        Text("Colleziona le medaglie completando dei Favori")
                    }
                )
                
                // My Favors
                Section(
                    content: {
                        // Favors
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 30), count: 2), content: {
                            ForEach(database.favors) { favor in
                                FavorBoxView(favor: favor)
                                    .onTapGesture {
                                        selectedFavor = favor
                                    }
                            }
                        })
                    },
                    header: {
                        Text("I tuoi favori")
                    },
                    footer: {
                        Text("Monitora lo stato dei tuoi Favori ancora in corso")
                    }
                )
            }
            .navigationTitle("Profilo")
        }
        .sheet(isPresented: $isExportSheetPresented, onDismiss: {}) {
            ExportView()
        }
        .alert("Cambia nome", 
               isPresented: $isChangeNameAlertPresented, 
               actions: {
                    Button("Annulla", role: .destructive, action: {
                        isChangeNameAlertPresented = false
                        }
                    )
                    
                    Button("Conferma", role: .cancel, action: {
                        database.userName = newName
                        isChangeNameAlertPresented = true
                        }
                    )
            
            TextField("Nome Cognome", text: $newName)
               }
           )
    }
}
