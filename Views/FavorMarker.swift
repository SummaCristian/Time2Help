import SwiftUI

// This file contains the UI for the single Favor Map Marker, used to show the location
// of a Favor on the Map.

struct FavorMarker: View {
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Outer Circle with Stroke Border
                Circle()
                    .frame(width: 55, height: 55)
                    .foregroundStyle(Color.white)
                
                // Inner Circle
                Circle()
                    .foregroundStyle(favor.color.color)
                    .frame(width: 50, height: 50)
                
                // Icon inside the Circle
                Image(systemName: favor.icon.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color.white)
            }
            
            // Triangle Pin
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color.white)                                
                .rotationEffect(.degrees(180))
                .offset(y: -3)
                .padding(.bottom, 80)
        }
    }
}
