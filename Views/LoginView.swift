import SwiftUI
import MapKit

struct LoginView: View {
    
    @Binding var showLogin: Bool
    @Binding var isSatelliteMode: Bool
    
    @ObservedObject var viewModel: MapViewModel
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationStack {
                LoginViewOne(showLogin: $showLogin, isSatelliteMode: $isSatelliteMode, viewModel: viewModel, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
                    .toolbar(.hidden, for: .navigationBar)
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
    @Binding var isSatelliteMode: Bool
    
    @ObservedObject var viewModel: MapViewModel
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
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
                    LoginViewTwo(showLogin: $showLogin, isSatelliteMode: $isSatelliteMode, viewModel: viewModel, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
                        .toolbar(.hidden, for: .navigationBar)
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
    @Binding var isSatelliteMode: Bool
    
    @ObservedObject var viewModel: MapViewModel
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("Ci serve prima di tutto la tua posizione")
                        .font(.custom("Futura-bold", size: 24))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Psss! Non abbiamo accesso di alcun tipo ai tuoi dati, serve solo a te per vedere la tua posizione sulla mappa")
                        .font(.body)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(height: 150)
                .padding([.horizontal, .bottom], 20)
                
                Button {
                    viewModel.customInitialize()
                } label: {
                    Text(viewModel.locationManager.authorizationStatus == .notDetermined ? "Attiva la localizzazione" : viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse ? "Attivata!" : "Non attivata")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(viewModel.locationManager.authorizationStatus == .notDetermined ? .blue : viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse ? .green : .red, in: .capsule)
                }
                .disabled(viewModel.locationManager.authorizationStatus != .notDetermined)
                
                Spacer()
                
                if !viewModel.message.isEmpty {
                    Text(viewModel.message/*"Puoi sempre cambiare idea più tardi cliccando sul tasto a forma di aereoplanino di carta nella pagina del profilo"*/)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray4), Color(.systemGray5)] : [Color(.systemGray6), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray3), Color(.systemGray5)] : [Color(.white), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                                }
                        )
                }
                
                NavigationLink {
                    LoginViewThree(showLogin: $showLogin, isSatelliteMode: $isSatelliteMode, viewModel: viewModel, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
                        .toolbar(.hidden, for: .navigationBar)
                } label: {
                    Text("Proseguiamo!")
                        .font(.body.bold())
                        .foregroundStyle(viewModel.locationManager.authorizationStatus == .notDetermined ? .gray : .white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.locationManager.authorizationStatus == .notDetermined ? Color(.systemGray5) : .black, in: .capsule)
                }
                .disabled(viewModel.locationManager.authorizationStatus == .notDetermined)
            }
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .safeAreaPadding(.top, 60)
        .onAppear {
            viewModel.showMessage()
        }
    }
}

struct LoginViewThree: View {
    
    @Binding var showLogin: Bool
    @Binding var isSatelliteMode: Bool
    
    @ObservedObject var viewModel: MapViewModel
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @State private var nameSurnameTemp: String = ""
    @State private var selectedColorTemp: String = "blue"
    @State private var selectedNeighbourhoodStructTemp: Neighbourhood = .init(name: "", location: .init())
    @State private var selectedNeighbourhoodStructTempTwo: Neighbourhood = .init(name: "", location: .init())
    
    @State private var errorNameSurnameEmpty: Bool = false
    
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
                    
                    ProfileIconView(username: $nameSurnameTemp, color: $selectedColorTemp, size: .large)
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
                                        .opacity(selectedColorTemp.toColor()! == colorCase.color ? 1 : 0) // MARK: Modified
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
                        LoginViewFour(showLogin: $showLogin, isSatelliteMode: $isSatelliteMode, viewModel: viewModel, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodStructTemp: $selectedNeighbourhoodStructTemp, selectedNeighbourhoodStructTempTwo: $selectedNeighbourhoodStructTempTwo)
                            .toolbar(.hidden, for: .navigationBar)
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
        .onAppear {
            selectedNeighbourhoodStructTemp = Database.neighbourhoods.first(where: { $0.name == selectedNeighbourhood })!
            selectedNeighbourhoodStructTempTwo = selectedNeighbourhoodStructTemp
        }
    }
}

struct LoginViewFour: View {
    
    @Binding var showLogin: Bool
    @Binding var isSatelliteMode: Bool
    
    @ObservedObject var viewModel: MapViewModel
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @Binding var nameSurnameTemp: String
    @Binding var selectedColorTemp: String
    @Binding var selectedNeighbourhoodStructTemp: Neighbourhood
    @Binding var selectedNeighbourhoodStructTempTwo: Neighbourhood
    
    @State private var errorNameSurnameEmpty: Bool = false
    
    // Boolean value that controls the appearing of the second sheet, used to edit the user's neighbourhood
    @State private var isNeighbourhoodSelectorPresented: Bool = false
    
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
                            NeighbourhoodMarker(isSelected: .constant(true), neighbourhood: selectedNeighbourhoodStructTemp, isSatelliteMode: isSatelliteMode)
                        })
                    }
                    .mapStyle(
                        isSatelliteMode ? .hybrid(elevation: .realistic, pointsOfInterest: .all) : .standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .all, showsTraffic: false)
                    )
                    .frame(height: 200)
                    .cornerRadius(10)
                    .hoverEffect(.lift)
                    .shadow(color: .primary.opacity(0.1), radius: 10)
                }
                .padding(.all, 20)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 0.5)
                }
                .contentShape(.rect(cornerRadius: 12))
                .onTapGesture {
                    isNeighbourhoodSelectorPresented = true
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
                    LoginViewFive(showLogin: $showLogin, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood, nameSurnameTemp: $nameSurnameTemp, selectedColorTemp: $selectedColorTemp, selectedNeighbourhoodStructTemp: $selectedNeighbourhoodStructTemp)
                        .toolbar(.hidden, for: .navigationBar)
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
        .sheet(isPresented: $isNeighbourhoodSelectorPresented, onDismiss: {
            selectedNeighbourhoodStructTempTwo = selectedNeighbourhoodStructTemp
        }, content: {
            // Shows the Neighbourhood Selector sheet
            NeighbourhoodSelector(isSatelliteMode: $isSatelliteMode, viewModel: viewModel, selectedNeighbourhoodStructTemp: $selectedNeighbourhoodStructTemp, selectedNeighbourhoodStructTempTwo: $selectedNeighbourhoodStructTempTwo)
        })
    }
}

struct LoginViewFive: View {
    
    @Binding var showLogin: Bool
    
    @Binding var nameSurname: String
    @Binding var selectedColor: String
    @Binding var selectedNeighbourhood: String
    
    @Binding var nameSurnameTemp: String
    @Binding var selectedColorTemp: String
    @Binding var selectedNeighbourhoodStructTemp: Neighbourhood
    
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
                    selectedNeighbourhood = selectedNeighbourhoodStructTemp.name
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
