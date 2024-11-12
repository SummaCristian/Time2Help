import Foundation
import MapKit

let neighbourhoods: [String] = ["Bande Nere", "Bisceglie", "Cadorna", "Cairoli", "Conciliazione", "Cordusio", "De Angeli", "Gambara", "Gorla", "Duomo", "Inganni", "Lima", "Loreto", "Pagano", "Palestro", "Pasteur", "Porta Venezia", "Precotto", "Primaticcio", "Rovereto", "San Babila", "Sesto Marelli", "Turro", "Villa San Giovanni", "Wagner"]

// This class handles the saving of the Favors, acting as a Database

class Database: ObservableObject {
    
    static let shared = Database()
    
    // The List of Favors, accessible by others
    @Published var favors: [Favor] = []
    
    // The User's Name
    @Published var userName: String = "Nome Cognome"
    
    // Function to append a new Favor to the List
    func addFavor(favor: Favor) {
        favors.append(favor)
    }
    
    // Appends some pre-determined Favors inside the List, allowing them to be seen in the Map (testing purposes)
    func initialize() {
        favors.append(
            Favor(
                title: "Test",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: MapDetails.startingLocation, 
                isCarNecessary: false, 
                isHeavyTask: true, 
                reward: 5, 
                status: .notAcceptedYet, 
                /*icon: .people, 
                 color: .orange*/
                category: .generic
            )
        )
        
        favors.append(
            Favor(
                title: "Test2",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4777234,longitude: 9.2279519), 
                isCarNecessary: true, 
                isHeavyTask: false, 
                reward: 3, 
                status: .halfwayThere, 
                /*icon: .hammer, 
                 color: .cyan*/
                category: .babySitting
            )
        )
        
        favors.append(
            Favor(
                title: "Test3",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4781024,longitude: 9.2268771), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 8, 
                status: .completed, 
                /*icon: .football, 
                 color: .green*/
                category: .gardening
            )
        )
        
        favors.append(
            Favor(
                title: "Test4",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4790747,longitude: 9.2284311), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 10, 
                status: .accepted, 
                /*icon: .cart, 
                 color: .red*/
                category: .houseChores
            )
        )
        
        favors.append(
            Favor(
                title: "Test5",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4769980, longitude: 9.2291438), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 1, 
                status: .expired, 
                /*icon: .dog, 
                 color: .yellow*/
                category: .manualJob
            )
        )
        
        favors.append(
            Favor(
                title: "Test6",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4792328, longitude: 9.2265965), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 2, 
                status: .justStarted, 
                /*icon: .trash, 
                 color: .mint*/
                category: .sport
            )
        )
        
        favors.append(
            Favor(
                title: "Test7",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4815986, longitude: 9.2293555), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 12, 
                status: .notAcceptedYet, 
                /*icon: .book, 
                 color: .blue*/
                category: .petSitting
            )
        )
        
        favors.append(
            Favor(
                title: "Test8",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4800150, longitude: 9.2298333), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 25, 
                status: .completed, 
                /*icon: .translate, 
                 color: .indigo*/
                category: .school
            )
        )
        
        favors.append(
            Favor(
                title: "Test9",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4783722, longitude: 9.2305444), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 6, 
                status: .justStarted, 
                /*icon: .tag, 
                 color: .purple*/
                category: .shopping
            
            )
        )
        
        favors.append(
            Favor(
                title: "Test10",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4764242, longitude: 9.2287484), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 9, 
                status: .completed, 
                /*icon: .umbrella, 
                 color: .pink*/
                category: .transport
            )
        )
        
        favors.append(
            Favor(
                title: "Test11",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4778219, longitude: 9.2326831), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 4, 
                status: .completed, 
                /*icon: .stopwatch, 
                 color: .brown*/
                category: .trash
            )
        )
        
        favors.append(
            Favor(
                title: "Test12",
                description: "This is a test",
                author: "Name Surname",
                neighbourhood: "Piola",
                startingDate: .now,
                endingDate: .now,
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4781624,longitude: 9.2259771), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 11, 
                status: .completed, 
                /*icon: .videocamera, 
                 color: .teal*/
                category: .weather
            )
        )
    }
}
