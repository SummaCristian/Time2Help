import SwiftUI
import MapKit

struct ModifyProfileView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    @Binding var isModifySheetPresented: Bool
    
    @Binding var user: User
    
    @Binding var nameSurnameTemp: String
    @Binding var selectedColorTemp: String
    @Binding var selectedNeighbourhoodStructTemp: Neighbourhood
    
    @State private var errorNameSurnameEmpty: Bool = false
    
    @State private var isConfirmationDialogPresented: Bool = false
    
    @State private var canBeModified: Bool = true
    
    // Boolean value that controls the appearing of the second sheet, used to edit the user's neighbourhood
    @State private var isNeighbourhoodSelectorPresented: Bool = false
    
    @State private var selectedNeighbourhoodStructTempTwo: Neighbourhood = .init(name: "", location: .init())
    
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                Form {
                    Section(
                        content: {
                            VStack(spacing: 20) {
                                HStack(spacing: 16) {
                                    HStack(spacing: 8) {
                                        TextField("Nome e Cognome", text: $nameSurnameTemp)
                                            .textInputAutocapitalization(.words)
                                            .onChange(of: nameSurnameTemp) { _, _ in
                                                nameSurnameTemp = String(nameSurnameTemp.prefix(50))
                                            }
                                        
                                        Text("\(nameSurnameTemp.count)/50")
                                            .font(.subheadline.bold())
                                            .foregroundStyle(.gray)
                                        
                                        if !nameSurnameTemp.isEmpty {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.red, .red.opacity(0.2))
                                                .onTapGesture {
                                                    nameSurnameTemp = ""
                                                }
                                        }
                                    }
                                    .frame(height: 50)
                                    .padding(.horizontal, 20)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(errorNameSurnameEmpty ? .red : .gray, lineWidth: 0.5)
                                    }
                                    
                                    ProfileIconView(username: $nameSurnameTemp, color: $selectedColorTemp, size: .medium)
                                    
                                }
                                
                                VStack(alignment: .center, spacing: 16) {
                                    Text("Seleziona il colore per la tua immagine")
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), content: {
                                        ForEach(FavorColor.allCases) { colorCase in
                                            //                                            // The color itself
                                            Circle()
                                                .frame(width: 35, height: 35)
                                                .foregroundStyle(Color(colorCase.color))
                                                .padding(.all, 4)
                                                .background {
                                                    Circle()
                                                        .stroke(.primary, lineWidth: 2)
                                                        .opacity(selectedColorTemp.toColor()! == colorCase.color ? 1 : 0)
                                                }
                                                .onTapGesture() {
                                                    // Sets the color inside the Favor
                                                    withAnimation {
                                                        selectedColorTemp = colorCase.color.toString()!
                                                    }
                                                }
                                        }
                                    })
                                }
                                .padding(.bottom, 8)
                            }
                        },
                        header: {
                            Text("Nome e cognome")
                        })
                    
                    Section(
                        content: {
                            VStack(spacing: 12) {
                                HStack(spacing: 0) {
                                    Text("Seleziona il tuo quartiere")
                                    
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
                                    Annotation("", coordinate: selectedNeighbourhoodStructTemp.location, content: {
                                        // Only this Neighbourhood is shown in this mini-Map
                                        NeighbourhoodMarker(isSelected: .constant(true), neighbourhood: selectedNeighbourhoodStructTemp)
                                    })
                                }
                                .mapStyle(
                                    .standard(
                                        elevation: .realistic,
                                        emphasis: .automatic,
                                        pointsOfInterest: .excludingAll
                                    )
                                )
                                .frame(height: 200)
                                .cornerRadius(10)
                                .hoverEffect(.lift)
                                .shadow(color: .primary.opacity(0.1), radius: 10)
                            }
                            .padding(.vertical, 4)
                            .contentShape(.rect)
                            .onTapGesture {
                                isNeighbourhoodSelectorPresented = true
                            }
                        },
                        header: {
                            Text("Quartiere")
                        }
                    )
                    
                    Text("") // To leave space for popup button
                        .frame(height: 0)
                        .listRowBackground(Color.clear)
                        .safeAreaPadding(.bottom, 40)
                }
                .scrollDismissesKeyboard(.immediately)
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
                            Text("Modifica Profilo")
                                .font(.headline)
                        }
                    }
                })
                
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button(action: {
                            user.nameSurname = nameSurnameTemp
                            user.profilePictureColor = selectedColorTemp
                            user.neighbourhood = selectedNeighbourhoodStructTemp.name
                            
                            isModifySheetPresented = false
                        }) {
                            Label("Modifica", systemImage: "pencil")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 45)
                                .background(.blue, in: .capsule)
                        }
                        .shadow(radius: 10)
                        .disabled(!canBeModified)
                        .opacity(canBeModified ? 1 : 0)
                        .offset(y: canBeModified ? 0 : 50)
                        .animation(.easeInOut, value: canBeModified)
                        .sensoryFeedback(.pathComplete, trigger: canBeModified)
                        .hoverEffect(.highlight)
                        
                        Spacer()
                    }
                }
                .padding(.all, 20)
            }
        }
        .onChange(of: nameSurnameTemp, { _, newValue in
            if newValue.isEmpty {
                canBeModified = false
            } else {
                canBeModified = true
            }
        })
        .alert("Tornare indietro?", isPresented: $isConfirmationDialogPresented) {
            Button("No", role: .cancel) {}
            Button("Sì", role: .destructive) {
                isModifySheetPresented = false
            }
        } message: {
            Text("I dettagli che hai inserito andranno persi")
        }
        .sheet(isPresented: $isNeighbourhoodSelectorPresented, onDismiss: {
            selectedNeighbourhoodStructTempTwo = selectedNeighbourhoodStructTemp
        }, content: {
            // Shows the Location Selector sheet
            NeighbourhoodSelector(viewModel: viewModel, selectedNeighbourhoodStructTemp: $selectedNeighbourhoodStructTemp, selectedNeighbourhoodStructTempTwo: $selectedNeighbourhoodStructTempTwo)
        })
        .onAppear {
            selectedNeighbourhoodStructTempTwo = selectedNeighbourhoodStructTemp
        }
    }
}
