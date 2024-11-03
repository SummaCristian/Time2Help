import SwiftUI

struct CircularProgressView: View {
    @State var value: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Material.ultraThin,
                    lineWidth: 5
                )
                .frame(width: 45, height: 45)
            Circle()
                .trim(from: 0, to: value)
                .stroke(
                    Color.green,
                    // 1
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 45, height: 45)
        }
        .shadow(radius: 1)
    }
}
