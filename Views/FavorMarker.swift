import SwiftUI

// This file contains the UI for the single Favor Map Marker, used to show the location
// of a Favor on the Map.

struct FavorMarker: View {
    @Environment(\.colorScheme) var colorScheme
    
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    @Binding var isSelected: Bool
    
    var isInFavorSheet: Bool
    
    @State private var moveTitle = false
    
    @State private var scale: Double = 0
    
    // The UI
    var body: some View {
        ZStack(alignment: moveTitle ? .center : .leading) {
            ZStack(alignment: .center) {
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundStyle(favor.color.gradient)
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .rotationEffect(.degrees(180))
                    .offset(y: isSelected ? -15 : 7)
                
                // Inner Circle
                Circle()
                    .foregroundStyle(favor.color.gradient)
                    .frame(
                        width: isSelected ? 50 : 30,
                        height: isSelected ? 50 : 30)
                    .padding(.all, 2.5)
                    .background {
                        Circle() // RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                    }
                    .padding(.all, isSelected ? -1 : 1.5)
                    .background {
                        Circle() // RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(favor.color.gradient)
                    }
                    .offset(y: isSelected ? -45 : 0)
                
                // Icon inside the Circle
                Image(systemName: favor.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isSelected ? 30 : 15,
                        height: isSelected ? 30 : 15)
                    .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .offset(y: isSelected ? -45 : 0)
                
                if !isInFavorSheet {
                    Text(favor.title)
                        .font(moveTitle ? .subheadline.bold() : .footnote.bold())
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(moveTitle ? .center : .leading)
                        .lineLimit(2)
                        .frame(width: 120, height: 120, alignment: moveTitle ? .top : .leading)
                        .offset(x: moveTitle ? 0 : 86, y: moveTitle ? 75 : 0)
                }
                
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundStyle(favor.color.gradient)
                    .opacity(moveTitle ? 1 : 0)
                
                if (!isInFavorSheet && favor.helper != nil) {
                    ProfileIconView(username: favor.helper?.$nameSurname ?? .constant("Null"), color: favor.helper?.$profilePictureColor ?? .constant("blue"), size: .small)
                        .scaleEffect(moveTitle ? 1 : 0.8)
                        .offset(x: moveTitle ? 16 : 12, y: moveTitle ? -20 : 16)
                }
            }
        }
        .scaleEffect(scale)
        .shadow(color: isSelected ? favor.color.opacity(0.1) : .clear, radius: 15)
        .onAppear() {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        scale = 1
                    }
                }
            }
        }
        .contextMenu(menuItems: {
            if !isInFavorSheet {
                // Only allows long pressing when used in a Map, and not inside sheets
                if favor.helper == nil {
                    Button("Accetta", systemImage: "checkmark") {
                        // TODO
                    }
                } else {
                    Label("Non disponibile...", systemImage: "xmark")
                }
            }
        }, preview: {
            FavorBoxView(favor: favor, roundedCorners: false)
                .background(Color.clear)
        })
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        moveTitle = true
                    }
                }
            } else {
                withAnimation {
                    moveTitle = false
                }
            }
        }
        .animation(.spring(duration: 0.4), value: isSelected)
        .hoverEffect(.lift)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

#Preview {
    ScrollView() {
        
        // Selected Variant
        LazyVGrid(columns: [.init(.adaptive(minimum: 100), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                
                FavorMarker(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", startingDate: Date.now, endingDate: Date.now, isAllDay: false, location: MapDetails.startingLocation, isCarNecessary: false, isHeavyTask: false, status: .halfwayThere, category: category), isSelected: .constant(true), isInFavorSheet: true)
                    .padding(.bottom, 50)
            }
        }
        .padding(.top, 50)
        
        // Unselected Variant
        LazyVGrid(columns: [.init(.adaptive(minimum: 100), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                
                FavorMarker(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", startingDate: Date.now, endingDate: Date.now, isAllDay: false, location: MapDetails.startingLocation, isCarNecessary: false, isHeavyTask: false, status: .halfwayThere, category: category), isSelected: .constant(false), isInFavorSheet: true)
                    .padding(.bottom, 50)

            }
        }
    }
}
