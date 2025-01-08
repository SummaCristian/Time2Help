import SwiftUI

struct OngoingFavorBoxView: View {
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    var body: some View {
        VStack(spacing: 0) {
            // Title and Icon
            HStack(alignment: .top, spacing: 8) {
                // Title
                VStack(alignment: .leading) {
                    Text(favor.title)
                        .bold()
                        .foregroundStyle(.white)
                    
                    Text(favor.status.textualForm)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
                
                // Icon
                Image(systemName: favor.icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 25, height: 25)
                    .shadow(radius: 3)
            }
            
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
        .frame(maxWidth: 160, maxHeight: 60)
        .padding(.vertical, 28)
        .padding(.horizontal, 16)
        .background {
            Rectangle()
                .foregroundStyle(.regularMaterial)
                .background {
                    ZStack {
                        Rectangle()
                            .fill(.primary.opacity(0.1))
                    }
                }
                .overlay {
                    LinearGradient(colors: [favor.color.opacity(0.9), favor.color.opacity(0.6), favor.color.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.8)
                        .blur(radius: 2)
                }
        }
        .shadow(radius: 5)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .hoverEffect(.lift)
    }
        
}

#Preview {
    ScrollView() {
        VStack {
            ForEach(FavorCategory.allCases.filter({$0 != .all})) { category in
                OngoingFavorBoxView(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .individual, location: MapDetails.startingLocation, isCarNecessary: true, isHeavyTask: true, status: .completed, category: category))
            }
        }
    }
}
