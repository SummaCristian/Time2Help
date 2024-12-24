import SwiftUI

enum FavorInteraction {
    case created
    case accepted
    case edited
    case deleted
}

struct FavorFeedbackOverlay: View {
    
    @State var favor: Favor
    
    var type: FavorInteraction
    
    @State private var isExpanded = false
    @State private var isShown = false
    @State private var showCheckmark = false
    @State private var blur = false
    
    var body: some View {
        VStack(spacing: 50) {
            
            var title: String {
                switch type {
                case .created: "Favore richiesto!"
                case .accepted: "Favore accettato!"
                case .edited: "Favore modificato!"
                case .deleted: "Favore eliminato!"
                }
            }
            
            var finalIcon: String {
                switch type {
                case .created, .accepted: "checkmark"
                case .edited: "pencil"
                case .deleted: "trash"
                }
            }
            
            Text(title)
                .font(.title)
                .fontWeight(.black)
                .fontDesign(.rounded)
            
            Image(systemName: showCheckmark ? finalIcon : favor.icon)
                .font(.system(size: 36, weight: .black))
                .foregroundStyle(showCheckmark ? .primary : favor.color)
                .scaleEffect(2)
                .blur(radius: blur ? 3 : 0)
                .contentTransition(.symbolEffect(.replace))
            
            Text(favor.title)
                .font(.title2.bold())
        }
        .padding(36)
        .blur(radius: isShown ? 0 : 3)
        .background {
            RoundedRectangle(cornerRadius: 32)
                .foregroundStyle(.ultraThinMaterial)
        }
        .scaleEffect(isExpanded ? 1 : 0)
        .ignoresSafeArea()
        .shadow(radius: 10)
        .onAppear {
            withAnimation {
                isExpanded = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    isShown = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    blur = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    showCheckmark = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                withAnimation {
                    blur = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation {
                    isShown = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isExpanded = false
                }
            }
        }
    }
}

#Preview {
    FavorFeedbackOverlay(favor: Favor(title: "Test", description: "", author: User(nameSurname: .constant("Nome"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .privateFavor, location: MapDetails.startingLocation, isCarNecessary: true, isHeavyTask: true, status: .accepted, category: .generic), type: .created)
}
