import SwiftUI

struct NewFavorIconSheet: View {
    @State private var selectedDetent: PresentationDetent = .large
    
    var body: some View {
        Spacer().frame(height: 80)
        
        VStack(spacing: 20) {
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .foregroundStyle(.orange)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 3)
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .frame(width: 50, height: 50)                        
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
            
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), content: {
                    ForEach(FavorColor.allCases) { colorCase in
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color(colorCase.color))
                        }
                    }
                })
                .padding(10)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
            
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), content: {
                    ForEach(FavorIcon.allCases) { iconCase in
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color(.systemGray))
                            Image(systemName: iconCase.icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color(.systemGray6))
                                .frame(width: 25, height: 25)
                            
                        }
                        .padding(5)
                    }
                })
                .padding(1)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
        }
                
        Spacer()
    }
}
