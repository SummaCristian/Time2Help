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
        
    // The UI
    var body: some View {
        ZStack(alignment: moveTitle ? .center : .leading) {
            ZStack(alignment: .center) {
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundStyle(favor.color.color.gradient)
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .rotationEffect(.degrees(180))
                    .offset(y: isSelected ? -15 : 7)
                    
                // Inner Circle
                Circle() // RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(favor.color.color.gradient)
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
                            .foregroundStyle(favor.color.color.gradient)
                    }
                    .offset(y: isSelected ? -45 : 0)
                
                // Icon inside the Circle
                Image(systemName: favor.icon.icon)
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
            }
        }
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    moveTitle = true
                }
            } else {
                moveTitle = false
            }
        }
        .animation(.spring(duration: 0.4), value: isSelected)
    }
}
