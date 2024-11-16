import SwiftUI
import MapKit

// This file contains the UI for the Profile screen.

struct ProfileView: View {
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    // An Optional<Favor> used as a selector for a Favor:
    // nil => no Favor selected
    // *something* => that Favor is selected
    @Binding var selectedFavor: Favor?
    
    @Binding var user: User
    
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
    
    var body: some View {
        NavigationStack {
            Form { //
                // Profile View
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
                .listRowBackground(Color.clear)
                
                // Rewards Section
                Section(
                    content: {
                        HStack { }
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
                        //LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 30), count: 2), content: {
                        LazyVGrid(columns: [.init(.adaptive(minimum: 140), spacing: 30)], spacing: 10) {
                            ForEach(database.favors) { favor in
                                FavorBoxView(favor: favor)
                                    .onTapGesture {
                                        selectedFavor = favor
                                    }
                            }
                        }
                    },
                    header: {
                        Text("I tuoi favori")
                    },
                    footer: {
                        Text("Monitora lo stato dei Tuoi Favori ancora in corso")
                            .safeAreaPadding(.bottom, 40)
                    }
                )
            }
            .navigationTitle("Profilo")
        }
        .sheet(isPresented: $isExportSheetPresented, onDismiss: {}) {
            ExportView()
        }
        .sheet(isPresented: $isModifySheetPresented, content: {
            ModifyProfileView(isModifySheetPresented: $isModifySheetPresented, user: $user, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodStructTemp: $selectedNeighbourhoodStructTemp)
                .interactiveDismissDisabled()
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
