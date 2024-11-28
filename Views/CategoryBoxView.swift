import SwiftUI

struct CategoryBoxView: View {
    @State var category: FavorCategory
    
    @ObservedObject var filter: FilterModel
    
    var fillStyle: AnyShapeStyle {
        filter.isCategorySelected(category: category) ? AnyShapeStyle(category.color.gradient) : AnyShapeStyle(.thickMaterial)
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: category.icon)
                .foregroundStyle(filter.isCategorySelected(category: category) ? .white : .primary)
            
            Text(category.name)
                .font(.caption2.bold())
                .foregroundStyle(filter.isCategorySelected(category: category) ? .white : .primary)
        }
        .frame(width: 80, height: 80)
        .background {
            if filter.isCategorySelected(category: category) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(fillStyle)
                    .shadow(color: category.color.opacity(0.2) ,radius: 20)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(category.color.secondary, lineWidth: 4)
            }
        }
        .hoverEffect()
        .scaleEffect(filter.isCategorySelected(category: category) ? 0.7 : 0.65)
        .animation(.bouncy, value: filter.selectedCategories)
    }
    
}

#Preview {
    ScrollView {
        VStack(spacing: 30) {
            // Selected
            LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
                ForEach(FavorCategory.allCases) { category in
                    CategoryBoxView(category: category, filter: FilterModel())
                        .padding()
                }
            }
            
            // Unselected
            LazyVGrid(columns: [.init(.adaptive(minimum: 150), spacing: 10)]) {
                ForEach(FavorCategory.allCases) { category in
                    CategoryBoxView(category: category, filter: FilterModel(selectedCategories: []))
                        .padding()
                }
            }
        }
    }
}
