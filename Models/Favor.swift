import Foundation
import MapKit

class Favor: Identifiable, ObservableObject{
    // An ID to identify it
    let id: UUID
    
    // Primary details
    @Published var title: String
    @Published var description: String
    @Published var author: String
    
    // Secondary details
    @Published var startingDate: Date
    @Published var endingDate: Date
    @Published var isAllDay: Bool
    @Published var location: CLLocationCoordinate2D
    @Published var isCarNecessary: Bool
    @Published var isHeavyTask: Bool
    @Published var reward: Int
    @Published var status: FavorStatus
    
    // Cosmetic details
    @Published var icon: FavorIcon
    @Published var color: FavorColor
    
    
    // Initializers
    init() {
        // Standard initializer
        self.id = UUID()
        self.title = ""
        self.description = ""
        self.author = "Unknown"
        self.startingDate = Date()
        self.endingDate = Date().addingTimeInterval(3600)
        self.isAllDay = false
        self.location = CLLocationCoordinate2D.init()
        self.isCarNecessary = false
        self.isHeavyTask = false
        self.reward = 0
        self.status = FavorStatus.notAcceptedYet
        self.icon = .people
        self.color = .red
    }
    
    init(title: String, description: String, author: String, startingDate: Date,
         endingDate: Date, isAllDay: Bool, location: CLLocationCoordinate2D, isCarNecessary: Bool,
         isHeavyTask: Bool, reward: Int, status: FavorStatus, icon: FavorIcon, color: FavorColor) {
        // Custom initialer
        self.id = UUID()
        self.title = title
        self.description = description
        self.author = author
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.isAllDay = isAllDay
        self.location = location
        self.isCarNecessary = isCarNecessary
        self.isHeavyTask = isHeavyTask
        self.reward = reward
        self.status = status
        self.icon = icon
        self.color = color
    }
}
