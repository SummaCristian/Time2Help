import SwiftUI

struct CategoryCapsule: View {
    @ObservedObject var filter: FilterModel
    
    @State var category: FavorCategory
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.subheadline)
                .foregroundStyle(category == .all && isCategorySelected() ? .black : .white)
            
            Text(category.name)
                .font(.subheadline.bold())
                .fontDesign(.rounded)
                .foregroundStyle(category == .all && isCategorySelected() ? .black : .white)
            
        }
        .frame(height: 40)
        .padding(.horizontal, 12)
        .background((isCategorySelected() ? category.color : .gray).gradient)
        .shadow(radius: 3)
        .clipShape(Capsule())
        .scaleEffect(filter.selectedCategories.contains(category) ? 1 : 0.95)
        .animation(.bouncy, value: filter.selectedCategories)
        .hoverEffect(.lift)
    }
    
    func isCategorySelected() -> Bool {
        return (filter.selectedCategories.contains(.all) || filter.selectedCategories.contains(category))
    }
}

#Preview {
    VStack(spacing: 30) {
        // Selected Variants
        LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                CategoryCapsule(filter: FilterModel(), category: category)
            }
        }
        
        // Unselected Variants
        LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
            ForEach(FavorCategory.allCases) { category in
                CategoryCapsule(filter: FilterModel(selectedCategories: []), category: category)
            }
        }   
    }
}
