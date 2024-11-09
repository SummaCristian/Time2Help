import Foundation
import MapKit

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
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: MapDetails.startingLocation, 
                isCarNecessary: false, 
                isHeavyTask: true, 
                reward: 5, 
                status: .notAcceptedYet, 
                icon: .people, 
                color: .orange)
        )
        
        favors.append(
            Favor(
                title: "Test2", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4777234,longitude: 9.2279519), 
                isCarNecessary: true, 
                isHeavyTask: false, 
                reward: 3, 
                status: .halfwayThere, 
                icon: .hammer, 
                color: .cyan)
        )
        
        favors.append(
            Favor(
                title: "Test3", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4781024,longitude: 9.2268771), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 8, 
                status: .completed, 
                icon: .football, 
                color: .green)
        )
        
        favors.append(
            Favor(
                title: "Test4", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4790747,longitude: 9.2284311), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 10, 
                status: .accepted, 
                icon: .cart, 
                color: .red)
        )
        
        favors.append(
            Favor(
                title: "Test5", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4769980, longitude: 9.2291438), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 1, 
                status: .expired, 
                icon: .dog, 
                color: .yellow)
        )
        
        favors.append(
            Favor(
                title: "Test6", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4792328, longitude: 9.2265965), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 2, 
                status: .justStarted, 
                icon: .trash, 
                color: .mint)
        )
        
        favors.append(
            Favor(
                title: "Test7", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4815986, longitude: 9.2293555), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 12, 
                status: .notAcceptedYet, 
                icon: .book, 
                color: .blue)
        )
        
        favors.append(
            Favor(
                title: "Test8", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4800150, longitude: 9.2298333), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 25, 
                status: .completed, 
                icon: .translate, 
                color: .indigo)
        )
        
        favors.append(
            Favor(
                title: "Test9", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4783722, longitude: 9.2305444), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 6, 
                status: .justStarted, 
                icon: .tag, 
                color: .purple)
        )
        
        favors.append(
            Favor(
                title: "Test10", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4764242, longitude: 9.2287484), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 9, 
                status: .completed, 
                icon: .umbrella, 
                color: .pink
            )
        )
        
        favors.append(
            Favor(
                title: "Test11", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4778219, longitude: 9.2326831), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 4, 
                status: .completed, 
                icon: .stopwatch, 
                color: .brown)
        )
        
        favors.append(
            Favor(
                title: "Test3", 
                description: "This is a test", 
                author: "Name Surname", 
                startingDate: .now, 
                endingDate: .now, 
                isAllDay: false,
                location: CLLocationCoordinate2D(latitude: 45.4781624,longitude: 9.2259771), 
                isCarNecessary: true, 
                isHeavyTask: true, 
                reward: 11, 
                status: .completed, 
                icon: .videocamera, 
                color: .teal)
        )
    }
}
