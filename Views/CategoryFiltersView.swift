import SwiftUI

struct CategoryFiltersView: View {
    @Binding var selectedCategories: [FavorCategory]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FavorCategory.allCases) { category in
                    CategoryCapsule(selectedCategories: $selectedCategories, category: category)
                        .onTapGesture {
                            if category == .all {
                                // The "Tutte" capsule
                                selectCategory(category: .all)
                            } else {
                                // The real categories
                                if selectedCategories.contains(category) {
                                    deselectCategory(category: category)
                                } else {
                                    selectCategory(category: category)
                                }
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func selectCategory(category: FavorCategory) {
        if category != .all {
            if selectedCategories.contains(.all) {
                // Selects onlt the clicked category
                selectedCategories.removeAll()
            }
            if !selectedCategories.contains(category) {
                if selectedCategories.count == FavorCategory.allCases.count - 2 {
                    // All Categories have been selected, switch to .all
                    selectedCategories.removeAll()
                    selectedCategories.append(.all)
                } else {
                    // Adds the current category to the selection
                    selectedCategories.append(category)
                }
            }
        } else {
            selectedCategories.removeAll()
            selectedCategories.append(.all)
        }
    }
    
    func deselectCategory(category: FavorCategory) {
        if category != .all {
            if selectedCategories.contains(category) {
                if selectedCategories.count > 1 {
                    // There are still selected categories excluding this one
                    selectedCategories.removeAll {$0 == category}
                } else {
                    // This one was the only one selected, returning to .all
                    selectedCategories.removeAll()
                    selectedCategories.append(.all)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        CategoryFiltersView(selectedCategories: .constant([.all]))
        CategoryFiltersView(selectedCategories: .constant([]))
    }
}
