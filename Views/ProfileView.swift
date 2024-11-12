import SwiftUI

// This file contains the UI for the Profile screen.

struct ProfileView: View {
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    // An Optional<Favor> used as a selector for a Favor:
    // nil => no Favor selected
    // *something* => that Favor is selected
    @Binding var selectedFavor: Favor?
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    // Boolean value to handle the behavior of the "Export IPA" sheet
    @State private var isExportSheetPresented: Bool = false
    
    @State private var isModifySheetPresented: Bool = false
    
    @State private var newName: String = ""
    
    @State private var nameSurnameTemp: String = ""
    @State private var selectedColorTemp: String = ""
    @State private var selectedNeighbourhoodTemp: String = ""
    @State private var errorNameSurnameEmpty: Bool = false
    
    var body: some View {
        NavigationStack {
            Form { //
                // Profile View
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        // Profile picture
                        ZStack {
                            // Background
                            Circle()
                                .frame(width: 110, height: 110)
                                .foregroundStyle(.background)
                                .overlay {
                                    Circle()
                                        .stroke(.gray, lineWidth: 0.5)
                                }
                            
                            Circle()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(selectedColor.toColor().gradient)
                            
                            // Icon
                            Text(nameSurname.filter({ $0.isUppercase }))
                                .font(.custom("Futura-bold", size: nameSurname.filter({ $0.isUppercase }).count == 1 ? 35 : nameSurname.filter({ $0.isUppercase }).count == 2 ? 30 : 25))
                                .foregroundStyle(.white)
                        }
                        // Temporary: need a way to export an IPA file without XCode
                        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10) {
                            isExportSheetPresented = true
                        }
                        
                        // Info
                        Text(nameSurname)
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
                        .background(selectedColor.toColor(), in: .capsule)
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
            ModifyProfileView(isModifySheetPresented: $isModifySheetPresented, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodTemp: $selectedNeighbourhoodTemp)
                .interactiveDismissDisabled()
        })
        .onAppear {
            nameSurnameTemp = nameSurname
            selectedColorTemp = selectedColor
            selectedNeighbourhoodTemp = selectedNeighbourhood
        }
    }
}
