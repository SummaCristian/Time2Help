import Foundation
import MapKit

class Database: ObservableObject {
    @Published var favors: [Favor] = []
    
 func initialize() {
     favors.append(
        Favor(
            title: "Test", 
            description: "This is a test", 
            author: "Name Surname", 
            startingDate: .now, 
            endingDate: .now, 
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
            location: CLLocationCoordinate2D(latitude: 45.4781024,longitude: 9.2268771), 
            isCarNecessary: true, 
            isHeavyTask: false, 
            reward: 8, 
            status: .notAcceptedYet, 
            icon: .football, 
            color: .green)
     )
    }
}
