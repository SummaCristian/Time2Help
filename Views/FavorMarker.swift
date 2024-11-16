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
            }
        }
        .scaleEffect(scale)
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
                Label("Accetta", systemImage: "mark")
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
    }
}
