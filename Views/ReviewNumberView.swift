import SwiftUI

struct ReviewNumberView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let value: Double
    
    var body: some View {
        ZStack {
            // Soft outer glow behind the text
            Text("\(value, specifier: "%.1f")")
                .font(.title2)
                .fontWeight(.black)
                .fontDesign(.rounded)
                .foregroundColor(Color.yellow.opacity(0.6))
                .blur(radius: 13)
                .offset(y: 2)
            
            // Inner shadow effect with slight offset
            Text("\(value, specifier: "%.1f")")
                .font(.title2)
                .fontWeight(.black)
                .fontDesign(.rounded)
                .foregroundColor(Color(.systemGray2))
                .opacity(0.60)
                .offset(x: 3, y: 3)
            
            // Main text with gradient
            Text("\(value, specifier: "%.1f")")
                .font(.title2)
                .fontWeight(.black)
                .fontDesign(.rounded)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 253/255, green: 245/255, blue: 210/255),
                            .yellow,
                            .orange
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .customBorder(color: colorScheme == .dark ? Color(red: 212/255, green: 143/255, blue: 53/255) : .orange, borderWidth: 0.75)
        }
    }
}

//struct CreditNumberView: View {
//    @ObservedObject var favor: Favor
//    
//    @State var font: Font?
//    
//    var body: some View {
//        ZStack {
//            // Soft outer glow behind the text
//            Text("\(favor.grade, specifier: "%.1f")")
//                .font(font ?? .body)
//                .fontWeight(.black)
//                .fontDesign(.rounded)
////                .font(.system(size: CGFloat(size ?? 6), weight: .black, design: .rounded))
//                .foregroundColor(Color.yellow.opacity(0.6))
//                .blur(radius: 13)
//                .offset(y: 2)
//            
//            // Inner shadow effect with slight offset
//            Text("\(favor.grade, specifier: "%.1f")")
//                .font(font ?? .body)
//                .fontWeight(.black)
//                .fontDesign(.rounded)
////                .font(.system(size: CGFloat(size ?? 60), weight: .black, design: .rounded))
//                .foregroundColor(Color.brown.opacity(0.60))
//                .offset(x: 2, y: 2)
//            
//            // Main text with golden gradient and layered shadows
//            Text("\(favor.grade, specifier: "%.1f")")
//                .font(font ?? .body)
//                .fontWeight(.black)
//                .fontDesign(.rounded)
////                .font(.system(size: CGFloat(size ?? 60), weight: .black, design: .rounded))
//                .foregroundStyle(
//                    LinearGradient(
//                        gradient: Gradient(
//                            colors: [
//                                Color(hex: 0xDBB400),
//                                Color(hex: 0xEFAF00),
//                                Color(hex: 0xF5D100),
//                                Color(hex: 0xF5D100),
//                                Color(hex: 0xD1AE15),
//                                Color(hex: 0xDBB400)
//                            ]
//                        ),
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                )
//                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
//        }
//    }
//}
