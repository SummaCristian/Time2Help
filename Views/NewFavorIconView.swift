import SwiftUI

// This file contains the UI for the New Favor's Icon Editing sheet.

struct NewFavorIconSheet: View {
    // The newly created Favor, whose icon is being edited    
    @StateObject var newFavor: Favor
    
    // The UI
    var body: some View {
        Spacer().frame(height: 80)
        
        VStack(spacing: 20) {
            // The Icon Preview box
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .foregroundStyle(newFavor.color.color)
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
                        ZStack {
                            // The selector: is shown if this color is currently selected
                            Circle()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.foreground)
                                .opacity(newFavor.color == colorCase ? 0.4 : 0)

                            // The color itself
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(Color(colorCase.color))
                                .onTapGesture() {
                                    // Sets the color inside the Favor
                                    withAnimation {
                                        newFavor.color = colorCase
                                    }
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
                            // The selector: is only shown if this icon is selected
                            Circle()
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.foreground)
                                .opacity(newFavor.icon == iconCase ? 0.4 : 0)
                            
                            // The Icon's circular background
                            Circle()
                                .frame(width: 37, height: 37)
                                .foregroundStyle(Color(.systemGray2))
                            
                            // The icon itself
                            Image(systemName: iconCase.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.foreground)
                                .opacity(0.8)
                                .frame(width: 23, height: 23)
                            
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
