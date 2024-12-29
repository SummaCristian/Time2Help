import Foundation
import SwiftUI

enum Reward: Identifiable {
    case numberTen
    case numberTwenty
    case numberFifty
    case numberHundred
    case numberHundredFifty
    case numberTwoHundredFifty
    
    case genericCategory
    case gardeningCategory
    case transportationCategory
    case petsCategory
    case jobCategory
    case shoppingCategory
    case schoolCategory
    case kidsCategory
    
    var id : Self {self}
    
    var rewardView: RewardMedal {
        switch self {
        case .numberTen:
            return RewardMedal(variant: .numberOfFavors, numberVariant: .ten)
        case .numberTwenty:
            return RewardMedal(variant: .numberOfFavors, numberVariant: .twenty)
        case .numberFifty:
            return RewardMedal(variant: .numberOfFavors, numberVariant: .fifty)
        case .numberHundred:
            return RewardMedal(variant: .numberOfFavors, numberVariant: .hundred)
        case .numberHundredFifty:
            return RewardMedal(variant: .numberOfFavors, numberVariant: .hundredFifty)
        case .numberTwoHundredFifty:
            return RewardMedal(variant: .numberOfFavors, numberVariant: .twoHundredFifty)
            
        case .genericCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .generic)
        case .gardeningCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .gardening)
        case .transportationCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .transport)
        case .petsCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .petSitting)
        case .jobCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .manualJob)
        case .shoppingCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .shopping)
        case .schoolCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .school)
        case .kidsCategory:
            return RewardMedal(variant: .categoryOfFavors, categoryVariant: .babySitting)
        }
    }
    
    var color: Color {
        switch self {
        case .numberTen:
            return .brown
        case .numberTwenty:
            return .gray
        case .numberFifty:
            return .yellow
        case .numberHundred:
            return .teal
        case .numberHundredFifty:
            return .red
        case .numberTwoHundredFifty:
            return .green
            
        case .genericCategory:
            return .orange
        case .gardeningCategory:
            return .green
        case .transportationCategory:
            return .red
        case .petsCategory:
            return .yellow
        case .jobCategory:
            return .blue
        case .shoppingCategory:
            return .purple
        case .schoolCategory:
            return .indigo
        case .kidsCategory:
            return .pink
        }
    }
    
    var title: String {
        switch self {
        case .numberTen:
            return "10 Favori completati!"
        case .numberTwenty:
            return "20 Favori completati!"
        case .numberFifty:
            return "50 Favori completati!"
        case .numberHundred:
            return "100 Favori completati!"
        case .numberHundredFifty:
            return "150 Favori completati!"
        case .numberTwoHundredFifty:
            return "250 Favori completati!"
            
        case .genericCategory:
            return "Eroe Generico"
        case .gardeningCategory:
            return "Eroe del Giardinaggio"
        case .transportationCategory:
            return "Eroe dei Trasporti"
        case .petsCategory:
            return "Eroe degli Animali"
        case .jobCategory:
            return "Eroe dei Lavori"
        case .shoppingCategory:
            return "Eroe dello Shopping"
        case .schoolCategory:
            return "Eroe della Scuola"
        case .kidsCategory:
            return "Eroe dei Bambini"
        }
    }
    
    var description: String {
        switch self {
        case .numberTen:
            return "Hai completato con successo 10 Favori!\nContinua così!"
        case .numberTwenty:
            return "Hai completato con successo 20 Favori!\nContinua così!"
        case .numberFifty:
            return "Hai completato con successo 50 Favori!\nContinua così!"
        case .numberHundred:
            return "Hai completato con successo 100 Favori!\nContinua così!"
        case .numberHundredFifty:
            return "Hai completato con successo 150 Favori!\nContinua così!"
        case .numberTwoHundredFifty:
            return "Hai completato con successo 250 Favori!\nContinua così!"
            
        case .genericCategory:
            return "Hai completato con successo 30 Favori di tipo Generico!"
        case .gardeningCategory:
            return "Hai completato con successo 30 Favori di tipo Giardinaggio!"
        case .transportationCategory:
            return "Hai completato con successo 30 Favori di tipo Trasporto!"
        case .petsCategory:
            return "Hai completato con successo 30 Favori di tipo Animali!"
        case .jobCategory:
            return "Hai completato con successo 30 Favori di tipo Lavoro!"
        case .shoppingCategory:
            return "Hai completato con successo 30 Favori di tipo Shopping!"
        case .schoolCategory:
            return "Hai completato con successo 30 Favori di tipo Scuola!"
        case .kidsCategory:
            return "Hai completato con successo 30 Favori di tipo Bambini!"
        }
    }
}
