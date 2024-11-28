import SwiftUI

struct CategoryFiltersView: View {
    @Namespace private var animationNamespace
    
    @ObservedObject var filter: FilterModel
    
    @State private var isAdvancedFiltersViewShowing = false
    
    @State private var scrollingPosition: Int?
    
    // For animation
    @State private var moveToCenter = false
    @State private var blurContainer = true
    @State private var startClosing = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    // Advanced Filters Button
                    ZStack {
                        if !isAdvancedFiltersViewShowing {
                            Button {
                                var transaction = Transaction(animation: .smooth)
                                transaction.disablesAnimations = false
                                
                                withTransaction(transaction) {
                                    moveToCenter = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withTransaction(transaction) {
                                        moveToCenter = false
                                        isAdvancedFiltersViewShowing.toggle()
                                    }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withTransaction(transaction) {
                                        blurContainer = false
                                    }
                                }
                                
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 20, weight: .medium))
                                    .padding(10)
                                    .foregroundStyle(.primary)
                            }
                            .scaleEffect(moveToCenter ? 1.5 : 1)
                            .clipShape(Circle())
                            .hoverEffect(.lift)
                            .matchedGeometryEffect(id: "advancedFilters", in: animationNamespace)
                        } else {
                            AdvancedFiltersView(
                                screenWidth: geometry.size.width,
                                screenHeight: geometry.size.height,
                                filter: filter,
                                isAdvancedFiltersViewShowing: $startClosing
                            )
                            .matchedGeometryEffect(id: "advancedFilters", in: animationNamespace)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .blur(radius: blurContainer ? 10 : 0)
                            .padding(5)
                        }
                    }
                    .frame(minHeight: 60)
                    .background(.thinMaterial)
                    .clipShape(isAdvancedFiltersViewShowing ? AnyShape(RoundedRectangle(cornerRadius: 32)) : AnyShape(Circle()))
                    .offset(
                        x: moveToCenter ? 130 : 0, 
                        y: moveToCenter ? 200 : 0)
                    .shadow(radius: 3)
                    
                    HStack(spacing: 10) {
                        // Real Categories
                        ForEach(FavorCategory.allCases) { category in
                            CategoryCapsule(filter: filter, category: category)
                                .onTapGesture {
                                    if category == .all {
                                        // The "Tutte" capsule
                                        filter.selectCategory(category: .all)
                                    } else {
                                        // The real categories
                                        if filter.selectedCategories.contains(category) {
                                            filter.deselectCategory(category: category)
                                        } else {
                                            filter.selectCategory(category: category)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal)
                .frame(minHeight: 500, alignment: .top)
            }
            .scrollDisabled(isAdvancedFiltersViewShowing)
        }
        .sensoryFeedback(.impact, trigger: moveToCenter, condition: { old, new in
            new
        })
        .sensoryFeedback(.impact, trigger: startClosing, condition: { old, new in
            new
        })
        .sensoryFeedback(.levelChange, trigger: filter.maxDuration)
        
        .onChange(of: startClosing) { _, _ in
            if startClosing {
                var transaction = Transaction(animation: .smooth)
                transaction.disablesAnimations = false
                
                withTransaction(transaction) {
                    blurContainer = true
                    moveToCenter = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withTransaction(transaction) {
                        isAdvancedFiltersViewShowing.toggle()
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withTransaction(transaction) {
                        moveToCenter = false
                        startClosing = false
                    }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        CategoryFiltersView(filter: FilterModel())
        CategoryFiltersView(filter: FilterModel(selectedCategories: [])
        )
    }
}
