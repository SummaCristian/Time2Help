import SwiftUI

struct ProfileIconView: View {
    @Binding var username: String
    @Binding var color: String
    
    @State var size: ProfileIconSize
    
    var body: some View {
        ZStack {
            // Background
            Circle()
                .frame(width: size.borderSize, height: size.borderSize)
                .foregroundStyle(.background)
                .overlay {
                    Circle()
                        .stroke(.gray, lineWidth: size.lineWidth)
                }
            
            Circle()
                .frame(width: size.iconSize, height: size.iconSize)
                .foregroundStyle(color.toColor()!.gradient)
            
            // Icon
            Text(username.filter({ $0.isUppercase }))
                .font(.custom("Futura-bold", size: username.filter({ $0.isUppercase }).count == 1 ? size.textSizeBig : username.filter({ $0.isUppercase }).count == 2 ? size.textSizeMedium : size.textSizeSmall))
                .foregroundStyle(.white)
        }
    }
}

enum ProfileIconSize {
    case small
    case medium
    case large
    case extraLarge
    
    var borderSize: CGFloat {
        switch self {
            case .small:
                return 30
            case .medium: 
                return 60
            case .large: 
                return 90
            case .extraLarge:
                return 110
        }
    }
    
    var iconSize: CGFloat {
        switch self {
            case .small:
                return 20
            case .medium: 
                return 50
            case .large: 
                return 80
            case .extraLarge:
                return 100
        }
    }
    
    var textSizeBig: CGFloat {
        switch self {
            case .small:
                return 10
            case .medium: 
                return 25
            case .large: 
                return 45
            case .extraLarge:
                return 50
        }
    }
    
    var textSizeMedium: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium: 
            return 22
        case .large: 
            return 38
        case .extraLarge:
            return 45
        }
    }
    
    var textSizeSmall: CGFloat {
        switch self {
        case .small:
            return 6
        case .medium: 
            return 15
        case .large: 
            return 30
        case .extraLarge:
            return 35
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .small:
            return 0.7
        case .medium: 
            return 0.5
        case .large: 
            return 0.5
        case .extraLarge:
            return 0.5
        }
    }
}
