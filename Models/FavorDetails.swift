import Foundation
import SwiftUI

enum FavorIcon: Identifiable, CaseIterable {
    case people
    case plane
    case shippingBox
    case book
    case handbag
    case bubble
    case camera
    case gift
    case car
    case cart
    case envelope
    case eye
    case film
    case flag
    case hammer
    case heart
    case hourglass
    case house
    case trash
    case lightbulb
    case location
    case lock
    case map
    case tree
    case moon
    case microphone
    case musicNote
    case paintbrush
    case printer
    case thermometer
    case snowflake
    case dog
    case star
    case tag
    case flower
    case umbrella
    case videocamera
    case wrench
    case sun
    case stopwatch
    case football
    case stroller
    case bandage
    case battery
    case document
    case flashlight
    case translate
    case globe
    
    var id: Self{self}
    
    var icon: String {
        switch self {
        case .people:
            return "person.2.fill"
        case .plane:
            return "airplane"
        case .shippingBox:
            return "shippingbox.fill"
        case .book:
            return "book.fill"
        case .handbag:
            return "handbag.fill"
        case .bubble:
            return "bubble.fill"
        case .camera:
            return "camera.fill"
        case .gift:
            return "gift.fill"
        case .car:
            return "car.fill"
        case .cart:
            return "cart.fill"
        case .envelope:
            return "envelope.fill"
        case .eye:
            return "eye.fill"
        case .film:
            return "film"
        case .flag:
            return "flag.fill"
        case .hammer:
            return "hammer.fill"
        case .heart:
            return "heart.fill"
        case .hourglass:
            return "hourglass"
        case .house:
            return "house.fill"
        case .trash:
            return "trash.fill"
        case .lightbulb:
            return "lightbulb.min.fill"
        case .location:
            return "location.fill"
        case .lock:
            return "lock.fill"
        case .map:
            return "map.fill"
        case .tree:
            return "tree.fill"
        case .moon:
            return "moon.fill"
        case .microphone:
            return "music.microphone"
        case .musicNote:
            return "music.note"
        case .paintbrush:
            return "paintbrush.fill"
        case .printer:
            return "printer.fill"
        case .thermometer:
            return "thermometer.variable"
        case .snowflake:
            return "snowflake"
        case .dog:
            return "dog.fill"
        case .star:
            return "star.fill"
        case .tag:
            return "tag.fill"
        case .flower:
            return "camera.macro"
        case .umbrella:
            return "umbrella.fill"
        case .videocamera:
            return "video.fill"
        case .wrench:
            return "wrench.adjustable.fill"
        case .sun:
            return "sun.max.fill"
        case .stopwatch:
            return "stopwatch.fill"
        case .football:
            return "soccerball"
        case .stroller:
            return "stroller.fill"
        case .bandage:
            return "bandage.fill"
        case .battery:
            return "battery.75percent"
        case .document:
            return "document.fill"
        case .flashlight:
            return "flashlight.on.fill"
        case .translate:
            return "translate"
        case .globe:
            return "globe"
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
