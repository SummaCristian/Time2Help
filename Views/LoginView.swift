//
//  LoginView.swift
//  AppTime2Help2
//
//  Created by Mattia Di Nardo on 08/11/24.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var showLogin: Bool
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
//    @State private var showLogin: Bool = true // da fare con AppStorage
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationStack {
                LoginViewOne(showLogin: $showLogin, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
                    .toolbarVisibility(.hidden, for: .navigationBar)
            }
            
            LoginHeader()
        }
    }
}

struct LoginHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Image(systemName: "heart.fill")
                    .font(.body)
                    .foregroundStyle(.red)
                
                ZStack {
                    Capsule()
                        .foregroundStyle(.white)
                        .frame(width: 2, height: 8)
                        .rotationEffect(.degrees(45))
                        .offset(x: 2.5, y: -2.5)
                    
                    Capsule()
                        .foregroundStyle(.white)
                        .frame(width: 2, height: 4)
                        .rotationEffect(.degrees(-45))
                        .offset(x: -0.8, y: -1.5)
                }
                .offset(x: -0.5, y: 0.5)
            }
            .frame(width: 35, height: 35)
            .scaleEffect(1.5)
            
            Text("Time2Help")
                .font(.custom("Futura-bold", size: 20))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 20)
    }
}

struct LoginViewOne: View {
    
    @Binding var showLogin: Bool
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @State private var nameSurnameTemp: String = ""
    @State private var selectedColorTemp: String = "blue"
    @State private var selectedNeighbourhoodTemp: String = "Bande Nere"
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 20) {
                Image("Image1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .shadow(color: .white, radius: 2)
                
                VStack(spacing: 20) {
                    Text("Dai valore al tuo tempo e costruisci un quartiere migliore")
                        .font(.custom("Futura-bold", size: 24))
                        .foregroundStyle(LinearGradient(colors: [.purple, .pink, .red, .orange, .yellow, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 34)
                    Text("Crea un legame con le persone del tuo quartiere, stabilendo un rapporto di comunità e aiutandosi a vicenda")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding([.horizontal, .bottom], 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                NavigationLink {
                    LoginViewTwo(showLogin: $showLogin, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodTemp: $selectedNeighbourhoodTemp)
                        .toolbarVisibility(.hidden, for: .navigationBar)
                } label: {
                    Text("Sì, andiamo!")
                        .font(.body.bold())
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(.black, in: .capsule)
                }
            }
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .safeAreaPadding(.top, 60)
    }
}

struct LoginViewTwo: View {
    
    @Binding var showLogin: Bool
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @Binding var nameSurnameTemp: String
    @Binding var selectedColorTemp: String
    @Binding var selectedNeighbourhoodTemp: String
    
    @State private var errorNameSurnameEmpty: Bool = false
    
    @State private var disabledPicker: Bool = false
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("Ci serve qualche informazione su di te")
                        .font(.custom("Futura-bold", size: 24))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Psss! Le utilizziamo solo per crearti il profilo, così puoi tenere traccia di tutti i favori che richiedi e che fai!")
                        .font(.body)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 150)
                .padding([.horizontal, .bottom], 20)
                
                HStack(spacing: 16) {
                    HStack {
                        TextField("Nome e Cognome", text: $nameSurnameTemp)
                            .textInputAutocapitalization(.words)
                        
                        if !nameSurnameTemp.isEmpty {
                            Button {
                                nameSurnameTemp = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red, .red.opacity(0.2))
                            }
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
                            .font(.custom("Futura-bold", size: nameSurnameTemp.filter({ $0.isUppercase }).count == 1 ? 25 : nameSurnameTemp.filter({ $0.isUppercase }).count <= 2 ? 20 : 15))
                            .foregroundStyle(.white)
                    }
                }
                
                VStack(alignment: .center, spacing: 16) {
                    Text("Seleziona il colore per la tua immagine")
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), content: {
                        ForEach(FavorColor.allCases) { colorCase in
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
                .padding(.all, 20)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 0.5)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.primary)
                    
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.primary.opacity(0.4))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(.primary.opacity(0.1), in: .capsule)
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                if nameSurnameTemp.isEmpty {
                    Button {
                        if !errorNameSurnameEmpty {
                            errorNameSurnameEmpty = true
                        }
                    } label: {
                        Text("Proseguiamo!")
                            .font(.body.bold())
                            .foregroundStyle(.gray)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5), in: .capsule)
                    }
                } else {
                    NavigationLink {
                        LoginViewThree(showLogin: $showLogin, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodTemp: $selectedNeighbourhoodTemp)
                            .toolbarVisibility(.hidden, for: .navigationBar)
                    } label: {
                        Text("Proseguiamo!")
                            .font(.body.bold())
                            .foregroundStyle(.white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(.black, in: .capsule)
                    }
                }
            }
        }
        .onChange(of: nameSurnameTemp, { _, newValue in
            if !newValue.isEmpty {
                if errorNameSurnameEmpty {
                    errorNameSurnameEmpty = false
                }
            }
        })
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .safeAreaPadding(.top, 60)
    }
}

struct LoginViewThree: View {
    
    @Binding var showLogin: Bool
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @Binding var nameSurnameTemp: String
    @Binding var selectedColorTemp: String
    @Binding var selectedNeighbourhoodTemp: String
    
    @State private var errorNameSurnameEmpty: Bool = false
    
    @State private var disabledPicker: Bool = false
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("Ci serve qualche informazione su di te")
                        .font(.custom("Futura-bold", size: 24))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Psss! Le utilizziamo solo per crearti il profilo, così puoi tenere traccia di tutti i favori che richiedi e che fai!")
                        .font(.body)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 150)
                .padding([.horizontal, .bottom], 20)
                
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
                    .scrollDisabled(disabledPicker)
//                            .background(.blue.opacity(0.2), in: .rect(cornerRadius: 10))
                }
                .padding(.all, 20)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 0.5)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.primary.opacity(0.4))
                    
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.primary)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(.primary.opacity(0.1), in: .capsule)
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                NavigationLink {
                    LoginViewFour(showLogin: $showLogin, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodTemp: $selectedNeighbourhoodTemp)
                        .toolbarVisibility(.hidden, for: .navigationBar)
                } label: {
                    Text("Proseguiamo!")
                        .font(.body.bold())
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(.black, in: .capsule)
                }
            }
        }
        .onChange(of: nameSurnameTemp, { _, newValue in
            if !newValue.isEmpty {
                if errorNameSurnameEmpty {
                    errorNameSurnameEmpty = false
                }
            }
        })
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .safeAreaPadding(.top, 60)
    }
}

struct LoginViewFour: View {
    
    @Binding var showLogin: Bool
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @Binding var nameSurnameTemp: String
    @Binding var selectedColorTemp: String
    @Binding var selectedNeighbourhoodTemp: String
    
//    @State private var showLogin: Bool = true // da fare con AppStorage
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 20) {
                Image("Image2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .shadow(color: .white, radius: 2)
                
                VStack(spacing: 20) {
                    Text("Ben fatto!")
                        .font(.custom("Futura-bold", size: 30))
                        .foregroundStyle(LinearGradient(colors: [.purple, .pink, .red, .orange, .yellow, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .padding(.all, 20)
                    
                    Text("Ora non ti resta che scoprire i favori che puoi svolgere o crearne di nuovi, mettendoti in contatto con le persone di quartiere!")
                        .font(.body)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding([.horizontal, .bottom], 20)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                Button {
                    nameSurname = nameSurnameTemp
                    selectedColor = selectedColorTemp
                    selectedNeighbourhood = selectedNeighbourhoodTemp
                    showLogin = false
                } label: {
                    Text("Entra nell'app!")
                        .font(.body.bold())
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity).background(LinearGradient(colors: [.purple, .pink, .red, .orange, .yellow, .green], startPoint: .topLeading, endPoint: .bottomTrailing), in: .capsule)
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .safeAreaPadding(.top, 60)
    }
}
