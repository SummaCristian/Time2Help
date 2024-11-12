import SwiftUI

struct CategoryCapsule: View {
    @Binding var selectedCategories: [FavorCategory]
    
    @State var category: FavorCategory
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: category.icon)
                .foregroundStyle(.white)
            
            Text(category.name)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            
        }
        .padding(12)
        .background(isCategorySelected(category: category) ? category.color.gradient : Color.gray.gradient)
        .shadow(radius: 3)
        .clipShape(Capsule())
        .scaleEffect(selectedCategories.contains(category) ? 1 : 0.95)
        .animation(.bouncy, value: selectedCategories)
    }
    
    func isCategorySelected(category: FavorCategory) -> Bool {
        return (selectedCategories.contains(.all) || selectedCategories.contains(category)) 
    }
}
