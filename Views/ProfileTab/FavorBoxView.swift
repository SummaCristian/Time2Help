import SwiftUI

struct FavorBoxView: View {
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    @State private var isBeingTapped = false
    
    @State var roundedCorners: Bool = true
    
    var body: some View {
        VStack(spacing: 10) {
            // Top Portion
            HStack (alignment: .top) {
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
                    ZStack {
                        Circle()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Material.thin)
                            .opacity(0.3)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.white)
                    }
                }
            }
            
            // Title and Status (text)
            VStack(alignment: .leading) {
                Text(favor.title)
                    .bold()
                    .foregroundStyle(.white)
                
                Text(favor.status.textualForm)
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, 6)
            
            // Author and Helper(s)
            HStack(alignment: .bottom) {
                // Author
                ProfileIconView(username: favor.author.$nameSurname, color: favor.author.$profilePictureColor, size: .small)
                    .scaleEffect(0.8)
                
                Spacer()
                
                // Helper(s)
                if !favor.helpers.isEmpty {
                    MultiProfileIconView(config: .constant(.box), users: $favor.helpers)
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
        .shadow(color: .gray.opacity(0.4), radius: 6)
//        .shadow(radius: 5)
        .clipShape(roundedCorners ? AnyShape(RoundedRectangle(cornerRadius: 25)) : AnyShape(.rect))
        .hoverEffect(.lift)
    }
        
}

#Preview {
    ScrollView() {
        LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
            ForEach(FavorCategory.allCases.filter({$0 != .all})) { category in
                FavorBoxView(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .individual, location: MapDetails.startingLocation, isCarNecessary: true, isHeavyTask: true, status: .completed, category: category))
            }
        }
    }
}
