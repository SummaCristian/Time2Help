import SwiftUI

// This file contains the UI for the single Favor Map Marker, used to show the location
// of a Favor on the Map.

struct FavorMarker: View {
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    @Binding var isSelected: Bool
    
    @State private var showBase = false
        
    // The UI
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Outer Circle with Stroke Border
                Circle()
                    .frame(
                        width: isSelected ? 55 : 30, 
                        height: isSelected ? 55 : 30)
                    .foregroundStyle(Color.white)
                    .animation(.spring, value: isSelected)
                
                // Inner Circle
                Circle()
                    .foregroundStyle(favor.color.color.gradient)
                    .frame(
                        width: isSelected ? 50 : 25, 
                        height: isSelected ? 50 : 25)
                    .animation(.spring, value: isSelected)
                
                // Icon inside the Circle
                Image(systemName: favor.icon.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isSelected ? 30 : 15, 
                        height: isSelected ? 30 : 15)
                    .foregroundStyle(Color.white)
                    .animation(.spring, value: isSelected)
            }
            .frame(width: 55, height: 55, alignment: .center)
            
            // Triangle Pin
            if showBase {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color.white)                                
                    .rotationEffect(.degrees(180))
                    .offset(y: -3)
                    //.padding(.bottom, 80)
                    .transition(.opacity.combined(with: .scale(scale: 0.5, anchor: .top)))
                    .animation(.spring(duration: 500), value: isSelected)
                
                Circle()
                    .frame(width: 7, height: 7)
                    .foregroundStyle(favor.color.color.gradient)
            }
        }
        .onChange(of: isSelected) { old, new in
            if new{
                withAnimation(.spring.delay(0.25)) {
                    showBase = true
                }
            } else {
                showBase = false
            }
        }
        .onAppear() {
            if isSelected {
                showBase = true
            }
        }
    }
}
