import Foundation
import SwiftUI

enum FavorType: Identifiable, CaseIterable {
    case privateFavor
    case publicFavor
    
    var id : Self {self}
    
    var string: String {
        switch self {
        case .privateFavor:
            return "Singolo"
        case .publicFavor:
            return "Gruppo"
        }
    }
    
    var icon: String {
        switch self {
        case .privateFavor:
            return "person.fill"
        case .publicFavor:
            return "person.3.fill"
        }
    }
    
    var description: String {
        switch self {
        case .privateFavor:
            return "Soltanto un utente portà accettarlo, ideale per Favori personali"
        case .publicFavor:
            return "Più utenti potranno accettarlo, ideale per Favori a beneficio della comunità"
        }
    }
}

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
        case .all:
            return "Tutte"
        }
    }
    
    var description: String {
        switch self {
        case .generic:
            return "Una categoria adatta un po' a tutti i Favori, senza specificarne il tipo"
        case .gardening:
            return "Favori legati alla natura e al giardinaggio, come prendersi cura di un parco o di un giardino"
        case .transport:
            return "Favori legati a mezzi di trasporto, come chiedere un passaggio, o fare car-sharing"
        case .petSitting:
            return "Favori legati agli animali domestici, come fare dog-sitting o simili"
        case .manualJob:
            return "Svolgere dei lavori che possono richiedere delle skill un po' più specifiche, come riparare un lavandino o aggiustare qualcosa"
        case .shopping:
            return "Favori legati allo shopping, come aiutare a portare la spesa, oppure anche fare compagnia durante lo shopping"
        case .school:
            return "Favori legati all'istruzione, come aiutare nello studio, oppure svolgere attività di dopo-scuola"
        case .babySitting:
            return "Favori relativi ai bambini, come fare baby-sitting o simili"
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
            return FavorColor.teal.color
        case .manualJob:
            return FavorColor.blue.color
        case .shopping:
            return FavorColor.purple.color
        case .school:
            return FavorColor.indigo.color
        case .babySitting:
            return FavorColor.pink.color
        case .all:
            return Color.white
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
        case .all:
            return "star.fill"
        }
    }
}
