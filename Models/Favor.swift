import Foundation
import MapKit

struct Favor: Identifiable {
    // An ID to identify it
    let id: UUID
    
    // Primary details
    let title: String
    let description: String
    let author: String
    
    // Secondary details
    let startingDate: Date
    let endingDate: Date
    let location: CLLocationCoordinate2D
    let isCarNecessary: Bool
    let isHeavyTask: Bool
    let reward: Int
    let status: FavorStatus
    
    // Cosmetic details
    let icon: FavorIcon
    let color: FavorColor
    
    
    // Initializers
    init() {
        // Standard initializer
        self.id = UUID()
        self.title = ""
        self.description = ""
        self.author = ""
        self.startingDate = Date()
        self.endingDate = Date().addingTimeInterval(3600)
        self.location = CLLocationCoordinate2D.init()
        self.isCarNecessary = false
        self.isHeavyTask = false
        self.reward = 0
        self.status = FavorStatus.notAcceptedYet
        self.icon = .people
        self.color = .red
    }
    
    init(title: String, description: String, author: String, startingDate: Date,
         endingDate: Date, location: CLLocationCoordinate2D, isCarNecessary: Bool,
         isHeavyTask: Bool, reward: Int, status: FavorStatus, icon: FavorIcon, color: FavorColor) {
        // Custom initialer
        self.id = UUID()
        self.title = title
        self.description = description
        self.author = author
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.location = location
        self.isCarNecessary = isCarNecessary
        self.isHeavyTask = isHeavyTask
        self.reward = reward
        self.status = status
        self.icon = icon
        self.color = color
    }
}
