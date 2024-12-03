import Foundation
import SwiftUI

struct User: Identifiable {
    // An ID to identify it
    let id: UUID = UUID()
    
    // Username
    @Binding var nameSurname: String
    
    // Neighbourhood
    @Binding var neighbourhood: String
    
    // Profile picture color
    @Binding var profilePictureColor: String
    
    var rewards: [Reward] = []
}
