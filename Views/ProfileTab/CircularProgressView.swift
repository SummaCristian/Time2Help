import SwiftUI

struct CircularProgressView: View {
    @State var value: Double
    
    @State var showNumber: Bool = true
    
    @State var size: CircularProgressSize? = .medium
    
    @State var numberColor: Color?
    @State var progressColor: Color?
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Material.ultraThin,
                    lineWidth: size!.lineWidth
                )
                .frame(width: size?.value, height: size?.value)
            Circle()
                .trim(from: 0, to: value)
                .stroke(
                    progressColor?.gradient ?? Color.green.gradient,
                    style: StrokeStyle(
                        lineWidth: size!.lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .frame(width: size?.value, height: size?.value)
            
            if showNumber {
                Text(String(Int(value * 100)))
                    .font(.system(size: size!.textValue, weight: .bold, design: .rounded))
                    .foregroundStyle(numberColor ?? .primary)
            }
        }
        .shadow(radius: 2)
    }
}

enum CircularProgressSize {
    case small
    case medium
    case large
    case extraLarge
    
    var value: CGFloat {
        switch self {
            case .small:
                return 30
            case .medium:
                return 45
            case .large:
                return 60
            case .extraLarge:
                return 80
        }
    }
    
    var textValue: CGFloat {
        switch self {
        case .small:
            return 10
        case .medium:
            return 15
        case .large:
            return 25
        case .extraLarge:
            return 35
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .small:
            return 2
        case .medium:
            return 5
        case .large:
            return 6
        case .extraLarge:
            return 7
        }
    }
}
