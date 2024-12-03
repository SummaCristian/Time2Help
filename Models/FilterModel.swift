import Foundation

class FilterModel: ObservableObject {
    @Published var selectedCategories: [FavorCategory]
    @Published var isCarNeededSelected: Bool
    @Published var isHeavyTaskSelected: Bool
    @Published var startingDate: Date
    @Published var endingDate: Date
    @Published var maxDuration: Int
    
    // Init with default values, that can also be Overridden if needed
    init(
        selectedCategories: [FavorCategory] = [.all],
        isCarNeededSelected: Bool = true,
        isHeavyTaskSelected: Bool = true,
        startingDate: Date = .now,
        endingDate: Date = .now,
        maxDuration: Int = 24
    ) {
        self.selectedCategories = selectedCategories
        self.isCarNeededSelected = isCarNeededSelected
        self.isHeavyTaskSelected = isHeavyTaskSelected
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.maxDuration = maxDuration
        
        setTime(of: [.startingTime], hour: 0, minute: 0, second: 0)
    }
    
    func reset() {
        selectedCategories = [.all]
        isCarNeededSelected = true
        isHeavyTaskSelected = true
        startingDate = .now
        endingDate = .now
        maxDuration = 24
        
        setTime(of: [.startingTime], hour: 0, minute: 0, second: 0)
        setTime(of: [.endingTime], hour: 23, minute: 59, second: 59)
    }
    
    func clone(source: FilterModel) {
        self.selectedCategories = source.selectedCategories
        self.isCarNeededSelected = source.isCarNeededSelected
        self.isHeavyTaskSelected = source.isHeavyTaskSelected
        self.startingDate = source.startingDate
        self.endingDate = source.endingDate
        self.maxDuration = source.maxDuration
    } 
    
    enum SettableTime {
        case startingTime
        case endingTime
    }
    
    func setTime(of: [SettableTime], hour: Int, minute: Int = 0, second: Int = 0) {
        if of.contains(.startingTime) {
            startingDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: startingDate) ?? Calendar.current.startOfDay(for: startingDate)
        }
        if of.contains(.endingTime) {
            endingDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: endingDate) ?? Calendar.current.startOfDay(for: endingDate)
        }
    }
    
    
    // Checks if a Favor satisfies all the requirements imposed by the various Filters
    func isFavorIncluded(favor: Favor) -> Bool {
        return isCategorySelected(category: favor.category) &&
        (isCarNeededSelected || !favor.isCarNecessary)  &&
        (isHeavyTaskSelected || !favor.isHeavyTask) &&
        (startingDate <= favor.startingDate && favor.endingDate <= endingDate) &&
        (favor.endingDate.timeIntervalSince(favor.startingDate) <= Double(maxDuration * 3600))
    }
    
    // Checks if the Category is selected in the current Filter
    func isCategorySelected(category: FavorCategory) -> Bool {
        return (selectedCategories.contains(.all) || selectedCategories.contains(category))
    }
    
    func selectCategory(category: FavorCategory) {
        if category != .all {
            if selectedCategories.contains(.all) {
                selectedCategories.removeAll()
            }
            if !selectedCategories.contains(category) {
                if selectedCategories.count == FavorCategory.allCases.count - 2 {
                    selectedCategories.removeAll()
                    selectedCategories.append(.all)
                } else {
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
                    selectedCategories.removeAll { $0 == category }
                } else {
                    selectedCategories.removeAll()
                    selectedCategories.append(.all)
                }
            }
        }
    }
}
