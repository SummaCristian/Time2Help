import SwiftUI

struct CreditNumberView: View {
    @ObservedObject var favor: Favor
    
    @State var size: Int?
    
    var body: some View {
        ZStack {
            // Soft outer glow behind the text
            Text(String(favor.reward))
                .font(.system(size: CGFloat(size ?? 6), weight: .black, design: .rounded))
                .foregroundColor(Color.yellow.opacity(0.6))
                .blur(radius: 13)
                .offset(y: 2)
            
            // Inner shadow effect with slight offset
            Text(String(favor.reward))
                .font(.system(size: CGFloat(size ?? 60), weight: .black, design: .rounded))
                .foregroundColor(Color.brown.opacity(0.60))
                .offset(x: 2, y: 2)
            
            // Main text with golden gradient and layered shadows
            Text(String(favor.reward))
                .font(.system(size: CGFloat(size ?? 60), weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color(hex: 0xDBB400),
                                Color(hex: 0xEFAF00),
                                Color(hex: 0xF5D100),
                                Color(hex: 0xF5D100),
                                Color(hex: 0xD1AE15),
                                Color(hex: 0xDBB400)
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
        }
    }
}
