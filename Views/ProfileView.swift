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
                            .foregroundStyle(.cyan)
                        
                        // Icon
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    // Temporary: need a way to export an IPA file without XCode
                    .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) { 
                        isExportSheetPresented = true
                    }
                    
                    // Info
                    VStack() {
                        Text("Nome Cognome")
                            .font(.title2)
                            .bold()
                        
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
    }
}
