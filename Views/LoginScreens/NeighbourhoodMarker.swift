import SwiftUI

struct NeighbourhoodMarker: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isSelected: Bool
    let neighbourhood: Neighbourhood
    
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    
    // The UI
    var body: some View {
        VStack(spacing: 12) {
            Text("Q")
                .font(.custom("Futura-bold", size: 25))
            //                .foregroundStyle(isSelected ? .white : .orange)
                .foregroundStyle(LinearGradient(colors: isSelected ? (colorScheme == .dark ? [Color(.systemGray3), Color(.systemGray5)] : [Color(.white), Color(.systemGray5)]) : [.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 50, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(LinearGradient(colors: isSelected ? [.orange] : (colorScheme == .dark ? [Color(.systemGray4), Color(.systemGray5)] : [Color(.systemGray6), Color(.systemGray5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .primary.opacity(0.2), radius: 6)
                        .padding(.all, isSelected ? -4 : 0)
                        .overlay {
                            RoundedRectangle(cornerRadius: isSelected ? 8 : 12)
                                .stroke(LinearGradient(colors: colorScheme == .dark ? [Color(.systemGray3), Color(.systemGray5)] : [Color(.white), Color(.systemGray5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: isSelected ? 3 : 2)
                        }
                )
            
            if neighbourhood.big || isSelected {
                Text(neighbourhood.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(isSatelliteMode ? .white : .primary)
                    .shadow(radius: 6)
            }
        }
        .scaleEffect(neighbourhood.big || isSelected ? 1 : 0.4)
        .animation(.spring(duration: 0.2), value: isSelected)
        .animation(.spring(duration: 0.2), value: neighbourhood.big)
    }
}
