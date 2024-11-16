import Foundation
import MapKit
import SwiftUI

class Favor: Identifiable, ObservableObject {
    // An ID to identify it
    let id: UUID
    
    // Primary details
    @Published var title: String
    @Published var description: String
    @Published var author: User
    @Published var neighbourhood: String
    
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
    @Published var icon: String
    @Published var color: Color
    
    // Category
    @Published var category: FavorCategory {
        didSet {
            color = category.color
            icon = category.icon
        }
    }
    
    // Initializers
    init(author: User) {
        self.author = author
        
        // Standard initializer
        self.id = UUID()
        self.title = ""
        self.description = ""
        self.neighbourhood = ""
        self.startingDate = Date()
        self.endingDate = Date().addingTimeInterval(3600)
        self.isAllDay = false
        self.location = CLLocationCoordinate2D()
        self.isCarNecessary = false
        self.isHeavyTask = false
        self.reward = 0
        self.status = .notAcceptedYet
        self.category = .generic
        
        self.color = FavorCategory.generic.color
        self.icon = FavorCategory.generic.icon
    }
    
    init (
        title: String, 
        description: String, 
        author: User, 
        neighbourhood: String, 
        startingDate: Date, 
        endingDate: Date, 
        isAllDay: Bool, 
        location: CLLocationCoordinate2D, 
        isCarNecessary: Bool, 
        isHeavyTask: Bool, 
        reward: Int, 
        status: FavorStatus,
        category: FavorCategory
    ) {
        // Custom initializer
        self.id = UUID()
        self.title = title
        self.description = description
        self.author = author
        self.neighbourhood = neighbourhood
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.isAllDay = isAllDay
        self.location = location
        self.isCarNecessary = isCarNecessary
        self.isHeavyTask = isHeavyTask
        self.reward = reward
        self.status = status
        self.category = category
        
        self.color = category.color
        self.icon = category.icon
        }  
    }
