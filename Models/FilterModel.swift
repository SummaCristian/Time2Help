import Foundation

class FilterModel: ObservableObject {
    @Published var selectedCategories: [FavorCategory]
    @Published var isCarNeededSelected: Bool
    @Published var isHeavyTaskSelected: Bool
    @Published var startingDate: Date
    @Published var endingDate: Date
    @Published var maxDuration: Int
    @Published var isAllTypesSelected: Bool
    @Published var isPrivateTypeSelected: Bool
    @Published var isPublicTypeSelected: Bool
    
    // Init with default values, that can also be Overridden if needed
    init(
        selectedCategories: [FavorCategory] = [.all],
        isCarNeededSelected: Bool = true,
        isHeavyTaskSelected: Bool = true,
        startingDate: Date = .now,
        endingDate: Date = .now,
        maxDuration: Int = 24,
        isAllTypesSelected: Bool = true,
        isPrivateTypeSelected: Bool = true,
        isPublicTypeSelected: Bool = true
    ) {
        self.selectedCategories = selectedCategories
        self.isCarNeededSelected = isCarNeededSelected
        self.isHeavyTaskSelected = isHeavyTaskSelected
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.maxDuration = maxDuration
        self.isAllTypesSelected = isAllTypesSelected
        self.isPrivateTypeSelected = isPrivateTypeSelected
        self.isPublicTypeSelected = isPublicTypeSelected
        
        setTime(of: [.startingTime], hour: 0, minute: 0, second: 0)
    }
    
    func reset() {
        selectedCategories = [.all]
        isCarNeededSelected = true
        isHeavyTaskSelected = true
        startingDate = .now
        endingDate = .now
        maxDuration = 24
        selectType(type: .all)
        
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
        self.isAllTypesSelected = source.isAllTypesSelected
        self.isPublicTypeSelected = source.isPublicTypeSelected
        self.isPrivateTypeSelected = source.isPrivateTypeSelected
    }
    
    enum SettableType {
        case all
        case privateFavor
        case publicFavor
    }
    
    func selectType(type: SettableType) {
        switch type {
        case .all:
            isAllTypesSelected = true
            isPrivateTypeSelected = true
            isPublicTypeSelected = true
        case .privateFavor:
            isAllTypesSelected = false
            isPrivateTypeSelected = true
            isPublicTypeSelected = false
        case .publicFavor:
            isAllTypesSelected = false
            isPrivateTypeSelected = false
            isPublicTypeSelected = true
        }
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
        (isFavorInAnyTimeSlot(slots: favor.timeSlots)) &&
        (favor.type == .privateFavor ? isPrivateTypeSelected : isPublicTypeSelected)
    }
    
    func isFavorInAnyTimeSlot(slots: [TimeSlot]) -> Bool {
        for slot in slots {
            if (startingDate <= slot.startingDate && slot.endingDate <= endingDate) &&
                slot.endingDate.timeIntervalSince(slot.startingDate) <= Double(maxDuration * 3600) {
                return true // Exit immediately if the condition is satisfied
            }
        }
        return false // Return false if no matching slot is found
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
