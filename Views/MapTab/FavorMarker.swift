import SwiftUI

// This file contains the UI for the single Favor Map Marker, used to show the location
// of a Favor on the Map.

struct FavorMarker: View {
    @Environment(\.colorScheme) var colorScheme
    
    // The Favor associated to this UI Element
    @ObservedObject var favor: Favor
    
    @Binding var isSelected: Bool
    
    var isInFavorSheet: Bool
    
    var isOwner: Bool
    
    @State private var moveTitle = false
    
    @State private var scale: Double = 0
    
    @State private var iconConfig: MultiProfileIconConfig = .markerSmall
    
    // The UI
    var body: some View {
        ZStack(alignment: moveTitle ? .center : .leading) {
            ZStack(alignment: .center) {
                if isOwner {
                    Hexagon()
                        .frame(width: 7, height: 7)
                        .foregroundStyle(favor.color.gradient)
                } else {
                    Circle()
                        .frame(width: 7, height: 7)
                        .foregroundStyle(favor.color.gradient)
                }
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .rotationEffect(.degrees(180))
                    .offset(y: isSelected ? -15 : 7)
                
                // Inner Circle
                if isOwner {
                    Hexagon()
                        .foregroundStyle(favor.color.gradient)
                        .frame(
                            width: isSelected ? 50 : 30,
                            height: isSelected ? 50 : 30)
                        .padding(.all, 2.5)
                        .background {
                            Hexagon()
                                .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                        }
                        .padding(.all, isSelected ? -1 : 1.5)
                        .background {
                            Hexagon()
                                .foregroundStyle(favor.color.gradient)
                        }
                        .offset(y: isSelected ? -45 : 0)
                } else {
                    Circle()
                        .foregroundStyle(favor.color.gradient)
                        .frame(
                            width: isSelected ? 50 : 30,
                            height: isSelected ? 50 : 30)
                        .padding(.all, 2.5)
                        .background {
                            Circle()
                                .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                        }
                        .padding(.all, isSelected ? -1 : 1.5)
                        .background {
                            Circle()
                                .foregroundStyle(favor.color.gradient)
                        }
                        .offset(y: isSelected ? -45 : 0)
                }
                
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
                
                if (!isInFavorSheet && !favor.helpers.isEmpty) {
                    MultiProfileIconView(config: $iconConfig, users: $favor.helpers)
                        .offset(x: moveTitle ? 4 : 0, y: moveTitle ? -40 : 0)
                }
            }
        }
        .onChange(of: moveTitle) { old, new in
            withAnimation {
                iconConfig = moveTitle ? .markerBig : .markerSmall
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
                if favor.helpers.isEmpty {
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
    ScrollView {
        
        // Selected Non-Owner Variant
        LazyVGrid(columns: [.init(.adaptive(minimum: 100), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                
                FavorMarker(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .individual, location: MapDetails.startingLocation, isCarNecessary: false, isHeavyTask: false, status: .halfwayThere, category: category), isSelected: .constant(true), isInFavorSheet: true, isOwner: false)
                    .padding(.bottom, 50)
            }
        }
        .padding(.top, 50)
        
        // Unselected Non-Owner Variant
        LazyVGrid(columns: [.init(.adaptive(minimum: 100), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                
                FavorMarker(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .individual, location: MapDetails.startingLocation, isCarNecessary: false, isHeavyTask: false, status: .halfwayThere, category: category), isSelected: .constant(false), isInFavorSheet: true, isOwner: false)
                    .padding(.bottom, 50)

            }
        }
        
        // Selected Owner Variant
        LazyVGrid(columns: [.init(.adaptive(minimum: 100), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                
                FavorMarker(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .individual, location: MapDetails.startingLocation, isCarNecessary: false, isHeavyTask: false, status: .halfwayThere, category: category), isSelected: .constant(true), isInFavorSheet: true, isOwner: true)
                    .padding(.bottom, 50)
            }
        }
        .padding(.top, 50)
        
        // Unselected Owner Variant
        LazyVGrid(columns: [.init(.adaptive(minimum: 100), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                
                FavorMarker(favor: .init(title: "Test", description: "Test", author: .init(nameSurname: .constant("Name Surname"), neighbourhood: .constant("Città Studi"), profilePictureColor: .constant("blue")), neighbourhood: "Città Studi", type: .individual, location: MapDetails.startingLocation, isCarNecessary: false, isHeavyTask: false, status: .halfwayThere, category: category), isSelected: .constant(false), isInFavorSheet: true, isOwner: true)
                    .padding(.bottom, 50)
                
            }
        }
    }
}
