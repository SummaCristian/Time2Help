import SwiftUI

struct FavorListRow: View {
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(favor.title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                
                Text(favor.status.textualForm)
                    .font(.caption)
                    .foregroundStyle(.white)
                
                // Author
                ProfileIconView(username: favor.author.$nameSurname, color: favor.author.$profilePictureColor, size: .small)
                    .scaleEffect(0.8)
            }
            
            // Completed Mark
            VStack {
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
             
                Spacer()
            }
            
            
            Spacer()
            
            VStack {
                Spacer()
                // Helper(s)
                if !favor.helpers.isEmpty {
                    MultiProfileIconView(config: .constant(.box), users: $favor.helpers)
                }
            }
            
            ZStack {
                // Progress Indicator
                CircularProgressView(value: favor.status.progressPercentage, showNumber: false, progressColor: favor.color)
                
                // Icon
                Image(systemName: favor.icon)
                    .foregroundStyle(.primary.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 65)
        .padding(.horizontal, 24)
        .padding(.vertical)
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
                FavorListRow(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .privateFavor, location: MapDetails.startingLocation, isCarNecessary: true, isHeavyTask: true, status: .completed, category: category))
            }
        }
    }
}
