import SwiftUI

struct CategoryCapsule: View {
    @Binding var selectedCategories: [FavorCategory]
    
    @State var category: FavorCategory
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.subheadline)
                .foregroundStyle(.white)
            
            Text(category.name)
                .font(.subheadline.bold())
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            
        }
        .frame(height: 40)
        .padding(.horizontal, 12)
        .background((isCategorySelected(category: category) ? category.color : .gray).gradient)
        .shadow(radius: 3)
        .clipShape(Capsule())
        .scaleEffect(selectedCategories.contains(category) ? 1 : 0.95)
        .animation(.bouncy, value: selectedCategories)
        .hoverEffect(.lift)
    }
    
    func isCategorySelected(category: FavorCategory) -> Bool {
        return (selectedCategories.contains(.all) || selectedCategories.contains(category))
    }
}

#Preview {
    VStack(spacing: 30) {
        // Selected Variants
        LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                CategoryCapsule(selectedCategories: .constant([.all]), category: category)
            }
        }
        
        // Unselected Variants
        LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                CategoryCapsule(selectedCategories: .constant([]), category: category)
            }
        }   
    }
}
