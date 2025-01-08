import Foundation
import MapKit
import SwiftUI

struct TimeSlot: Identifiable {
    let id: UUID = UUID()
    
    var startingDate: Date
    var endingDate: Date
}

struct FavorReview: Identifiable {
    let id: UUID = UUID()
    
    var author: User
    var rating: Double
    var text: String
    var isAuthor: Bool = false
}

class Favor: Identifiable, ObservableObject, Hashable {
    // An ID to identify it
    let id: UUID
    
    // Primary details
    @Published var title: String
    @Published var description: String
    @Published var author: User
    @Published var neighbourhood: String
    @Published var type: FavorType
    
    // Secondary details
    @Published var timeSlots: [TimeSlot] = [TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600))]
    @Published var location: CLLocationCoordinate2D
    @Published var isCarNecessary: Bool
    @Published var isHeavyTask: Bool
    @Published var status: FavorStatus
    
    @Published var helpers: [User] = []
    
    @Published var reviews: [FavorReview] = []
    
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
        self.type = .individual
        self.location = CLLocationCoordinate2D()
        self.isCarNecessary = false
        self.isHeavyTask = false
        self.status = .notAcceptedYet
        self.category = .generic
        self.color = FavorCategory.generic.color
        self.icon = FavorCategory.generic.icon
    }
    
    // Favor for test
    init (
        title: String,
        description: String,
        author: User,
        neighbourhood: String,
        type: FavorType,
        location: CLLocationCoordinate2D,
        isCarNecessary: Bool,
        isHeavyTask: Bool,
        status: FavorStatus,
        category: FavorCategory
    ) {
        // Custom initializer
        self.id = UUID()
        self.title = title
        self.description = description
        self.author = author
        self.neighbourhood = neighbourhood
        self.type = type
        self.location = location
        self.isCarNecessary = isCarNecessary
        self.isHeavyTask = isHeavyTask
        self.status = status
        self.category = category
        
        self.color = category.color
        self.icon = category.icon
    }
    
    // Favor for Edit Sheet
    init (
        id: UUID,
        title: String,
        description: String,
        author: User,
        neighbourhood: String,
        type: FavorType,
        location: CLLocationCoordinate2D,
        isCarNecessary: Bool,
        isHeavyTask: Bool,
        status: FavorStatus,
        category: FavorCategory
    ) {
        // Custom initializer
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.neighbourhood = neighbourhood
        self.type = type
        self.location = location
        self.isCarNecessary = isCarNecessary
        self.isHeavyTask = isHeavyTask
        self.status = status
        self.category = category
        
        self.color = category.color
        self.icon = category.icon
    }
    
    func canBeAccepted(userID: UUID) -> Bool {
        return (userID != author.id && ((type == .individual && helpers.isEmpty) || (type == .group && !helpers.contains(where: { $0.id == userID }))))
    }
    
    func hasBeenAccepted(userID: UUID) -> Bool {
        return helpers.contains(where: { $0.id == userID })
    }
    
    // MARK: - Hashable Conformance
    
    static func ==(lhs: Favor, rhs: Favor) -> Bool {
        return lhs.id == rhs.id  // Assuming `id` is the unique identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)  // Use `id` for hashing
    }
}
