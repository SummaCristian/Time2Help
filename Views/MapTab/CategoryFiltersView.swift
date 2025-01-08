import SwiftUI

struct CategoryFiltersView: View {
    @Namespace private var animationNamespace
    
    @ObservedObject var filter: FilterModel
    
    @Binding var isAdvancedFiltersViewShowing: Bool
    @State private var showBadge: Bool = false
    
    @State private var scrollingPosition: Int?
    
    // For animation
    @State private var moveToCenter = false
    @State private var blurContainer = true
    @State private var startClosing = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: isAdvancedFiltersViewShowing ? .top : .center, spacing: 10) {
                // Advanced Filters Button
                ZStack {
                    if !isAdvancedFiltersViewShowing {
                        Menu {
                            Button ("Filtri avanzati", systemImage: "slider.horizontal.3") {
                                openAdvancedFilters()
                            }
                            
                            Button("Reset", systemImage: "arrow.counterclockwise", role: .destructive) {
                                filter.reset()
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 20, weight: .medium))
                                .padding(10)
                                .foregroundStyle(.primary)
                        }
                        primaryAction: {
                            openAdvancedFilters()
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
                        .clipShape(RoundedRectangle(cornerRadius: 27))
                        .blur(radius: blurContainer ? 10 : 0)
                        .padding(5)
                    }
                }
                .frame(minHeight: 60)
                .background(.thinMaterial)
                .clipShape(isAdvancedFiltersViewShowing ? AnyShape(RoundedRectangle(cornerRadius: 32)) : AnyShape(Circle()))
                .overlay(alignment: .topTrailing) {
                    if !showBadge && filter.countActiveFilters != 0 {
                        Text(String(filter.countActiveFilters))
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.all, 6)
                            .background(.background, in: .circle)
                            .offset(x: 4)
                    }
                }
                .offset(
                    x: moveToCenter ? 130 : 0,
                    y: moveToCenter ? 200 : 0
                )
//                .shadow(radius: 3)
                .shadow(color: .gray.opacity(0.4), radius: 6)
                .onChange(of: isAdvancedFiltersViewShowing) { _, _ in
                    showBadge.toggle()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        // Real Categories
                        ForEach(FavorCategory.allCases) { category in
                            if (category == .all ? true : filter.selectedCategories.contains(category)) {
                                CategoryCapsule(filter: filter, category: category)
                                    .onTapGesture {
                                        let calculateActiveFiltersBool = !filter.selectedCategories.contains(.all)
                                        
                                        if category == .all {
                                            // The "Tutte" capsule
                                            withAnimation {
                                                filter.selectCategory(category: .all)
                                            }
                                        } else {
                                            // The real categories
                                            if filter.selectedCategories.contains(category) {
                                                withAnimation {
                                                    filter.deselectCategory(category: category)
                                                }
                                            } else {
                                                withAnimation {
                                                    filter.selectCategory(category: category)
                                                }
                                            }
                                        }
                                        
                                        if filter.selectedCategories.contains(.all) && calculateActiveFiltersBool {
                                            withAnimation {
                                                filter.calculateActiveFilters()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.trailing, 17.5)
                }
                .scrollDisabled(isAdvancedFiltersViewShowing)
                .padding(.leading, isAdvancedFiltersViewShowing ? 10 : 0)
            }
            .padding(.leading, 15)
            .frame(alignment: .top)
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
    
    func openAdvancedFilters() {
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
    }
}

#Preview {
    VStack(spacing: 50) {
        CategoryFiltersView(filter: FilterModel(), isAdvancedFiltersViewShowing: .constant(false))
        CategoryFiltersView(filter: FilterModel(selectedCategories: []), isAdvancedFiltersViewShowing: .constant(false))
    }
}
