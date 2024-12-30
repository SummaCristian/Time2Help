import SwiftUI

struct StarsView: View {
    
    @Binding var value: Double
    let isInDetailsSheet: Bool
    @Binding var clickOnGoing: Bool
    @State var reviews: [FavorReview] = []
    @State var isExpanded = false
    
    @State private var clicked: [Bool] = [false, false, false, false, false]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Spacer()
                
                ReviewNumberView(value: value)
                    .frame(width: 60)
                    .scaleEffect(1.2)
                
                HStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { index in
                        if isInDetailsSheet {
                            ClickableStar(value: $value, index: index, clickOnGoing: $clickOnGoing, clicked: $clicked)
                        } else {
                            StaticStar(value: value, index: index)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.bottom, reviews.isEmpty ? 0 : 30)
            
            if !reviews.isEmpty {
                // Open/Close control
                HStack {
                    Text(String(reviews.count) + " recensioni")
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? -180 : 0))
                    
                }
                .font(.title3.bold())
                .foregroundStyle(.blue)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                
                if isExpanded {
                    // Reviews
                    List {
                        ForEach(reviews) { review in
                            VStack(alignment: .leading) {
                                HStack {
                                    ProfileIconView(username: review.author.$nameSurname, color: review.author.$profilePictureColor, size: .small)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(review.author.nameSurname)
                                            .font(.headline)
                                        
                                        if review.isAuthor {
                                            Text("Autore")
                                                .font(.caption.bold())
                                                .foregroundStyle(.red)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Small StarsView (if there sre more than 1 review
                                    // If its only 1, the big one displays the same value, so the small one is omitted
                                    if reviews.count > 1 {
                                        HStack(spacing: 0) {
                                            ReviewNumberView(value: review.rating)
                                                .frame(width: 40)
                                                .scaleEffect(0.8)
                                            
                                            HStack(spacing: 0) {
                                                ForEach(0..<5, id: \.self) { index in
                                                    ClickableStar(value: .constant(review.rating), index: index, clickOnGoing: $clickOnGoing, clicked: $clicked)
                                                        .scaleEffect(0.6)
                                                        .frame(width: 20)
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // Review Text
                                Text(review.text)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    .transition(.blurReplace)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 20)
        .onAppear {
            if isInDetailsSheet {
                let index = Int(value - 1)
                if index != -1 {
                    for i in 0...index {
                        clicked[i] = true
                    }
                }
            }
        }
        .sensoryFeedback(.impact, trigger: isExpanded)
    }
}

struct ClickableStar: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var value: Double
    let index: Int
    @Binding var clickOnGoing: Bool
    @Binding var clicked: [Bool]
    
    var body: some View {
        ZStack {
            Image(systemName: "star.fill")
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray), Color(.systemGray3), Color(.systemGray4)] : [Color(.systemGray6), Color(.systemGray4), Color(.systemGray3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .customBorder(color: colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray3), borderWidth: 0.75)
                .shadow(color: Color(.systemGray3).opacity(colorScheme == .dark ? 1 : 0.5), radius: 6)
                .keyframeAnimator(
                    initialValue: AnimationValues(),
                    trigger: clicked[index]
                ) { content, value in
                    content
                        .scaleEffect(y: value.verticalStretch)
                } keyframes: { _ in
                    KeyframeTrack(\.verticalStretch) {
                        CubicKeyframe(1.0, duration: clicked[index] ? 0.1 : 0.01)
                        CubicKeyframe(0.6, duration: clicked[index] ? 0.15 : 0.0)
                        CubicKeyframe(1.5, duration: clicked[index] ? 0.1 : 0.0)
                        CubicKeyframe(1.05, duration: clicked[index] ? 0.15 : 0.0)
                        CubicKeyframe(1.0, duration: clicked[index] ? 0.88 : 0.0)
                    }
                }
            
            Image(systemName: "star.fill")
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(LinearGradient(colors: [Color(red: 253/255, green: 245/255, blue: 210/255), .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .customBorder(color: colorScheme == .dark ? Color(red: 212/255, green: 143/255, blue: 53/255) : .orange, borderWidth: 0.75)
                .keyframeAnimator(
                    initialValue: AnimationValues(),
                    trigger: clicked[index]
                ) { content, value in
                    content
                        .rotationEffect(value.angle)
                        .scaleEffect(value.scale)
                        .scaleEffect(y: value.verticalStretch)
                        .offset(y: value.verticalTranslation)
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        LinearKeyframe(1.0, duration: clicked[index] ? 0.34 : 0.0)
                        SpringKeyframe(1.5, duration: clicked[index] ? 0.78 : 0.0, spring: .bouncy)
                        SpringKeyframe(1.0, spring: .bouncy)
                    }
                    
                    KeyframeTrack(\.verticalTranslation) {
                        LinearKeyframe(0.0, duration: clicked[index] ? 0.08 : 0.0)
                        SpringKeyframe(20.0, duration: clicked[index] ? 0.08 : 0.00, spring: .bouncy)
                        SpringKeyframe(-20.0, duration: clicked[index] ? 0.9 : 0.0, spring: .bouncy)
                        SpringKeyframe(0.0, spring: .bouncy)
                    }
                    
                    KeyframeTrack(\.verticalStretch) {
                        CubicKeyframe(1.0, duration: clicked[index] ? 0.08 : 0.0)
                        CubicKeyframe(0.6, duration: clicked[index] ? 0.12 : 0.0)
                        CubicKeyframe(1.5, duration: clicked[index] ? 0.08 : 0.0)
                        CubicKeyframe(1.05, duration: clicked[index] ? 0.12 : 0.0)
                        CubicKeyframe(1.0, duration: clicked[index] ? 0.86 : 0.0)
                    }
                    
                    KeyframeTrack(\.angle) {
                        CubicKeyframe(.degrees(0.0), duration: clicked[index] ? 0.20 : 0.0)
                        CubicKeyframe(.degrees(-15.0), duration: clicked[index] ? 0.1 : 0.0)
                        CubicKeyframe(.degrees(15.0), duration: clicked[index] ? 0.1 : 0.0)
                        CubicKeyframe(.degrees(-15.0), duration: clicked[index] ? 0.1 : 0.0)
                        CubicKeyframe(.degrees(15.0), duration: clicked[index] ? 0.1 : 0.0)
                        CubicKeyframe(.degrees(0.0), duration: clicked[index] ? 0.20 : 0.0)
                    }
                }
                .opacity(clicked[index] ? 1 : 0)
        }
        .onTapGesture {
            if !clickOnGoing {
                clickOnGoing = true
                if index != 0 || index == 0 && value != 1.0 {
                    if clicked[0] {
                        //                        for i in 0...index {
                        clicked = [false, false, false, false, false]
                        //                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            for i in 0...index {
                                clicked[i] = true
                            }
                            value = Double(index + 1)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.27) {
                                clickOnGoing = false
                            }
                        }
                    } else {
                        for i in 0...index {
                            clicked[i] = true
                        }
                        value = Double(index + 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.27) {
                            clickOnGoing = false
                        }
                    }
                    //                    clicked[index] = true
                    //                    value = Double(index)
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.27) {
                    //                        clickOnGoing = false
                    //                    }
                } else {
                    value = 0.0
                    clicked[0] = false
                    clickOnGoing = false
                }
            }
        }
    }
}

struct AnimationValues {
    var scale = 1.0
    var verticalStretch = 1.0
    var verticalTranslation = 0.0
    var horizontalTranslation = 0.0
    var angle = Angle.zero
    var opacity = 1.0
}

struct StaticStar: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let value: Double
    let index: Int
    
    var body: some View {
        ZStack {
            Image(systemName: "star.fill")
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray), Color(.systemGray3), Color(.systemGray4)] : [Color(.systemGray6), Color(.systemGray4), Color(.systemGray3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .customBorder(color: colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray3), borderWidth: 0.75)
                .shadow(color: Color(.systemGray3).opacity(colorScheme == .dark ? 1 : 0.5), radius: 6)
            Image(systemName: "star.fill")
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(LinearGradient(colors: [Color(red: 253/255, green: 245/255, blue: 210/255), .yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .customBorder(color: colorScheme == .dark ? Color(red: 212/255, green: 143/255, blue: 53/255) : .orange, borderWidth: 0.75) // Color(red: 212/255, green: 143/255, blue: 53/255)
                .mask(
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(.white)
                        Rectangle()
                            .fill(Double(index + 1) < value || (Double(index) == floor(value) && value - floor(value) > 0.75) || value == Double(index + 1) ? .white : .clear)
                    }
                )
                .opacity(Double(index + 1) < value || (Double(index) == floor(value) && value - floor(value) > 0.25) || value == Double(index + 1) ? 1 : 0)
        }
    }
}

#Preview {
    StarsView(value: .constant(4.5), isInDetailsSheet: true, clickOnGoing: .constant(true), reviews: [
        FavorReview(author: User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("red")), rating: 3.5, text: "This is a review", isAuthor: true),
        FavorReview(author: User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("green")), rating: 5, text: "This is a review"),
        FavorReview(author: User(nameSurname: .constant("Luigi Russo"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), rating: 0.5, text: "This is a review")
    ])
}
