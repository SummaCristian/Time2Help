import SwiftUI

struct SplashScreenView: View {
    @State private var showHeart = false
    @State private var moveHeart = false
    @State private var showStar = false
    @State private var moveStar = false
    
    var body: some View {
        ZStack {
            ZStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.background)
                    .symbolRenderingMode(.hierarchical)
                    .font(.title.bold())
            }
            .background {
                ZStack {
                    Circle()
                        .frame(width: 110, height: 110)
                        .foregroundStyle(.background)
                        .shadow(radius: 6)
                    
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.green.gradient)
                }
            }
            .offset(
                x: moveStar ? 30 : 0,
                y: moveStar ? 30 : 0
            )
            .scaleEffect(showStar ? 1 : 0.4)
            
            ZStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.background)
            }
            .background {
                ZStack {
                    Circle()
                        .frame(width: 110, height: 110)
                        .foregroundStyle(.background)
                        .shadow(radius: 6)
                    
                    Circle()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.red.gradient)
                }
            }
            .offset(
                x: moveHeart ? -30 : 0,
                y: moveHeart ? -30 : 0
            )
            .scaleEffect(showHeart ? 1 : 0.4)
        }
        .onAppear {
            var transaction = Transaction(animation: .interactiveSpring)
            transaction.disablesAnimations = false
            
            withTransaction(transaction) {
                showHeart = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withTransaction(transaction) {
                    moveHeart = true
                    showStar = true
                    moveStar = true
                }
            }
        }
        .sensoryFeedback(.impact, trigger: showHeart)
        .sensoryFeedback(.success, trigger: showStar)
    }
}

#Preview {
    SplashScreenView()
}
