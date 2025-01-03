import SwiftUI

struct MapListSelector: View {
    @Binding var isListSelected: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: isListSelected ? 70 : 80, height: 35)
                .foregroundStyle(.thinMaterial)
                .overlay {
                    Color.blue
                        .clipShape(Capsule())
                }
                .shadow(radius: 3)
                .offset(x: isListSelected ? 40 : -35)
                .animation(.bouncy(duration: 0.5, extraBounce: 0.1), value: isListSelected)
            
            HStack(spacing: 20) {
                HStack(spacing: 6) {
                    Image(systemName: "map.fill")
                        .font(.subheadline)
                        .foregroundStyle(!isListSelected ? .white : .primary)
                    
                    Text("Mappa")
                        .font(.caption.bold())
                        .foregroundStyle(!isListSelected ? .white : .primary)
                }
                .onTapGesture {
                    withAnimation {
                        isListSelected = false
                    }
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.grid.1x2.fill")
                        .font(.subheadline)
                        .foregroundStyle(isListSelected ? .white : .primary)
                    
                    Text("Lista")
                        .font(.caption.bold())
                        .foregroundStyle(isListSelected ? .white : .primary)
                }
                .onTapGesture {
                    withAnimation {
                        isListSelected = true
                    }
                }
            }
            .padding()
        }
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(radius: 10)
        }
        .sensoryFeedback(.levelChange, trigger: isListSelected)
    }
}

#Preview {
    VStack(spacing: 40) {
        MapListSelector(isListSelected: .constant(false))
        
        MapListSelector(isListSelected: .constant(true))
    }
}
