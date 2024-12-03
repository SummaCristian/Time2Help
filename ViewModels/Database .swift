import Foundation
import MapKit

// This class handles the saving of the Favors, acting as a Database

class Database: ObservableObject {
    
    static let shared = Database()
    
    // The List of Favors, accessible by others
    @Published var favors: [Favor] = []
    
    // The List of Users
    @Published var users: [User] = []
    
    // The User's Name
    @Published var userName: String = "Nome Cognome"
    
    static let neighbourhoods: [Neighbourhood] = [
        Neighbourhood(
            name: "5 Vie",
            location: CLLocationCoordinate2D(latitude: 45.462742, longitude: 9.184675)
        ),
        Neighbourhood(
            name: "Abbadesse",
            location: CLLocationCoordinate2D(latitude: 45.491327, longitude: 9.197281)
        ),
        Neighbourhood(
            name: "Adriano",
            location: CLLocationCoordinate2D(latitude: 45.512132, longitude: 9.246504)
        ),
        Neighbourhood(
            name: "Acquabella",
            location: CLLocationCoordinate2D(latitude: 45.468955, longitude: 9.231260)
        ),
        Neighbourhood(
            name: "Affori",
            location: CLLocationCoordinate2D(latitude: 45.519712, longitude: 9.169996)
        ),
        Neighbourhood(
            name: "Arzaga",
            location: CLLocationCoordinate2D(latitude: 45.456263, longitude: 9.135951)
        ),
        Neighbourhood(
            name: "Baggio",
            location: CLLocationCoordinate2D(latitude: 45.460727, longitude: 9.094342)
        ),
        Neighbourhood(
            name: "Barona",
            location: CLLocationCoordinate2D(latitude: 45.435792, longitude: 9.154552)
        ),
        Neighbourhood(
            name: "Bicocca",
            location: CLLocationCoordinate2D(latitude: 45.517203, longitude: 9.212220)
        ),
        Neighbourhood(
            name: "Boffalora",
            location: CLLocationCoordinate2D(latitude: 45.427512, longitude: 9.139701)
        ),
        Neighbourhood(
            name: "Borgo Ortolani",
            location: CLLocationCoordinate2D(latitude: 45.479548, longitude: 9.176451)
        ),
        Neighbourhood(
            name: "Bovisa",
            location: CLLocationCoordinate2D(latitude: 45.503611, longitude: 9.164396)
        ),
        Neighbourhood(
            name: "Bovisasca",
            location: CLLocationCoordinate2D(latitude: 45.516749, longitude: 9.156383)
        ),
        Neighbourhood(
            name: "Brera",
            location: CLLocationCoordinate2D(latitude: 45.473007, longitude: 9.187959)
        ),
        Neighbourhood(
            name: "Brolo",
            location: CLLocationCoordinate2D(latitude: 45.460392, longitude: 9.192371)
        ),
        Neighbourhood(
            name: "Bruzzano",
            location: CLLocationCoordinate2D(latitude: 45.523064, longitude: 9.174694)
        ),
        Neighbourhood(
            name: "Bullona",
            location: CLLocationCoordinate2D(latitude: 45.487826, longitude: 9.166534)
        ),
        Neighbourhood(
            name: "Ca' Granda",
            location: CLLocationCoordinate2D(latitude: 45.507310, longitude: 9.184907)
        ),
        Neighbourhood(
            name: "Cagnola",
            location: CLLocationCoordinate2D(latitude: 45.492787, longitude: 9.145912)
        ),
        Neighbourhood(
            name: "Calvairate",
            location: CLLocationCoordinate2D(latitude: 45.456187, longitude: 9.224234)
        ),
        Neighbourhood(
            name: "Carrobbio",
            location: CLLocationCoordinate2D(latitude: 45.460125, longitude: 9.181603)
        ),
        Neighbourhood(
            name: "Cascina Gobba",
            location: CLLocationCoordinate2D(latitude: 45.508660, longitude: 9.262038)
        ),
        Neighbourhood(
            name: "Castello",
            location: CLLocationCoordinate2D(latitude: 45.469779, longitude: 9.179568)
        ),
        Neighbourhood(
            name: "Cavriano",
            location: CLLocationCoordinate2D(latitude: 45.466226, longitude: 9.243192)
        ),
        Neighbourhood(
            name: "Cascina dei pomi",
            location: CLLocationCoordinate2D(latitude: 45.498883, longitude: 9.208807)
        ),
        Neighbourhood(
            name: "Casoretto",
            location: CLLocationCoordinate2D(latitude: 45.487468, longitude: 9.226117)
        ),
        Neighbourhood(
            name: "Castagnedo",
            location: CLLocationCoordinate2D(latitude: 45.443821, longitude: 9.231299)
        ),
        Neighbourhood(
            name: "Centrale",
            location: CLLocationCoordinate2D(latitude: 45.483997, longitude: 9.203955)
        ),
        Neighbourhood(
            name: "Centro Direzionale",
            location: CLLocationCoordinate2D(latitude: 45.485370, longitude: 9.196911)
        ),
        Neighbourhood(
            name: "Cermenate",
            location: CLLocationCoordinate2D(latitude: 45.440857, longitude: 9.181620)
        ),
        Neighbourhood(
            name: "Certosa",
            location: CLLocationCoordinate2D(latitude: 45.500366, longitude: 9.129210)
        ),
        Neighbourhood(
            name: "Chiama",
            location: CLLocationCoordinate2D(latitude: 45.455908, longitude: 9.140069)
        ),
        Neighbourhood(
            name: "Chiesa Rossa",
            location: CLLocationCoordinate2D(latitude: 45.433143, longitude: 9.180682)
        ),
        Neighbourhood(
            name: "Chinatown",
            location: CLLocationCoordinate2D(latitude: 45.482099, longitude: 9.171188)
        ),
        Neighbourhood(
            name: "Cimiano",
            location: CLLocationCoordinate2D(latitude: 45.501228, longitude: 9.244629)
        ),
        Neighbourhood(
            name: "Città Studi",
            location: CLLocationCoordinate2D(latitude: 45.476903, longitude: 9.230091)
        ),
        Neighbourhood(
            name: "Comasina",
            location: CLLocationCoordinate2D(latitude: 45.525258, longitude: 9.164998)
        ),
        Neighbourhood(
            name: "Conca Fallata",
            location: CLLocationCoordinate2D(latitude: 45.425180, longitude: 9.166888)
        ),
        Neighbourhood(
            name: "Corvetto",
            location: CLLocationCoordinate2D(latitude: 45.436873, longitude: 9.216822)
        ),
        Neighbourhood(
            name: "Crescenzago",
            location: CLLocationCoordinate2D(latitude: 45.507610, longitude: 9.249255)
        ),
        Neighbourhood(
            name: "Crocetta",
            location: CLLocationCoordinate2D(latitude: 45.456136, longitude: 9.196003)
        ),
        Neighbourhood(
            name: "Cuccagna",
            location: CLLocationCoordinate2D(latitude: 45.451923, longitude: 9.212689)
        ),
        Neighbourhood(
            name: "Derganino",
            location: CLLocationCoordinate2D(latitude: 45.498076, longitude: 9.168580)
        ),
        Neighbourhood(
            name: "Dergano",
            location: CLLocationCoordinate2D(latitude: 45.505256, longitude: 9.175577)
        ),
        Neighbourhood(
            name: "Duomo",
            location: CLLocationCoordinate2D(latitude: 45.463838, longitude: 9.190452)
        ),
        Neighbourhood(
            name: "Feltre",
            location: CLLocationCoordinate2D(latitude: 45.490895, longitude: 9.253343)
        ),
        Neighbourhood(
            name: "Fiera",
            location: CLLocationCoordinate2D(latitude: 45.473484, longitude: 9.147888)
        ),
        Neighbourhood(
            name: "Forlanini",
            location: CLLocationCoordinate2D(latitude: 45.459111, longitude: 9.246788)
        ),
        Neighbourhood(
            name: "Forze Armate",
            location: CLLocationCoordinate2D(latitude: 45.460511, longitude: 9.115723)
        ),
        Neighbourhood(
            name: "Gallaratese",
            location: CLLocationCoordinate2D(latitude: 45.497172, longitude: 9.110935)
        ),
        Neighbourhood(
            name: "Gorla",
            location: CLLocationCoordinate2D(latitude: 45.507486, longitude: 9.224814)
        ),
        Neighbourhood(
            name: "Gentilino",
            location: CLLocationCoordinate2D(latitude: 45.446002, longitude: 9.181089)
        ),
        Neighbourhood(
            name: "Ghisolfa",
            location: CLLocationCoordinate2D(latitude: 45.491271, longitude: 9.161419)
        ),
        Neighbourhood(
            name: "Giambellino",
            location: CLLocationCoordinate2D(latitude: 45.446524, longitude: 9.134626)
        ),
        Neighbourhood(
            name: "Gratosoglio",
            location: CLLocationCoordinate2D(latitude: 45.411943, longitude: 9.172871)
        ),
        Neighbourhood(
            name: "Greco",
            location: CLLocationCoordinate2D(latitude: 45.502390, longitude: 9.210635)
        ),
        Neighbourhood(
            name: "Guastalla",
            location: CLLocationCoordinate2D(latitude: 45.459792, longitude: 9.198732)
        ),
        Neighbourhood(
            name: "Isola",
            location: CLLocationCoordinate2D(latitude: 45.493191, longitude: 9.190696)
        ),
        Neighbourhood(
            name: "Niguarda",
            location: CLLocationCoordinate2D(latitude: 45.515150, longitude: 9.193983)
        ),
        Neighbourhood(
            name: "Nolo",
            location: CLLocationCoordinate2D(latitude: 45.493670, longitude: 9.218800)
        ),
        Neighbourhood(
            name: "La Maddalena",
            location: CLLocationCoordinate2D(latitude: 45.460865, longitude: 9.151090)
        ),
        Neighbourhood(
            name: "Lambrate",
            location: CLLocationCoordinate2D(latitude: 45.481806, longitude: 9.244735)
        ),
        Neighbourhood(
            name: "Lampugnano",
            location: CLLocationCoordinate2D(latitude: 45.488431, longitude: 9.124348)
        ),
        Neighbourhood(
            name: "Lorenteggio",
            location: CLLocationCoordinate2D(latitude: 45.446057, longitude: 9.118529)
        ),
        Neighbourhood(
            name: "Macconago",
            location: CLLocationCoordinate2D(latitude: 45.413584, longitude: 9.210903)
        ),
        Neighbourhood(
            name: "Maggiolina",
            location: CLLocationCoordinate2D(latitude: 45.496112, longitude: 9.202115)
        ),
        Neighbourhood(
            name: "Mind",
            location: CLLocationCoordinate2D(latitude: 45.518479, longitude: 9.099203)
        ),
        Neighbourhood(
            name: "Missori",
            location: CLLocationCoordinate2D(latitude: 45.460498, longitude: 9.187882)
        ),
        Neighbourhood(
            name: "Molinazzo",
            location: CLLocationCoordinate2D(latitude: 45.463815, longitude: 9.136540)
        ),
        Neighbourhood(
            name: "Moncucco",
            location: CLLocationCoordinate2D(latitude: 45.442011, longitude: 9.168530)
        ),
        Neighbourhood(
            name: "Monluè",
            location: CLLocationCoordinate2D(latitude: 45.456692, longitude: 9.258482)
        ),
        Neighbourhood(
            name: "Montalbino",
            location: CLLocationCoordinate2D(latitude: 45.501636, longitude: 9.192677)
        ),
        Neighbourhood(
            name: "Morivione",
            location: CLLocationCoordinate2D(latitude: 45.439784, longitude: 9.193632)
        ),
        Neighbourhood(
            name: "Morsenchio",
            location: CLLocationCoordinate2D(latitude: 45.444426, longitude: 9.240094)
        ),
        Neighbourhood(
            name: "Musocco",
            location: CLLocationCoordinate2D(latitude: 45.507124, longitude: 9.118348)
        ),
        Neighbourhood(
            name: "Navigli",
            location: CLLocationCoordinate2D(latitude: 45.449893, longitude: 9.172550)
        ),
        Neighbourhood(
            name: "Nosedo",
            location: CLLocationCoordinate2D(latitude: 45.425643, longitude: 9.225203)
        ),
        Neighbourhood(
            name: "Novegro",
            location: CLLocationCoordinate2D(latitude: 45.470203, longitude: 9.268681)
        ),
        Neighbourhood(
            name: "Orti",
            location: CLLocationCoordinate2D(latitude: 45.456320, longitude: 9.201071)
        ),
        Neighbourhood(
            name: "Ortica",
            location: CLLocationCoordinate2D(latitude: 45.473044, longitude: 9.244596)
        ),
        Neighbourhood(
            name: "Pagano",
            location: CLLocationCoordinate2D(latitude: 45.468384, longitude: 9.160651)
        ),
        Neighbourhood(
            name: "Parco Certosa",
            location: CLLocationCoordinate2D(latitude: 45.508487, longitude: 9.142264)
        ),
        Neighbourhood(
            name: "Parco Nord",
            location: CLLocationCoordinate2D(latitude: 45.517077, longitude: 9.182404)
        ),
        Neighbourhood(
            name: "Ponte Lambro",
            location: CLLocationCoordinate2D(latitude: 45.440865, longitude: 9.261640)
        ),
        Neighbourhood(
            name: "Ponte Nuovo",
            location: CLLocationCoordinate2D(latitude: 45.506539, longitude: 9.236743)
        ),
        Neighbourhood(
            name: "Ponte Seveso",
            location: CLLocationCoordinate2D(latitude: 45.492818, longitude: 9.207793)
        ),
        Neighbourhood(
            name: "Porta Garibaldi",
            location: CLLocationCoordinate2D(latitude: 45.483213, longitude: 9.186513)
        ),
        Neighbourhood(
            name: "Porta Genova",
            location: CLLocationCoordinate2D(latitude: 45.457127, longitude: 9.172204)
        ),
        Neighbourhood(
            name: "Porta Lodovica",
            location: CLLocationCoordinate2D(latitude: 45.451884, longitude: 9.186675)
        ),
        Neighbourhood(
            name: "Porta Magenta",
            location: CLLocationCoordinate2D(latitude: 45.467694, longitude: 9.173031)
        ),
        Neighbourhood(
            name: "Porta Monforte",
            location: CLLocationCoordinate2D(latitude: 45.466787, longitude: 9.205482)
        ),
        Neighbourhood(
            name: "Porta Nuova",
            location: CLLocationCoordinate2D(latitude: 45.475690, longitude: 9.195014)
        ),
        Neighbourhood(
            name: "Porta Romana",
            location: CLLocationCoordinate2D(latitude: 45.451858, longitude: 9.202693)
        ),
        Neighbourhood(
            name: "Porta Tenaglia",
            location: CLLocationCoordinate2D(latitude: 45.477031, longitude: 9.180263)
        ),
        Neighbourhood(
            name: "Porta Ticinese",
            location: CLLocationCoordinate2D(latitude: 45.448861, longitude: 9.179738)
        ),
        Neighbourhood(
            name: "Porta Venezia",
            location: CLLocationCoordinate2D(latitude: 45.474741, longitude: 9.205351)
        ),
        Neighbourhood(
            name: "Porta Vercellina",
            location: CLLocationCoordinate2D(latitude: 45.464217, longitude: 9.159105)
        ),
        Neighbourhood(
            name: "Porta Vigentina",
            location: CLLocationCoordinate2D(latitude: 45.450967, longitude: 9.196865)
        ),
        Neighbourhood(
            name: "Porta Vittoria",
            location: CLLocationCoordinate2D(latitude: 45.460881, longitude: 9.211406)
        ),
        Neighbourhood(
            name: "Porta Volta",
            location: CLLocationCoordinate2D(latitude: 45.485814, longitude: 9.178711)
        ),
        Neighbourhood(
            name: "Portello",
            location: CLLocationCoordinate2D(latitude: 45.485078, longitude: 9.152180)
        ),
        Neighbourhood(
            name: "Porto Di Mare",
            location: CLLocationCoordinate2D(latitude: 45.432539, longitude: 9.230305)
        ),
        Neighbourhood(
            name: "Prato Centenaro",
            location: CLLocationCoordinate2D(latitude: 45.510516, longitude: 9.200856)
        ),
        Neighbourhood(
            name: "Precotto",
            location: CLLocationCoordinate2D(latitude: 45.513414, longitude: 9.221667)
        ),
        Neighbourhood(
            name: "Primaticcio Corba",
            location: CLLocationCoordinate2D(latitude: 45.455015, longitude: 9.124475)
        ),
        Neighbourhood(
            name: "Quadrilatero",
            location: CLLocationCoordinate2D(latitude: 45.468169, longitude: 9.195308)
        ),
        Neighbourhood(
            name: "Quarto Cagnino",
            location: CLLocationCoordinate2D(latitude: 45.474313, longitude: 9.110014)
        ),
        Neighbourhood(
            name: "Quarto Oggiaro",
            location: CLLocationCoordinate2D(latitude: 45.514686, longitude: 9.139343)
        ),
        Neighbourhood(
            name: "Quinto Romano",
            location: CLLocationCoordinate2D(latitude: 45.478347, longitude: 9.089092)
        ),
        Neighbourhood(
            name: "Quintosole",
            location: CLLocationCoordinate2D(latitude: 45.402202, longitude: 9.204783)
        ),
        Neighbourhood(
            name: "Risorgimento",
            location: CLLocationCoordinate2D(latitude: 45.469981, longitude: 9.213036)
        ),
        Neighbourhood(
            name: "Rogoredo",
            location: CLLocationCoordinate2D(latitude: 45.431770, longitude: 9.246821)
        ),
        Neighbourhood(
            name: "Ronchetto Sul Naviglio",
            location: CLLocationCoordinate2D(latitude: 45.444039, longitude: 9.138898)
        ),
        Neighbourhood(
            name: "Roserio",
            location: CLLocationCoordinate2D(latitude: 45.518312, longitude: 9.121626)
        ),
        Neighbourhood(
            name: "Rottole",
            location: CLLocationCoordinate2D(latitude: 45.493173, longitude: 9.235104)
        ),
        Neighbourhood(
            name: "Rubattino",
            location: CLLocationCoordinate2D(latitude: 45.480738, longitude: 9.260287)
        ),
        Neighbourhood(
            name: "San Babila",
            location: CLLocationCoordinate2D(latitude: 45.466377, longitude: 9.197600)
        ),
        Neighbourhood(
            name: "San Cristoforo",
            location: CLLocationCoordinate2D(latitude: 45.443406, longitude: 9.159403)
        ),
        Neighbourhood(
            name: "San Siro",
            location: CLLocationCoordinate2D(latitude: 45.476282, longitude: 9.121079)
        ),
        Neighbourhood(
            name: "San Vittore",
            location: CLLocationCoordinate2D(latitude: 45.462678, longitude: 9.168244)
        ),
        Neighbourhood(
            name: "Sant'Ambrogio",
            location: CLLocationCoordinate2D(latitude: 45.462252, longitude: 9.175975)
        ),
        Neighbourhood(
            name: "Santa Giulia",
            location: CLLocationCoordinate2D(latitude: 45.437106, longitude: 9.241830)
        ),
        Neighbourhood(
            name: "Santa Sofia",
            location: CLLocationCoordinate2D(latitude: 45.457003, longitude: 9.190423)
        ),
        Neighbourhood(
            name: "Scala",
            location: CLLocationCoordinate2D(latitude: 45.467211, longitude: 9.189801)
        ),
        Neighbourhood(
            name: "Scalo Farini",
            location: CLLocationCoordinate2D(latitude: 45.493428, longitude: 9.177866)
        ),
        Neighbourhood(
            name: "Scalo Romana",
            location: CLLocationCoordinate2D(latitude: 45.439695, longitude: 9.205838)
        ),
        Neighbourhood(
            name: "Segnano",
            location: CLLocationCoordinate2D(latitude: 45.505175, longitude: 9.204425)
        ),
        Neighbourhood(
            name: "Sella Nuova",
            location: CLLocationCoordinate2D(latitude: 45.455136, longitude: 9.106602)
        ),
        Neighbourhood(
            name: "Selvanesco",
            location: CLLocationCoordinate2D(latitude: 45.418672, longitude: 9.194426)
        ),
        Neighbourhood(
            name: "Sempione",
            location: CLLocationCoordinate2D(latitude: 45.476811, longitude: 9.170791)
        ),
        Neighbourhood(
            name: "Senavra",
            location: CLLocationCoordinate2D(latitude: 45.463443, longitude: 9.229501)
        ),
        Neighbourhood(
            name: "Simonetta",
            location: CLLocationCoordinate2D(latitude: 45.489916, longitude: 9.169629)
        ),
        Neighbourhood(
            name: "Solari",
            location: CLLocationCoordinate2D(latitude: 45.456093, longitude: 9.159746)
        ),
        Neighbourhood(
            name: "Stephenson",
            location: CLLocationCoordinate2D(latitude: 45.512178, longitude: 9.119378)
        ),
        Neighbourhood(
            name: "Taliedo Mecenate",
            location: CLLocationCoordinate2D(latitude: 45.451256, longitude: 9.250232)
        ),
        Neighbourhood(
            name: "Tertulliano",
            location: CLLocationCoordinate2D(latitude: 45.448570, longitude: 9.218234)
        ),
        Neighbourhood(
            name: "Torretta",
            location: CLLocationCoordinate2D(latitude: 45.435135, longitude: 9.170406)
        ),
        Neighbourhood(
            name: "Tre Torri",
            location: CLLocationCoordinate2D(latitude: 45.473973, longitude: 9.155238)
        ),
        Neighbourhood(
            name: "Trenno",
            location: CLLocationCoordinate2D(latitude: 45.491645, longitude: 9.101080)
        ),
        Neighbourhood(
            name: "Triulzo Superiore",
            location: CLLocationCoordinate2D(latitude: 45.426730, longitude: 9.250570)
        ),
        Neighbourhood(
            name: "Turro",
            location: CLLocationCoordinate2D(latitude: 45.499770, longitude: 9.225952)
        ),
        Neighbourhood(
            name: "Varesine",
            location: CLLocationCoordinate2D(latitude: 45.481854, longitude: 9.196479)
        ),
        Neighbourhood(
            name: "Verziere",
            location: CLLocationCoordinate2D(latitude: 45.463053, longitude: 9.195811)
        ),
        Neighbourhood(
            name: "Vetra",
            location: CLLocationCoordinate2D(latitude: 45.458165, longitude: 9.184376)
        ),
        Neighbourhood(
            name: "Vialba",
            location: CLLocationCoordinate2D(latitude: 45.515697, longitude: 9.127746)
        ),
        Neighbourhood(
            name: "Vigentino",
            location: CLLocationCoordinate2D(latitude: 45.433370, longitude: 9.198566)
        ),
        Neighbourhood(
            name: "Villa San Giovanni",
            location: CLLocationCoordinate2D(latitude: 45.519845, longitude: 9.227033)
        ),
        Neighbourhood(
            name: "Villapizzone",
            location: CLLocationCoordinate2D(latitude: 45.500031, longitude: 9.149885)
        )
    ]
    
    // Function to append a new Favor to the List
    func addFavor(favor: Favor) {
        favors.append(favor)
    }
    
    // Appends some pre-determined Users and Favors inside the Lists, allowing them to be seen in the Map (testing purposes)
    func initialize() {
        // Users
        var mario = User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("red"))
        var giuseppe = User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("green"))
        var grazia = User(nameSurname: .constant("Grazia Deledda"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("orange"))
        let matilde = User(nameSurname: .constant("Matilde Di Leopardi"), neighbourhood: .constant("Bovisa"), profilePictureColor: .constant("pink"))
        let piera = User(nameSurname: .constant("Piera Capuana"), neighbourhood: .constant("Bovisa"), profilePictureColor: .constant("brown"))
        
        mario.rewards.append(.numberTen)
        mario.rewards.append(.numberTwenty)
        mario.rewards.append(.numberFifty)
        mario.rewards.append(.numberHundred)
        mario.rewards.append(.gardeningCategory)
        mario.rewards.append(.trashCategory)
        
        giuseppe.rewards.append(.numberTen)
        giuseppe.rewards.append(.numberTwenty)
        giuseppe.rewards.append(.numberFifty)
        giuseppe.rewards.append(.schoolCategory)
        giuseppe.rewards.append(.jobCategory)
        giuseppe.rewards.append(.housechoresCategory)
        
        grazia.rewards.append(.numberTen)
        grazia.rewards.append(.numberTwenty)
        grazia.rewards.append(.kidsCategory)
        grazia.rewards.append(.petsCategory)
        grazia.rewards.append(.gardeningCategory)
        grazia.rewards.append(.housechoresCategory)
        
        users.append(mario)
        users.append(giuseppe)
        users.append(grazia)
        users.append(matilde)
        users.append(piera)
        
        // Favors
        favors.append(
            Favor(
                title: "Test1",
                description: "This is a test",
                author: mario,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: MapDetails.startingLocation,
                isCarNecessary: false,
                isHeavyTask: true,
                status: .notAcceptedYet,
                category: .generic
            )
        )
        favors.last!.helpers.append(giuseppe)
        favors.last!.helpers.append(mario)
        
        favors.append(
            Favor(
                title: "Test2",
                description: "This is a test",
                author: giuseppe,
                neighbourhood: "Città Studi",
                type: .privateFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4777234, longitude: 9.2279519),
                isCarNecessary: true,
                isHeavyTask: false,
                status: .halfwayThere,
                category: .babySitting
            )
        )
        favors.last!.helpers.append(mario)
        
        favors.append(
            Favor(
                title: "Test3",
                description: "This is a test",
                author: mario,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4781024, longitude: 9.2268771),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .notAcceptedYet,
                category: .gardening
            )
        )
        
        favors.last!.helpers.append(giuseppe)
        
        favors.append(
            Favor(
                title: "Test4",
                description: "This is a test",
                author: mario,
                neighbourhood: "Città Studi",
                type: .privateFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4790747, longitude: 9.2284311),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .accepted,
                category: .houseChores
            )
        )
        
        favors.append(
            Favor(
                title: "Test5",
                description: "This is a test",
                author: mario,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4769980, longitude: 9.2291438),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .expired,
                category: .manualJob
            )
        )
        favors.last!.helpers.append(grazia)
        favors.last?.helpers.append(mario)
        favors.last?.helpers.append(giuseppe)
        favors.last!.review = 0.0
        
        favors.append(
            Favor(
                title: "Test6",
                description: "This is a test",
                author: giuseppe,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4792328, longitude: 9.2265965),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .justStarted,
                category: .sport
            )
        )
        
        favors.last!.helpers.append(giuseppe)
        favors.last!.helpers.append(mario)
        
        favors.append(
            Favor(
                title: "Test7",
                description: "This is a test",
                author: grazia,
                neighbourhood: "Città Studi",
                type: .privateFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4815986, longitude: 9.2293555),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .notAcceptedYet,
                category: .petSitting
            )
        )
        
        favors.append(
            Favor(
                title: "Test8",
                description: "This is a test",
                author: mario,
                neighbourhood: "Città Studi",
                type: .privateFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4800150, longitude: 9.2298333),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .completed,
                category: .school
            )
        )
        favors.last!.helpers.append(giuseppe)
        favors.last!.review = 5.0
        
        favors.append(
            Favor(
                title: "Test9",
                description: "This is a test",
                author: grazia,
                neighbourhood: "Città Studi",
                type: .privateFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4783722, longitude: 9.2305444),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .justStarted,
                category: .shopping
                
            )
        )
        
        favors.append(
            Favor(
                title: "Test10",
                description: "This is a test",
                author: giuseppe,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4764242, longitude: 9.2287484),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .completed,
                category: .transport
            )
        )
        favors.last!.helpers.append(grazia)
        favors.last!.review = 3.0
        
        favors.append(
            Favor(
                title: "Test11",
                description: "This is a test",
                author: giuseppe,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4778219, longitude: 9.2326831),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .expired,
                category: .trash
            )
        )
        
        favors.last!.helpers.append(giuseppe)
        favors.last!.helpers.append(mario)
        favors.last!.helpers.append(grazia)
        
        favors.append(
            Favor(
                title: "Test12",
                description: "This is a test",
                author: giuseppe,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4781624, longitude: 9.2259771),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .completed,
                category: .weather
            )
        )
        favors.last!.helpers.append(mario)
        favors.last!.review = 5.0
        
        favors.append(
            Favor(
                title: "Test13",
                description: "This is a test",
                author: piera,
                neighbourhood: "Bovisa",
                type: .privateFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.502856, longitude: 9.167285),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .notAcceptedYet,
                category: .weather
            )
        )
        
        favors.append(
            Favor(
                title: "Test14",
                description: "This is a test",
                author: piera,
                neighbourhood: "Bovisa",
                type: .privateFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.503835, longitude: 9.162520),
                isCarNecessary: true,
                isHeavyTask: true,
                status: .justStarted,
                category: .houseChores
            )
        )
        favors.last!.helpers.append(matilde)
        
        favors.append(
            Favor(
                title: "Test15",
                description: "This is a test",
                author: matilde,
                neighbourhood: "Bovisa",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.503154, longitude: 9.171065),
                isCarNecessary: false,
                isHeavyTask: true,
                status: .ongoing,
                category: .gardening
            )
        )
        favors.last!.helpers.append(piera)
        
        // Accepts a few Favors (for testing)
        let user = users.first!
        var count = 0
        for favor in favors {
            if count < 5 && favor.canBeAccepted(userID: user.id) {
                favor.helpers.append(user)
                if (count == 0) {
                    favor.status = .completed
                    favor.review = 4.0
                } else if (count == 1) { favor.status = .waitingForApprovation
                } else if (count == 2) { favor.status = .halfwayThere
                } else if (count == 3) {
                    favor.status = .completed
                    favor.review = 3.0
                } else {
                    favor.status = .completed
                    favor.review = 4.0
                }
                count += 1
            } else if count >= 5 {
                break
            }
        }
        
        favors.append(
            Favor(
                title: "Test16",
                description: "This is a test",
                author: user,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.480775, longitude: 9.224775),
                isCarNecessary: false,
                isHeavyTask: true,
                status: .completed,
                category: .gardening
            )
        )
        favors.last!.helpers.append(piera)
        
        favors.append(
            Favor(
                title: "Test17",
                description: "This is a test",
                author: user,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.484795, longitude: 9.224675),
                isCarNecessary: false,
                isHeavyTask: true,
                status: .completed,
                category: .transport
            )
        )
        
        favors.append(
            Favor(
                title: "Test18",
                description: "This is a test",
                author: user,
                neighbourhood: "Città Studi",
                type: .publicFavor,
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.482725, longitude: 9.234755),
                isCarNecessary: false,
                isHeavyTask: true,
                status: .completed,
                category: .houseChores
            )
        )
        favors.last!.helpers.append(piera)
        favors.last!.helpers.append(giuseppe)
        favors.last!.helpers.append(mario)
        favors.last!.helpers.append(grazia)
    }
}
