import SwiftUI

struct CategoryPicker: View {
    @Binding var isAllCategorySelected: Bool
    @Binding var showCategories: Bool
    @ObservedObject var filterModel: FilterModel
    
    @State private var count = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Toggle(isOn: $isAllCategorySelected, label: {
                HStack(spacing: 8) {
                    Image(systemName: FavorCategory.all.icon)
                        .foregroundStyle(Color(.white))
                        .frame(width: 30, height: 30)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color(.systemYellow))
                        }
                    
                    VStack(alignment: .leading) {
                        Text("Tutte")
                        
                        Text("Mostra tutte le Categorie")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            })
            .tint(.yellow)
            
            if showCategories {
                VStack {
                    if count != 0 && !filterModel.isCategorySelected(category: .all) {
                        HStack(spacing: 0) {
                            Text(String(count))
                                .font(.subheadline.bold())
                                .contentTransition(.numericText())
                            
                            Text(" categorie selezionate")
                                .font(.subheadline.bold())
                        }
                    } else if filterModel.isCategorySelected(category: .all){
                        Text("Tutte le categorie selezionate")
                            .font(.subheadline.bold())
                            .foregroundStyle(.blue)
                    } else {
                        Text("Nessuna categoria selezionata")
                            .font(.subheadline.bold())
                            .foregroundStyle(.red)
                    }
                    
                    LazyVGrid(columns: Array(repeating: .init(.fixed(55)), count: 4), spacing: 0) {
                        ForEach(FavorCategory.allCases.filter({ $0 != .all })) { category in
                            CategoryBoxView(category: category, filter: filterModel)
                                .frame(maxHeight: 60)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    if filterModel.selectedCategories.contains(category) {
                                        filterModel.deselectCategory(category: category)
                                    } else {
                                        filterModel.selectCategory(category: category)
                                    }
                                }
                        }
                    }
                }
                .onAppear {
                    withAnimation {
                        count = filterModel.selectedCategories.count
                    }
                }
                .onChange(of: filterModel.selectedCategories.count) { old, new in
                    withAnimation {
                        count = new
                    }
                }
            }
            
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.thickMaterial)
        }
    }
}

#Preview {
    CategoryPicker(isAllCategorySelected: .constant(false), showCategories: .constant(true), filterModel: FilterModel())
}
