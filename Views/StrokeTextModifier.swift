import SwiftUI

struct StrokeTextModifier: ViewModifier {
    
    private let id: UUID = UUID()
    var strokeColor: Color = .blue
    var strokeSize: CGFloat = 1
    
    func body(content: Content) -> some View {
        content
            .lineLimit(2)
            .padding(strokeSize*2)
            .background {
                Rectangle()
                    .foregroundStyle(strokeColor)
                    .mask {
                        outline(context: content)
                    }
            }
    }
    
    func outline(context: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            context
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}

extension View {
    func customBorder(color: Color, borderWidth: CGFloat) -> some View {
        modifier(StrokeTextModifier(strokeColor: color, strokeSize: borderWidth))
    }
}
