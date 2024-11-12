import SwiftUI

// This file contains the UI for the New Favor's Icon Editing sheet.

struct NewFavorIconSheet: View {
    // The newly created Favor, whose icon is being edited
    @StateObject var newFavor: Favor
    
    // The UI
    var body: some View {
        Spacer().frame(height: 40)
        
        VStack(spacing: 20) {
            // The Icon Preview box
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .foregroundStyle(newFavor.color.color.gradient)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 3)
                        .animation(.easeInOut, value: newFavor.color)
                    
                    Image(systemName: newFavor.icon.icon)
                        .resizable()
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .contentTransition(.symbolEffect(.automatic))
                    }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(Rectangle())
                .cornerRadius(5)
                
                Spacer()
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            
            // Color selector
            VStack {
                // A grid, showing 6 columns and as many rows as needed
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), content: {
                    ForEach(FavorColor.allCases) { colorCase in
                        // The color itself
                        Circle()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color(colorCase.color))
                            .padding(.all, 4)
                            .background {
                                // The selector: is shown if this color is currently selected
                                Circle()
                                    .stroke(.primary, lineWidth: 2)
                                    .opacity(newFavor.color == colorCase ? 1 : 0)
                            }
                            .onTapGesture() {
                                // Sets the color inside the Favor
                                withAnimation {
                                    newFavor.color = colorCase
                                }
                            }
                    }
                })
                .padding(10)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // Icon selector
            VStack {
                // A grid of 6 columns and as many rows as needed
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), content: {
                    ForEach(FavorIcon.allCases) { iconCase in
                        ZStack {
                            // The Icon's circular background
                            Circle()
                                .frame(width: 37, height: 37)
                                .foregroundStyle(Color(.systemGray3))
                            
                            // The icon itself
                            Image(systemName: iconCase.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.foreground)
                                .opacity(0.8)
                                .frame(width: 23, height: 23)
                            
                        }
                        .padding(.all, 4)
                        .background {
                            // The selector: is only shown if this icon is selected
                            Circle()
                                .stroke(.primary, lineWidth: 2)
                                .opacity(newFavor.icon == iconCase ? 1 : 0)
                        }
                        .padding(3)
                        .onTapGesture() {
                            // Sets the icon inside the Favor
                            withAnimation {
                                newFavor.icon = iconCase
                            }
                        }
                    }
                })
                .padding(10)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
        }
                
        Spacer()
    }
}
