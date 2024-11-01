import Foundation
import MapKit

// This class handles the saving of the Favors, acting as a Database

class Database: ObservableObject {
    // The List of Favors, accessible by others
    @Published var favors: [Favor] = []
    
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
                status: .notAcceptedYet, 
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
                status: .notAcceptedYet, 
                icon: .football, 
                color: .green)
        )
    }
}
