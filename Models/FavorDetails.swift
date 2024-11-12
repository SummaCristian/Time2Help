import Foundation
import SwiftUI

enum FavorColor: Identifiable, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    
    var id: Self {self}
    
    var color: Color{
        switch self {
        case .red:
            return Color(.systemRed)
        case .orange:
            return Color(.systemOrange)
        case .yellow:
            return Color(.systemYellow)
        case .green:
            return Color(.systemGreen)
        case .mint:
            return Color(.systemMint)
        case .teal:
            return Color(.systemTeal)
        case .cyan:
            return Color(.systemCyan)
        case .blue:
            return Color(.systemBlue)
        case .indigo:
            return Color(.systemIndigo)
        case .purple:
            return Color(.systemPurple)
        case .pink:
            return Color(.systemPink)
        case .brown: 
            return Color(.systemBrown)
        }
    }
}

enum FavorStatus {
    case notAcceptedYet
    case accepted
    case justStarted
    case ongoing
    case halfwayThere
    case almostThere
    case waitingForApprovation
    case completed
    case expired
    
    // Equivalent percentages
    var progressPercentage: Double {
        switch self {
        case .notAcceptedYet:
            return 0.05
        case .accepted:
            return 0.15
        case .justStarted:
            return 0.20
        case .ongoing:
            return 0.35
        case .halfwayThere:
            return 0.50
        case .almostThere:
            return 0.75
        case .waitingForApprovation:
            return 0.90
        case .completed:
            return 1.0
        case .expired:
            return 0.0 // Or any value representing expired status
        }
    }
    
    // Equivalent textual representation
    var textualForm: String {
        switch self {
        case .notAcceptedYet:
            return "Non ancora accettato..."
        case .accepted:
            return "Accettato"
        case .justStarted:
            return "Appena iniziato..."
        case .ongoing:
            return "In corso..."
        case .halfwayThere:
            return "Circa a metà..."
        case .almostThere:
            return "Ci siamo quasi..."
        case .waitingForApprovation:
            return "In attesa di approvazione..."
        case .completed:
            return "Completato!"
        case .expired:
            return "Scaduto"
        }
    }
}

enum FavorCategory: Identifiable, CaseIterable {
    // All is needed for the filtering system
    case all
    
    // The real categories
    case generic
    case gardening
    case transport
    case petSitting
    case manualJob
    case shopping
    case school
    case babySitting
    case houseChores
    case trash
    case sport
    case weather
    
    var id: Self {self}
    
    var name: String {
        switch self {
        case .generic:
            return "Generico"
        case .gardening:
            return "Giardinaggio"
        case .transport:
            return "Trasporto"
        case .petSitting:
            return "Animali"
        case .manualJob:
            return "Lavoro"
        case .shopping:
            return "Shopping"
        case .school:
            return "Scuola"
        case .babySitting:
            return "Bambini"
        case .houseChores:
            return "Faccende"
        case .trash:
            return "Spazzatura"
        case .sport:
            return "Sport"
        case .weather:
            return "Meteo"
        case .all:
            return "Tutte"
        }
    }
    
    var color: Color {
        switch self {
        case .generic:
            return FavorColor.orange.color
        case .gardening:
            return FavorColor.green.color
        case .transport:
            return FavorColor.red.color
        case .petSitting:
            return FavorColor.yellow.color
        case .manualJob:
            return FavorColor.blue.color
        case .shopping:
            return FavorColor.purple.color
        case .school:
            return FavorColor.indigo.color
        case .babySitting:
            return FavorColor.pink.color
        case .houseChores:
            return FavorColor.teal.color
        case .trash:
            return FavorColor.brown.color
        case .sport:
            return FavorColor.mint.color
        case .weather:
            return FavorColor.cyan.color
        case .all:
            return FavorColor.yellow.color
        }
    }
    
    var icon: String {
        switch self {
        case .generic:
            return "person.2.fill"
        case .gardening:
            return "camera.macro"
        case .transport:
            return "car.fill"
        case .petSitting:
            return "dog.fill"
        case .manualJob:
            return "hammer.fill"
        case .shopping:
            return "cart.fill"
        case .school:
            return "book.fill"
        case .babySitting:
            return "stroller.fill"
        case .houseChores:
            return "house.fill"
        case .trash:
            return "trash.fill"
        case .sport:
            return "soccerball"
        case .weather:
            return "umbrella.fill"
        case .all:
            return "star.fill"
        }
    }
}
