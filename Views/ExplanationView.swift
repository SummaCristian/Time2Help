import SwiftUI
import MapKit

struct ExplanationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // Connection to the ViewModel for Data and Location Permissions
    @ObservedObject var viewModel: MapViewModel
    
    let user: User
    
//    @AppStorage("showExplanation") var showExplanation: Bool = true
    @Binding var showExplanationTemp: Bool
    
    @State private var camera: MapCameraPosition = MapCameraPosition.automatic
    @Namespace private var mapNameSpace
    
    @State private var twoFavors: [Favor] = []
    @State private var twoFavorsTemp: [Favor] = []
    @State private var twoFavorsDatabase: Database = .init()
    @State private var onGoingFavor: Favor?
    
    @State private var showExitPopUp: Bool = false
    
    @State private var page: Int = 1
    
    @State private var showFavorsAnnotation: Bool = false
    @State private var showTitles: Bool = false
    
    @State private var showSecondPage: Bool = false
    
    @Namespace private var rewardNameSpace
    @State private var selectedFavor: Favor?
    @State private var selectedFavorID: UUID?
    
    @State private var selectedReward: Reward?
    
//    @State private var rect: MKMapRect = .null
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        if page < 9 || page == 11 {
                            Map(
                                position: $camera,
                                //                bounds: MapCameraBounds(centerCoordinateBounds: rect),
                                interactionModes: []
                            ) {
                                if showFavorsAnnotation {
                                    ForEach(twoFavors) { favor in
                                        if favor.type == .group {
                                            MapCircle(center: favor.location, radius: 35)
                                                .foregroundStyle(favor.category.color.opacity(0.2))
                                                .stroke(favor.category.color, lineWidth: 3)
                                                .mapOverlayLevel(level: .aboveRoads)
                                        }
                                        
                                        Annotation(
                                            coordinate: favor.location,
                                            content: {
                                                FavorMarker(favor: favor, isSelected: .constant(selectedFavorID == favor.id), isInFavorSheet: showTitles, isOwner: user.id == favor.author.id)
                                                    .onTapGesture {
                                                        if page == 2 {
                                                            selectedFavor = favor
                                                            selectedFavorID = favor.id
                                                            
                                                            page = 3
                                                        }
                                                    }
                                            },
                                            label: {
                                                // Label(favor.title, systemImage: favor.icon.icon)
                                            }
                                        )
                                    }
                                }
                            }
                            .onMapCameraChange(frequency: .continuous) { camera in
                                withAnimation {
                                    showFavorsAnnotation = camera.camera.distance < 10000
                                    showTitles = camera.camera.distance > 3000
                                    
                                    if camera.camera.distance < 10000 && !showSecondPage {
                                        showSecondPage = true
                                    }
                                }
                            }
                            .tint(.blue)
                            .safeAreaPadding(.top, 85)
                            .safeAreaPadding(.leading, 10)
                            .safeAreaPadding(.trailing, 10)
                            .safeAreaPadding(.bottom, 80)
                            .overlay {
                                if page >= 6 && page <= 10 {
                                    VStack(spacing: 5) {
                                        HStack(spacing: 0) {
//                                            Spacer()
                                            
                                            VStack(spacing: 0) {
                                                Image(systemName: "map.circle")
                                                    .font(.system(size: 25))
                                                    .fontWeight(.regular)
                                                    .foregroundStyle(.blue)
                                                    .frame(width: 50, height: 50)
                                                
                                                Text("3D")
                                                    .foregroundStyle(.blue)
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "location.fill")
                                                    .font(.system(size: 23))
                                                    .fontWeight(.regular)
                                                    .foregroundStyle(.blue)
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "building.2.crop.circle")
                                                    .font(.system(size: 25))
                                                    .foregroundStyle(.blue)
                                                    .frame(width: 50, height: 50)
                                            }
                                            .background {
                                                Capsule()
                                                    .foregroundStyle(.thinMaterial)
                                                    .shadow(color: .gray.opacity(0.4), radius: 6)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .padding([.trailing, .bottom], 5)
                                            .overlay(alignment: .bottomTrailing) {
                                                if page == 6 {
                                                    HStack(alignment: .bottom, spacing: 16) {
                                                        Text("Questo è il tasto per centrare la mappa sul tuo quartiere")
                                                            .font(.subheadline)
                                                            .multilineTextAlignment(.center)
                                                            .padding(.all, 20)
                                                            .background {
                                                                RoundedRectangle(cornerRadius: 32)
                                                                    .fill(.thinMaterial)
                                                                //                .opacity(0.25)
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 32)
                                                                            .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                                                    }
                                                            }
                                                            .padding(.leading, 20)
                                                        
                                                        Image(systemName: "arrow.forward")
                                                            .font(.title.bold())
                                                            .padding(.bottom, 15)
                                                        
                                                        Circle()
                                                            .stroke(.red, lineWidth: 4)
                                                            .frame(width: 60, height: 60)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        HStack(spacing: 0) {
                                            Spacer()
                                            
                                            MapCompass(scope: mapNameSpace)
                                                .padding(.trailing, 3)
                                                .disabled(true)
                                        }
                                        .padding(.trailing, 5)
                                        
                                        Spacer()
                                    }
                                    .padding(.top, 140)
                                    .padding(.trailing, 10)
                                }
                            }
                            .overlay {
                                if page >= 6 && page <= 10 {
                                    VStack {
                                        ZStack {
                                            Capsule()
                                                .frame(width: 86, height: 35)
                                                .foregroundStyle(.thinMaterial)
                                                .overlay {
                                                    Color.blue
                                                        .clipShape(Capsule())
                                                }
                                                .shadow(radius: 3)
                                                .offset(x: -37)
                                            
                                            HStack(spacing: 20) {
                                                HStack(spacing: 6) {
                                                    Image(systemName: "map.fill")
                                                        .font(.subheadline)
                                                        .foregroundStyle(.white)
                                                    
                                                    Text("Mappa")
                                                        .font(.caption.bold())
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                HStack(spacing: 6) {
                                                    Image(systemName: "rectangle.grid.1x2.fill")
                                                        .font(.subheadline)
                                                        .foregroundStyle(.primary)
                                                    
                                                    Text("Lista")
                                                        .font(.caption.bold())
                                                        .foregroundStyle(.primary)
                                                }
                                            }
                                            .padding()
                                        }
                                        .background {
                                            Capsule()
                                                .fill(.ultraThinMaterial)
                                                .shadow(color: .gray.opacity(0.4), radius: 6)
                                        }
                                        .padding(.top, 20)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .overlay {
                                if page >= 6 && page <= 10 {
                                    VStack {
                                        HStack(spacing: 10) {
                                            Image(systemName: "slider.horizontal.3")
                                                .font(.system(size: 20, weight: .medium))
                                                .padding(.all, 12)
                                                .foregroundStyle(.blue)
                                                .background(.thinMaterial)
                                            //                                        .frame(height: 60)
                                                .clipShape(Circle())
                                                .shadow(color: .gray.opacity(0.4), radius: 6)
                                            
                                            CategoryCapsule(filter: .init(), category: .all)
                                            
                                            Spacer()
                                        }
                                        .padding(.top, 86)
                                        .padding(.leading, 17.5)
                                        .disabled(true)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        } else {
                            ProfileView(isInExplanationView: true, showExplanationTemp: .constant(false), viewModel: viewModel, database: twoFavorsDatabase, selectedFavor: $selectedFavor, user: .constant(user), selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, isEditable: true, isEditFavorSheetPresented: .constant(false), showInteractedFavorOverlay: .constant(false), lastFavorInteracted: .constant(nil), lastInteraction: .constant(nil), ongoingFavor: .constant(nil))
                                .padding(.bottom, 68)
                                .disabled(page == 9)
                        }
                    }
                    //                    .scaleEffect(page > 6 ? 0.8 : 1)
                    .frame(maxWidth: .infinity, maxHeight: page > 6 && page <= 10 ? geometry.size.height - 80 : .infinity)
                    //                    .clipShape(page > 6 ? AnyShape(RoundedRectangle(cornerRadius: 32)) : AnyShape())
                    //                    .ignoresSafeArea()
                    .overlay {
                        if page == 7 || page == 8 || page == 9 {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.4)
                                .ignoresSafeArea()
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if page >= 7 && page <= 10 {
                            HStack(spacing: 0) {
                                VStack(spacing: 6) {
                                    Image(systemName: "map.fill")
                                        .font(.title3)
                                    
                                    Text("Mappa")
                                        .font(.caption2)
                                }
                                .foregroundStyle(page >= 9 ? .gray : .blue)
                                .frame(maxWidth: .infinity)
                                
                                Spacer()
                                    .frame(maxWidth: .infinity)
                                
                                VStack(spacing: 6) {
                                    Image(systemName: "person.fill")
                                        .font(.title3)
                                    
                                    Text("Profilo")
                                        .font(.caption2)
                                }
                                .foregroundStyle(page >= 9 ? .blue : .gray)
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical, 4)
                            .padding(.bottom, 20)
                            .background(.thinMaterial)
                            .overlay(alignment: .top) {
                                Rectangle()
                                    .foregroundStyle(.gray)
                                    .frame(height: 0.5)
                            }
                            .overlay {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                                    .frame(width: geometry.size.width/3, height: 65)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(.thinMaterial)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray3), Color(.systemGray5)] : [Color(.white), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                                            }
                                    )
                                    .offset(y: -15)
                            }
                        }
                    }
                    .overlay {
                        if page == 7 {
                            VStack {
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    
                                    OngoingFavorBoxView(favor: onGoingFavor!)
                                    .shadow(radius: 3)
                                }
                            }
                            .padding(.vertical, 24)
                            .padding(.horizontal)
                            .padding(.bottom, 72)
                        }
                    }
                    
                    if page > 6 && page <= 10 {
                        Spacer()
                    }
                }
                
                VStack(spacing: 20) {
                    if page == 6 || page == 9 {
                        Spacer()
                    }
                    
                    if page == 1 {
                        VStack(spacing: 12) {
                            Text("Eccoti qui, ti stavo aspettando!")
                                .font(.custom("Futura-bold", size: 24))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            Text("Ti va di fare un giro guidato nell'app in cui ti spiego le basi?")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 16) {
                                Button {
                                    withAnimation {
                                        page = 2
                                        
                                        let neighbourhoodCoordinateLocation = Database.neighbourhoods.first(where: { $0.name == user.neighbourhood })!.location
                                        
                                        camera = MapCameraPosition.camera(.init(centerCoordinate: neighbourhoodCoordinateLocation, distance: 2999))
                                    }
                                } label: {
                                    Text("Sì dai!")
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(.black, in: .capsule)
                                }
                                
                                Button {
                                    showExitPopUp = true
                                } label: {
                                    Text("Provo io l'applicazione")
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(.black, in: .capsule.stroke(lineWidth: 2))
                                }
                            }
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.all, 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .background {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.7)
                        }
                        .ignoresSafeArea()
                    } else if page == 2 && showSecondPage {
                        VStack(spacing: 12) {
                            Text("Questo è un esempio di quello che vedi nella schermata principale della mappa")
                                .font(.custom("Futura-bold", size: 20))
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            Text("Allontanandoti facendo un pizzico sulla mappa vedi solamente l'icona del favore; da vicino invece, come in questo caso, vedi anche il titolo e l'icona delle persone che hanno accettato il favore")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            
                            Text("In questo esempio vedi 2 favori, prova a cliccarne uno dei 2")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.all, 20)
    //                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    } else if page == 3 && selectedFavor != nil {
                        VStack(spacing: 12) {
                            Text("Come vedi il segnaposto è " + (user.id == selectedFavor!.author.id ? "esagonale: questo vuol dire che è un favore creato da te" : "tondo: questo significa che il favore è stato creato da altri"))
                                .font(.custom("Futura-bold", size: 16))
                                .multilineTextAlignment(.center)
                            //                        .padding(.horizontal, 20)
                            Text("Puoi vedere i vari dettagli del favore: titolo, descrizione, chi l'ha richiesto, se è pensato per esser fatto da una sola persona o in gruppo, chi l'ha accettato, il profilo di chi l'ha richiesto o accettato, lo stato, gli orari, le informazioni aggiuntive e la posizione")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                            //                        .padding(.horizontal, 20)
                            Text("Inoltre essendo " + (user.id == selectedFavor!.author.id ? "tuo puoi modificarlo e eliminarlo quando vuoi!" : "un favore di un'altra persona, potresti accettarlo se non fosse completato"))
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                            //                            .padding(.horizontal, 20)
                            Text("Scorri un po' nei dettagli e quando vuoi trascina in basso la pagina per uscire dalla schermata dei dettagli")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                            //                        .padding(.horizontal, 20)
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 20)
    //                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    } else if page == 4 {
                        VStack(spacing: 12) {
                            Text("Come vedi l'altro ha una forma diversa")
                                .font(.custom("Futura-bold", size: 24))
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            Text("L'altro favore è " + (user.id == twoFavorsTemp.first!.author.id ? "esagonale, ovvero è stato creato da te" : "tondo, ovvero è stato creato da un'altra persona"))
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            if user.id == twoFavorsTemp.first!.author.id {
                                Text("Essendo tuo, potrai modificarlo e eliminarlo quando vuoi tramite gli appositi tasti, che sono come li vedi qui sotto")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
    //                                .padding(.horizontal, 20)
                                
                                HStack {
                                    Text("Modifica")
                                        .font(.callout)
                                        .foregroundStyle(.orange)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 16)
                                        .background(.orange.opacity(0.2), in: .capsule)
                                    
                                    Spacer()
                                    
                                    Text("Elimina")
                                        .font(.callout)
                                        .foregroundStyle(.red)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 16)
                                        .background(.red.opacity(0.2), in: .capsule)
                                }
                                .padding(.all, 20)
                                .background(Color(.systemGray6), in: .rect(cornerRadius: 12))
                                .padding(.top, 8)
                            }
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 20)
    //                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    } else if page == 5 {
                        VStack(spacing: 12) {
                            Text("Zoomando avanti ancora di più su un favore, potresti vedere che ha un cerchio")
                                .font(.custom("Futura-bold", size: 24))
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            Text("Questo vuole dire che il favore è stato pensato da svolgersi in gruppo")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            Text("Se invece non c'è, vuol dire che il favore è pensato da svolgersi da una persona")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
    //                                .padding(.horizontal, 20)
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 20)
    //                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    } else if page == 6 {
                        VStack(spacing: 12) {
                            Text("Così è come vedi la mappa")
                                .font(.custom("Futura-bold", size: 24))
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            Text("Lascio esplorare a te i filtri, il passaggio da mappa a lista e i bottoni della mappa")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
    //                            .padding(.horizontal, 20)
                            Text("Ti dico solo che puoi filtrare i favori nella mappa o lista in base alla categoria, al giorno, alla durata, a se sono pensati per una sola persona o un gruppo, a se serve avere una macchina e a se sono favori pesanti")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
    //                                .padding(.horizontal, 20)
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 20)
                    } else if page == 7 {
                        VStack(spacing: 12) {
                            Text("L'applicazione in basso presenta una barra per cambiare tra 3 diverse schermate")
                                .font(.custom("Futura-bold", size: 20))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            Text("La schermata della mappa, per creare un nuovo favore e del profilo")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            Text("Se subito sopra sulla destra vedi un box così, vuol dire che hai un favore in corso e puoi accederci direttamente da qui senza dover andare nel tuo profilo")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 20)
                    } else if page == 8 {
                        VStack(spacing: 12) {
                            Text("Anche per la schermata Nuovo Favore ti lascio esplorare")
                                .font(.custom("Futura-bold", size: 24))
                                .multilineTextAlignment(.center)
//                                .padding(.horizontal, 20)
                            Text("Ti dico solo che quando crei un nuovo favore ovviamente ci sono come campi obbligatori il titolo e descrizione e senza di questi il tasto Richiedi Favore sarà disattivato")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            Text("Inoltre per le fasce orarie, quando ne aggiungi più di una, vedrai l'icona qui sotto che tenendola premuta ti permetterà di riordinare le fasce come preferisci")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                Spacer()
                                
                                Image(systemName: "line.horizontal.3")
                                    .foregroundStyle(.gray)
                            }
                            .padding(.all, 20)
                            .background(Color(.systemGray6), in: .rect(cornerRadius: 12))
                            .padding(.top, 8)
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.horizontal, 20)
                    } else if page == 9 {
                        VStack(spacing: 12) {
                            Text("Questa è la schermata del profilo")
                                .font(.custom("Futura-bold", size: 24))
                                .multilineTextAlignment(.center)
//                                .padding(.horizontal, 20)
                            
                            Text("Qui puoi modificare il tuo nome, il tuo colore del profilo e il tuo quartiere")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            Text("Nella schermata trovi anche i bottoni per vedere i favori che hai richiesto e quelli che hai accettato da altre persone")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            Text("In alto a destra hai i tasti per vedere le domande frequenti e per andare nelle impostazioni a cambiare le preferenze sulla localizzazione")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            Text("In basso infine vedi i riconoscimenti che hai ottenuto, che rappresentano quanto ti stai impegnando per la comunità")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            Text("Mi sposto un attimo e te la lascio guardare un attimo!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .frame(maxHeight: .infinity)
                        .padding(.horizontal, 20)
//                        .padding(.bottom, 68)
                    } else if page == 10 {
                        
                    } else if page == 11 {
                        VStack(spacing: 12) {
                            Text("Abbiamo finito il giro!")
                                .font(.custom("Futura-bold", size: 24))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            Text("Divertente?")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            Text("Puoi trovarmi quando vuoi nella pagina delle Faq nel tuo profilo, a presto!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 8)
                            
                            Button {
                                withAnimation {
                                    showExplanationTemp = false
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "xmark")
                                        
                                    Text("Esci dal giro guidato")
                                }
                                .bold()
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.all, 20)
                                .background {
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(.thinMaterial)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 32)
                                                .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                        }
                                }
                            }
                        }
                        .padding(.all, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.thinMaterial)
                            //                .opacity(0.25)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                }
                        }
                        .padding(.all, 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .background {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.7)
                        }
                        .ignoresSafeArea()
                    }
                    
                    if page != 1 && page != 6 && page != 9 && page != 11 {
                        Spacer()
                    }
                    
                    if showSecondPage && page <= 10 {
                        HStack(spacing: 12) {
                            Button {
                                showExitPopUp = true
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.title2.bold())
                                    .foregroundStyle(.red)
                                    .padding(.all, 20)
                                    .background {
                                        RoundedRectangle(cornerRadius: 32)
                                            .fill(.thinMaterial)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 32)
                                                    .stroke(colorScheme == .dark ? Color(.systemGray3) : Color(.white), lineWidth: 2)
                                            }
                                    }
                            }
                            
                            if page != 4 && page != 5 && page < 6 {
                                Spacer()
                            }
                            
                            if page == 4 || page == 5 || page >= 6 {
                                Button {
                                    withAnimation {
                                        if page == 4 {
                                            page = 5
                                            
                                            camera = MapCameraPosition.camera(.init(centerCoordinate: twoFavors.last!.location, distance: 1500))
                                        } else if page == 5 {
                                            page = 6
                                            
                                            let neighbourhoodCoordinateLocation = Database.neighbourhoods.first(where: { $0.name == user.neighbourhood })!.location
                                            
                                            camera = MapCameraPosition.camera(.init(centerCoordinate: neighbourhoodCoordinateLocation, distance: 2999))
                                        } else if page >= 6 && page <= 10 {
                                            page += 1
                                        }
                                        
                                        if page == 11 {
                                            let neighbourhoodCoordinateLocation = Database.neighbourhoods.first(where: { $0.name == user.neighbourhood })!.location
                                            
                                            camera = MapCameraPosition.camera(.init(centerCoordinate: neighbourhoodCoordinateLocation, distance: .infinity))
                                        }
                                    }
                                } label: {
                                    Text(page == 9 ? "Guarda meglio" : "Andiamo avanti!")
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 20)
                                        .frame(maxWidth: .infinity)
                                        .background(.black, in: .capsule)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .alert("Vuoi uscire?", isPresented: $showExitPopUp) {
            Button("No", role: .cancel) {}
            Button("Sì", role: .destructive) {
                withAnimation {
                    showExplanationTemp = false
                }
            }
        } message: {
            Text("Puoi comunque provare la visita guidata dalla pagina delle Faq")
        }
        .sheet(
            item: $selectedFavor,
            onDismiss: {
                withAnimation {
                    page = 4
                    
                    twoFavorsTemp.removeAll(where: { $0.id == selectedFavorID })
                    
                    selectedFavor = nil
                    selectedFavorID = nil
                }
            },
            content: { favor in
                FavorDetailsSheet(isInExplanationView: true, viewModel: viewModel, database: twoFavorsDatabase, selectedFavor: $selectedFavor, user: user, favor: favor, selectedReward: .constant(nil), rewardNameSpace: rewardNameSpace, isEditFavorSheetPresented: .constant(false), showInteractedFavorOverlay: .constant(false), lastFavorInteracted: .constant(nil), lastInteraction: .constant(nil), ongoingFavor: .constant(nil))
            }
        )
        .onAppear {
            let neighbourhoodCoordinateLocation = Database.neighbourhoods.first(where: { $0.name == user.neighbourhood })!.location
//
            camera = MapCameraPosition.camera(.init(centerCoordinate: neighbourhoodCoordinateLocation, distance: .infinity))
            
            let mario = User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant(user.neighbourhood), profilePictureColor: .constant("red"))
            let giuseppe = User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant(user.neighbourhood), profilePictureColor: .constant("green"))
            let piera = User(nameSurname: .constant("Piera Capuana"), neighbourhood: .constant(user.neighbourhood), profilePictureColor: .constant("brown"))
//                                                            // 45.472982, 9.230421
            twoFavors = [ // 45.478841, 9.227155  45.476903, longitude: 9.230091)
                Favor(title: "Trasporto pacchi", description: "Devo portare dei pacchi al mercato, qualcuno può darmi un passaggio?", author: user, neighbourhood: user.neighbourhood, type: .individual, location: .init(latitude: neighbourhoodCoordinateLocation.latitude - 0.000828, longitude: neighbourhoodCoordinateLocation.longitude - 0.002557), isCarNecessary: true, isHeavyTask: true, status: .notAcceptedYet, category: .transport),
                Favor(title: "Sistemare aiuole", description: "Le aiuole si sono riempite di foglie, vanno spazzate e ripulite", author: mario, neighbourhood: user.neighbourhood, type: .group, location: .init(latitude: neighbourhoodCoordinateLocation.latitude - 0.003921, longitude: neighbourhoodCoordinateLocation.longitude + 0.00033), isCarNecessary: false, isHeavyTask: true, status: .completed, category: .gardening),
            ]
//            
            twoFavors.first!.helpers.append(piera)
            twoFavors.last!.helpers.append(giuseppe)
            twoFavors.last!.helpers.append(piera)
            
            let reviewGiuseppe = FavorReview(author: giuseppe, rating: 4, text: "This is a review")
            let reviewPiera = FavorReview(author: piera, rating: 3, text: "This is a review")
            twoFavors.last!.reviews.append(reviewGiuseppe)
            twoFavors.last!.reviews.append(reviewPiera)
            
            twoFavorsTemp = twoFavors
            
            twoFavorsDatabase.favors = twoFavors
            
            onGoingFavor = Favor(
                title: "Aiuto per lavare dei cani",
                description: "L'organizzazione di volontariato ha organizzato un lavaggio per i cani del canile.\nServe aiuto da quante più persone possibili!",
                author: user,
                neighbourhood: user.neighbourhood,
                type: .group,
                location: neighbourhoodCoordinateLocation,
                isCarNecessary: true,
                isHeavyTask: true,
                status: .ongoing,
                category: .petSitting
            )
            onGoingFavor!.helpers.append(giuseppe)
            onGoingFavor!.helpers.append(mario)
        }
    }
}
