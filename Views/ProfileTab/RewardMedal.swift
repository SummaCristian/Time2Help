import SwiftUI

enum RewardVariant {
    case numberOfFavors
    case categoryOfFavors
}

enum RewardNumberVariant: Identifiable, CaseIterable {
    case ten
    case twenty
    case fifty
    case hundred
    case hundredFifty
    case twoHundredFifty
    
    var id : Self {self}
    
    var color: Color {
        switch self {
        case .ten:
            return .brown
        case .twenty:
            return .gray
        case .fifty:
            return .yellow
        case .hundred:
            return .teal
        case .hundredFifty:
            return .red
        case .twoHundredFifty:
            return .green
        }
    }
    
    var number: String {
        switch self {
        case .ten:
            return "10"
        case .twenty:
            return "20"
        case .fifty:
            return "50"
        case .hundred:
            return "100"
        case .hundredFifty:
            return "150"
        case .twoHundredFifty:
            return "250"
        }
    }
}

struct RewardMedal: View {
    @State var variant: RewardVariant
    @State var numberVariant: RewardNumberVariant? = nil
    @State var categoryVariant: FavorCategory? = nil
    
    var body: some View {
        ZStack {
            
            // Background Shape
            let rhomboids: [RewardNumberVariant] = [.ten, .twenty, .fifty]
            if variant == .numberOfFavors && numberVariant != nil {
                if rhomboids.contains(numberVariant!) {
                    Rhombus()
                        .frame(width: 90, height: 90)
                        .foregroundStyle(numberVariant?.color.gradient ?? Color(.gray).gradient)
                        .shadow(radius: 3)
                } else {
                    Hexagon()
                        .frame(width: 90, height: 90)
                        .foregroundStyle(numberVariant?.color.gradient ?? Color(.gray).gradient)
                        .shadow(radius: 3)
                }
            } else {
                Octagon()
                    .frame(width: 90, height: 90)
                    .foregroundStyle(categoryVariant?.color.gradient ?? Color(.gray).gradient)
                    .shadow(radius: 3)
            }
            
            // Background Shape 2
            if variant == .numberOfFavors && numberVariant != nil {
                if rhomboids.contains(numberVariant!) {
                    Rhombus()
                        .frame(width: 82, height: 82)
                        .foregroundStyle(numberVariant?.color.gradient ?? Color(.gray).gradient)
                        .shadow(radius: 3)
                } else {
                    Hexagon()
                        .frame(width: 82, height: 82)
                        .foregroundStyle(numberVariant?.color.gradient ?? Color(.gray).gradient)
                        .shadow(radius: 3)
                }
            } else {
                Octagon()
                    .frame(width: 82, height: 82)
                    .foregroundStyle(categoryVariant?.color.gradient ?? Color(.gray).gradient)
                    .shadow(radius: 3)
            }
            
            // Foreground content
            if variant == .numberOfFavors && numberVariant != nil {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors:
                                [
                                    .indigo,
                                    .purple,
                                    .red,
                                    .orange,
                                    .yellow,
                                    .green,
                                    .blue
                                ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                       )
                    )
                    .shadow(radius: 3)
                
                Text(numberVariant?.number ?? "0")
                    .font(.system(size: 8, weight: .black, design: .rounded))
                    .offset(y: 2)
                    .shadow(radius: 3)
                    .foregroundStyle(.white)
                
                
            } else {
                Image(systemName: categoryVariant?.icon ?? "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 3)
            }
        }
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
            // Number Variants
            ForEach(RewardNumberVariant.allCases) { number in
                RewardMedal(variant: .numberOfFavors, numberVariant: number)
            }
            
            // Category Variants
            ForEach(FavorCategory.allCases.filter({$0 != .all})) { category in
                RewardMedal(variant: .categoryOfFavors, categoryVariant: category)    
            }
            
            // Large Number Variants
            ForEach(RewardNumberVariant.allCases) { number in
                RewardMedal(variant: .numberOfFavors, numberVariant: number)
                    .scaleEffect(2.2)
                    .padding(.vertical, 60)
            }
            
            // Large Category Variants
            ForEach(FavorCategory.allCases.filter({$0 != .all})) { category in
                RewardMedal(variant: .categoryOfFavors, categoryVariant: category)
                    .scaleEffect(2.2)
                    .padding(.vertical, 60)
            }
        }
    }
}
