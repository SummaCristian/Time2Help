//
//  ModifyProfileView.swift
//  AppTime2Help2
//
//  Created by Mattia Di Nardo on 09/11/24.
//

import SwiftUI

struct ModifyProfileView: View {
    
    @Binding var isModifySheetPresented: Bool
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @Binding var nameSurnameTemp: String
    @Binding var selectedColorTemp: String
    @Binding var selectedNeighbourhoodTemp: String
    
    @State private var errorNameSurnameEmpty: Bool = false
    
    @State private var isConfirmationDialogPresented: Bool = false
    
    @State private var canBeModified: Bool = true
    
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
                                        
                                        if !nameSurnameTemp.isEmpty {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.red, .red.opacity(0.2))
                                                .onTapGesture {
                                                    nameSurnameTemp = ""
                                                }
                                            //                                        Button {
                                            //                                            nameSurnameTemp = ""
                                            //                                        } label: {
                                            //                                            Image(systemName: "xmark.circle.fill")
                                            //                                                .foregroundStyle(.red, .red.opacity(0.2))
                                            //                                        }
                                        }
                                    }
                                    .frame(height: 50)
                                    .padding(.horizontal, 20)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(errorNameSurnameEmpty ? .red : .gray, lineWidth: 0.5)
                                    }
                                    
                                    ZStack {
                                        Circle()
                                            .frame(width: 70, height: 70)
                                            .foregroundStyle(.background)
                                            .overlay {
                                                Circle()
                                                    .stroke(.gray, lineWidth: 0.5)
                                            }
                                        
                                        Circle()
                                            .frame(width: 60, height: 60)
                                            .foregroundStyle(selectedColorTemp.toColor().gradient)
                                        
                                        Text(nameSurnameTemp.filter({ $0.isUppercase }))
                                            .font(.custom("Futura-bold", size: nameSurnameTemp.filter({ $0.isUppercase }).count == 1 ? 25 : nameSurnameTemp.filter({ $0.isUppercase }).count == 2 ? 20 : 15))
                                            .foregroundStyle(.white)
                                    }
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
                                                        .opacity(selectedColorTemp.toColor() == colorCase.color ? 1 : 0)
                                                }
                                                .onTapGesture() {
                                                    // Sets the color inside the Favor
                                                    withAnimation {
                                                        selectedColorTemp = colorCase.color.toString()
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
                            VStack(spacing: 16) {
                                Text("Seleziona il tuo quartiere")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Picker("", selection: $selectedNeighbourhoodTemp) {
                                    ForEach(neighbourhoods, id: \.self) { neighbourhood in
                                        Text(neighbourhood)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 150)
                                //                            .tint(.clear)
                                //                            .background(.blue.opacity(0.2), in: .rect(cornerRadius: 10))
                            }
                        },
                        header: {
                            Text("Quartiere")
                        })
                    
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
                            nameSurname = nameSurnameTemp
                            selectedColor = selectedColorTemp
                            selectedNeighbourhood = selectedNeighbourhoodTemp
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
    }
}

//VStack(spacing: 20) {
//    HStack(spacing: 16) {
//        HStack {
//            TextField("Nome e Cognome", text: $nameSurnameTemp)
//                .textInputAutocapitalization(.words)
//            
//            if !nameSurnameTemp.isEmpty {
//                Button {
//                    nameSurnameTemp = ""
//                } label: {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundStyle(.red, .red.opacity(0.2))
//                }
//            }
//        }
//        .frame(height: 50)
//        .padding(.horizontal, 20)
//        .overlay {
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(errorNameSurnameEmpty ? .red : .gray, lineWidth: 0.5)
//        }
//        ZStack {
//            Circle()
//                .frame(width: 70, height: 70)
//                .foregroundStyle(.background)
//                .overlay {
//                    Circle()
//                        .stroke(.gray, lineWidth: 0.5)
//                }
//            
//            Circle()
//                .frame(width: 60, height: 60)
//                .foregroundStyle(selectedColorTemp.toColor().gradient)
//            
//            Text(nameSurnameTemp.filter({ $0.isUppercase }))
//                .font(.custom("Futura-bold", size: nameSurname.filter({ $0.isUppercase }).count == 1 ? 25 : nameSurnameTemp.filter({ $0.isUppercase }).count <= 2 ? 20 : 15))
//                .foregroundStyle(.white)
//        }
//    }
//    
//    VStack(alignment: .center, spacing: 16) {
//        Text("Seleziona il colore per la tua immagine")
//        
//        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), content: {
//            ForEach(FavorColor.allCases) { colorCase in
//                ZStack {
//                    // The selector: is shown if this color is currently selected
//                    Circle()
//                        .frame(width: 42, height: 42)
//                        .foregroundStyle(.gray)
//                        .opacity(selectedColorTemp.toColor() == colorCase.color ? 0.4 : 0)
//                    
//                    // The color itself
//                    Circle()
//                        .frame(width: 35, height: 35)
//                        .foregroundStyle(Color(colorCase.color))
//                        .onTapGesture() {
//                            // Sets the color inside the Favor
//                            withAnimation {
//                                selectedColorTemp = colorCase.color.toString()
//                            }
//                        }
//                }
//            }
//        })
//    }
//    .padding(.all, 20)
//    .overlay {
//        RoundedRectangle(cornerRadius: 12)
//            .stroke(.gray, lineWidth: 0.5)
//    }
//    
//    VStack(spacing: 16) {
//        Text("Seleziona il tuo quartiere")
//            .frame(maxWidth: .infinity, alignment: .center)
//        
//        Picker("", selection: $selectedNeighbourhoodTemp) {
//            ForEach(neighbourhoods, id: \.self) { neighbourhood in
//                Text(neighbourhood)
//            }
//        }
//        .pickerStyle(.menu)
//        .background(.blue.opacity(0.2), in: .rect(cornerRadius: 10))
//    }
//    .padding(.all, 20)
//    .overlay {
//        RoundedRectangle(cornerRadius: 12)
//            .stroke(.gray, lineWidth: 0.5)
//    }
//    
//    Button {
//        if nameSurnameTemp.isEmpty {
//            if !errorNameSurnameEmpty {
//                errorNameSurnameEmpty = true
//            }
//        } else {
//            nameSurname = nameSurnameTemp
//            selectedColor = selectedColorTemp
//            selectedNeighbourhood = selectedNeighbourhoodTemp
//            isModifySheetPresented = false
//        }
//    } label: {
//        Text("Proseguiamo!")
//            .font(.body.bold())
//            .foregroundStyle(nameSurnameTemp.isEmpty ? .gray : .white)
//            .padding(.vertical, 16)
//            .frame(maxWidth: .infinity)
//            .background(nameSurnameTemp.isEmpty ? Color(.systemGray5) : .black, in: .capsule)
//    }
//    .frame(maxHeight: .infinity, alignment: .bottom)
//}
//.padding(.top, 12)
//.padding([.horizontal, .bottom], 20)
