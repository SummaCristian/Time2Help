import Foundation
import SwiftUI

enum FavorIcon {
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
    
    var image: Image {
        switch self {
        case .people:
            return Image(systemName: "person.2.fill")
        case .plane:
            return Image(systemName: "airplane")
        case .shippingBox:
            return Image(systemName: "shippingbox.fill")
        case .book:
            return Image(systemName: "book.fill")
        case .handbag:
            return Image(systemName: "handbag.fill")
        case .bubble:
            return Image(systemName: "bubble.fill")
        case .camera:
            return Image(systemName: "camera.fill")
        case .gift:
            return Image(systemName: "gift.fill")
        case .car:
            return Image(systemName: "car.fill")
        case .cart:
            return Image(systemName: "cart.fill")
        case .envelope:
            return Image(systemName: "envelope.fill")
        case .eye:
            return Image(systemName: "eye.fill")
        case .film:
            return Image(systemName: "film")
        case .flag:
            return Image(systemName: "flag.fill")
        case .hammer:
            return Image(systemName: "hammer.fill")
        case .heart:
            return Image(systemName: "heart.fill")
        case .hourglass:
            return Image(systemName: "hourglass")
        case .house:
            return Image(systemName: "house.fill")
        case .trash:
            return Image(systemName: "trash.fill")
        case .lightbulb:
            return Image(systemName: "lightbulb.min.fill")
        case .location:
            return Image(systemName: "location.fill")
        case .lock:
            return Image(systemName: "lock.fill")
        case .map:
            return Image(systemName: "map.fill")
        case .tree:
            return Image(systemName: "tree.fill")
        case .moon:
            return Image(systemName: "moon.fill")
        case .microphone:
            return Image(systemName: "music.microphone")
        case .musicNote:
            return Image(systemName: "music.note")
        case .paintbrush:
            return Image(systemName: "paintbrush.fill")
        case .printer:
            return Image(systemName: "printer.fill")
        case .thermometer:
            return Image(systemName: "thermometer.variable")
        case .snowflake:
            return Image(systemName: "snowflake")
        case .dog:
            return Image(systemName: "dog.fill")
        case .star:
            return Image(systemName: "star.fill")
        case .tag:
            return Image(systemName: "tag.fill")
        case .flower:
            return Image(systemName: "camera.macro")
        case .umbrella:
            return Image(systemName: "umbrella.fill")
        case .videocamera:
            return Image(systemName: "video.fill")
        case .wrench:
            return Image(systemName: "wrench.adjustable.fill")
        case .sun:
            return Image(systemName: "sun.max.fill")
        case .stopwatch:
            return Image(systemName: "stopwatch.fill")
        case .football:
            return Image(systemName: "soccerball")
        case .stroller:
            return Image(systemName: "stroller.fill")
        case .bandage:
            return Image(systemName: "bandage.fill")
        case .battery:
            return Image(systemName: "battery.75percent")
        case .document:
            return Image(systemName: "document.fill")
        case .flashlight:
            return Image(systemName: "flashlight.on.fill")
        case .translate:
            return Image(systemName: "translate")
        case .globe:
            return Image(systemName: "globe")
        }
    }
}

enum FavorColor {
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
}
