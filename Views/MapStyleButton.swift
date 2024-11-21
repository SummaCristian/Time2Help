import SwiftUI

struct MapStyleButton: View {
    @Binding var isSatelliteSelected: Bool
    
    var body: some View {
        Image(systemName: isSatelliteSelected ? "map.fill" : "globe.europe.africa.fill")
        .font(.title3)
        .frame(width: 42, height: 42)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
         )
        .hoverEffect(.automatic)
    }
}
