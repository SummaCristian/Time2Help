import SwiftUI

struct FavorBoxView: View {
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    @State private var isBeingTapped = false
    
    var body: some View {
        VStack(spacing: 10) {
            // Top Portion
            HStack {
                // Progress Indicator + Icon
                ZStack {
                    // Progress Indicator
                    CircularProgressView(value: favor.status.progressPercentage, showNumber: false, progressColor: favor.color)
                    
                    // Icon
                    Image(systemName: favor.icon)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                // Completed Mark
                if favor.status == .completed {
                    VStack {
                        ZStack {
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(Material.thin)
                                .opacity(0.3)
                            
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }
                }
            }
            
            // Title and Status (text)
            HStack {
                VStack(alignment: .leading) {
                    Text(favor.title)
                        .bold()
                        .foregroundStyle(.white)
                    
                    Text(favor.status.textualForm)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            
            Spacer()
            
            // Reward
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .frame(width: 40)
                        .foregroundStyle(Material.ultraThick)
                        .opacity(0.3)
                    
                    CreditNumberView(favor: favor, size: (favor.reward < 10) ? 30 : 25)
                }
            }
        }
        .frame(width: 124, height: 164)
        .padding(16)
        .background(
            GeometryReader { geometry in
                RadialGradient(colors: [.clear, .black], center: .center, startRadius: 0, endRadius: max(geometry.size.width, geometry.size.height) * 0.9)
                    .opacity(0.2)
            }
        )
        .background(favor.color.gradient)
        .cornerRadius(18)
        .shadow(radius: 5)
        .hoverEffect(.lift)
        .padding(.vertical, 4)
    }
}
