import SwiftUI

struct AdvancedFiltersView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var screenWidth: CGFloat
    @State var screenHeight: CGFloat
    
    @ObservedObject var filter: FilterModel
    
    @Binding var isAdvancedFiltersViewShowing: Bool
    
    @State private var internalMaxDuration: Int = 1
    @State private var isAllDaySelected: Bool = false
    @State private var showDaysPicker: Bool = false
    @State private var showTimePickers: Bool = false
    @State private var showDurationPicker: Bool = false
    
    @StateObject private var temporaryFilter: FilterModel = FilterModel(allowNone: true)
    
    @State private var selectedType: SettableType = .indifferent
    @State private var isIndifferentTypesSelectedTemp: Bool = true
    @State private var isIndividualTypeSelectedTemp: Bool = false
    @State private var isGroupTypeSelectedTemp: Bool = false
    
    @State private var isAllCategorySelected: Bool = true
    @State private var showCategories: Bool = false
    
    @State private var ignoreChange: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                // Category Filters
                HStack(spacing: 8) {
                    Image(systemName: "tag.fill")
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Categorie")
                            .font(.title3.bold())
                        
                        Text("Seleziona le categorie che ti interessano")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                
                CategoryPicker(isAllCategorySelected: $isAllCategorySelected, showCategories: $showCategories, filterModel: temporaryFilter)
                
                // Date and Time Filters
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Data, ora e durata")
                            .font(.title3.bold())
                        
                        Text("Imposta data, ora o durata per filtrare i Favori")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                // Starting Date and Time
                Toggle(isOn: $temporaryFilter.isFilterDaysSelected, label: {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .foregroundStyle(Color(.white))
                            .frame(width: 30, height: 30)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(Color(.systemOrange))
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Giorno")
                            
                            Text("Filtra per giorno i favori")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                })
                .tint(.orange)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thickMaterial)
                }
                
                if showDaysPicker {
                    Toggle(isOn: $isAllDaySelected, label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tutto il giorno")
                                .font(.subheadline)
                            
                            Text("Imposta qualunque orario")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    })
                    .tint(.orange)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thickMaterial)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack {
                            Text("Inizio")
                                .font(.headline.bold())
                            
                            DatePicker("Inizio", selection: $temporaryFilter.startingDate, displayedComponents: .date)
                                .labelsHidden()
                            
                            if !showTimePickers {
                                DatePicker("Inizio", selection: $temporaryFilter.startingDate, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.thickMaterial)
                        }
                        
                        // Ending Date and Time
                        VStack {
                            Text("Fine")
                                .font(.headline.bold())
                            
                            DatePicker("Fine", selection: $temporaryFilter.endingDate, in: temporaryFilter.startingDate..., displayedComponents: .date)
                                .labelsHidden()
                            
                            if !showTimePickers {
                                DatePicker("Fine", selection: $temporaryFilter.endingDate, in: temporaryFilter.startingDate..., displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.thickMaterial)
                        }
                    }
                    .padding(.horizontal)
                    .tint(.orange)
                }
                
                // Duration
                Toggle(isOn: $temporaryFilter.isFilterDurationSelected, label: {
                    HStack(spacing: 12) {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(Color(.white))
                            .frame(width: 30, height: 30)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(Color(.systemOrange))
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Durata")
                            
                            Text("Filtra per durata i favori")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                })
                .tint(.orange)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thickMaterial)
                }
                
                if showDurationPicker {
                    Stepper(value: $internalMaxDuration, in: 1 ... 24, step: 1) {
                        HStack(alignment: .center) {
                            Text("Durata:")
                            
                            Spacer()
                            
                            Text("< " + String(temporaryFilter.maxDuration))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.orange)
                                .contentTransition(.numericText())
                            
                            Text(temporaryFilter.maxDuration == 1 ? "ora" : "ore")
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thickMaterial)
                    }
                    .tint(.orange)
                    .padding(.horizontal)
                }
                
                // Public and Private types
                HStack(spacing: 8) {
                    Image(systemName: "person.2.fill")
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Modalità di partecipazione")
                            .font(.title3.bold())
                        
                        Text("Filtra in base alla tua preferenza sulla modalità")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                let zStackWidth = (screenWidth > 500 ? 360 : screenWidth) - 88 // screenWidth - 30 - 10 - 32 - 16
                // Adjusted for bigger screen sizes
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(colorScheme == .dark ? Color(.systemGray6) : .white)
                        .frame(width: (zStackWidth - 4)/3)
                        .shadow(color: .gray.opacity(colorScheme == .dark ? 0.1 : 0.2), radius: 6)
                        .offset(x: CGFloat(selectedType.int) * (zStackWidth/3))
                    
                    HStack(spacing: 0) {
                        ForEach(SettableType.allCases) { type in
                            VStack(spacing: 8) {
                                Image(systemName: type == .indifferent ? "person.2.fill" : type == .individual ? FavorType.individual.icon : FavorType.group.icon)
                                
                                Text(type.name)
                                    .font(.subheadline)
                            }
                            .frame(width: zStackWidth/3)
                            .contentShape(Rectangle())
                            .padding(.vertical, 12)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedType = type
                                }
                            }
                        }
                    }
                }
                .padding(.all, 8)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thickMaterial)
                }
                
                // Car Needed and Heavy Task Filters
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .frame(width: 30)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Info aggiuntive")
                            .font(.title3.bold())
                        
                        Text("Escludi ciò che ritieni di non poter fare")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                VStack {
                    Toggle(isOn: $temporaryFilter.isCarNeededSelected, label: {
                        HStack(spacing: 12) {
                            Image(systemName: "car.fill")
                                .foregroundStyle(Color(.white))
                                .frame(width: 30, height: 30)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(Color(.systemRed))
                                }
                            
                            Text("Auto necessaria")
                        }
                    })
                    .tint(.red)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Toggle(isOn: $temporaryFilter.isHeavyTaskSelected, label: {
                        HStack(spacing: 12) {
                            Image(systemName: "hammer.fill")
                                .foregroundStyle(Color(.white))
                                .frame(width: 30, height: 30)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(Color(.systemGreen))
                                }
                            
                            Text("Lavoro faticoso")
                        }
                    })
                    .tint(.green)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thickMaterial)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 70)
        .padding(.vertical, 24)
        .frame(width: screenWidth > 500 ? 360 : screenWidth - 40, alignment: .top)
        .frame(maxHeight: screenHeight > 900 ? 780 : 600)
        .overlay {
            // Title and Close Button
            VStack {
                HStack(spacing: 16) {
                    Text("Filtri avanzati")
                        .font(.title.bold())
                        .padding(.horizontal, 4)
                    
                    Spacer()
                    
                    // Close Button
                    Button {
                        isAdvancedFiltersViewShowing.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
                            .foregroundColor(.primary)
                            .padding(10)
                    }
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                    .hoverEffect(.lift)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 24)
                .background {
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                }
                
                Spacer()
                
                VStack {
                    HStack(spacing: 16) {
                        Button(
                            role: .destructive,
                            action: {
                                temporaryFilter.reset()
                                isAllCategorySelected = true
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedType = .indifferent
                                }
                            }, label: {
                                Label(
                                    title: {
                                        Text("Reset")
                                    },
                                    icon: {
                                        Image(systemName: "arrow.counterclockwise")
                                    }
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            })
                        .buttonStyle(BorderedButtonStyle())
                        .buttonBorderShape(.capsule)
                        .tint(.red)
                        .hoverEffect(.lift)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 10)
                        
                        Button(
                            role: .cancel,
                            action: {
                                // Update filters count
                                temporaryFilter.calculateActiveFilters()
                                
                                // Cloning the temporaryFilter into the main Filter
                                filter.clone(source: temporaryFilter)
                                
                                // Closing the popup
                                isAdvancedFiltersViewShowing.toggle()
                            }, label: {
                                Label(
                                    title: {
                                        Text("Applica")
                                    },
                                    icon: {
                                        Image(systemName: "checkmark")
                                    }
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            })
                        .buttonStyle(BorderedProminentButtonStyle())
                        .buttonBorderShape(.capsule)
                        .tint(temporaryFilter.selectedCategories.isEmpty ? .gray : .blue)
                        .disabled(temporaryFilter.selectedCategories.isEmpty)
                        .hoverEffect(.lift)
                        .frame(maxWidth: .infinity)
                        .shadow(radius: 3)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 24)
                }
                .frame(height: 80)
                .background {
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                }
            }
        }
        .onAppear {
            temporaryFilter.clone(source: filter)
            
            internalMaxDuration = temporaryFilter.maxDuration
            
            if (
                temporaryFilter.startingDate.isTime(hour: 0, minute: 0) &&
                temporaryFilter.endingDate.isTime(hour: 23, minute: 59)
            ) {
                isAllDaySelected = true
            }
            
            selectedType = temporaryFilter.isIndifferentTypesSelected ? .indifferent : temporaryFilter.isIndividualTypeSelected ? .individual : .group
            isIndifferentTypesSelectedTemp = temporaryFilter.isIndifferentTypesSelected
            isIndividualTypeSelectedTemp = temporaryFilter.isIndividualTypeSelected
            isGroupTypeSelectedTemp = temporaryFilter.isGroupTypeSelected
            
            // Sync categories filters
            showCategories = !temporaryFilter.isCategorySelected(category: .all)
            if showCategories {
                ignoreChange = true
            }
            isAllCategorySelected = filter.isCategorySelected(category: .all)
        }
        .onChange(of: temporaryFilter.selectedCategories, { _, new in
            if new.contains(.all) {
                isAllCategorySelected = true
            } else {
                isAllCategorySelected = false
            }
        })
        .onChange(of: isAllCategorySelected) { old, new in
            DispatchQueue.main.async {
                if !ignoreChange {
                    if new {
                        // All
                        temporaryFilter.selectCategory(category: .all)
                    } else {
                        // None
                        if temporaryFilter.selectedCategories.contains(.all) {
                            temporaryFilter.selectedCategories.removeAll()
                        }
                    }
                }
                ignoreChange = false
            }
            
            if old {
                withAnimation {
                    showCategories = old
                }
            }
        }
        .onChange(of: temporaryFilter.isFilterDaysSelected, { _, new in
            withAnimation {
                showDaysPicker = new
            }
            
            if !new && !isAllDaySelected {
                DispatchQueue.main.async {
                    isAllDaySelected = true
                }
            }
        })
        .onChange(of: isAllDaySelected) { old, new in
            if new {
                // Is All Day
                DispatchQueue.main.async {
                    temporaryFilter.setTime(of: [.startingTime], hour: 0, minute: 0, second: 0)
                    temporaryFilter.setTime(of: [.endingTime], hour: 23, minute: 59, second: 59)
                }
                
                withAnimation {
                    showTimePickers = true
                }
            } else {
                // Not All Day
                temporaryFilter.startingDate = .now
                temporaryFilter.endingDate = .now.addingTimeInterval(3600)
                
                withAnimation {
                    showTimePickers = false
                }
            }
        }
        .onChange(of: temporaryFilter.isFilterDurationSelected, { _, new in
            withAnimation {
                showDurationPicker = new
            }
        })
        .onChange(of: internalMaxDuration) {_, _ in
            withAnimation {
                temporaryFilter.maxDuration = internalMaxDuration
            }
        }
        .onChange(of: selectedType) { _, new in
            if new == .indifferent {
                temporaryFilter.selectType(type: .indifferent)
            } else if new == .individual {
                temporaryFilter.selectType(type: .individual)
            } else {
                temporaryFilter.selectType(type: .group)
            }
        }
        .onChange(of: temporaryFilter.isIndifferentTypesSelected) { _, new in
            isIndifferentTypesSelectedTemp = temporaryFilter.isIndifferentTypesSelected
        }
        .onChange(of: temporaryFilter.isIndividualTypeSelected) { _, _ in
            isIndividualTypeSelectedTemp = temporaryFilter.isIndividualTypeSelected
        }
        .onChange(of: temporaryFilter.isGroupTypeSelected) { _, _ in
            isGroupTypeSelectedTemp = temporaryFilter.isGroupTypeSelected
        }
        .sensoryFeedback(.levelChange, trigger: internalMaxDuration)
        .sensoryFeedback(.levelChange, trigger: temporaryFilter.selectedCategories)
    }
}

extension Date {
    func isTime(hour: Int, minute: Int) -> Bool {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        return components.hour == hour && components.minute == minute
    }
}

#Preview {
    AdvancedFiltersView(
        screenWidth: 360,
        screenHeight: 850,
        filter: FilterModel(),
        isAdvancedFiltersViewShowing: .constant(true)
    )
//    .background {
//        RoundedRectangle(cornerRadius: 32)
//            .fill(.thinMaterial)
//    }
    .clipShape(RoundedRectangle(cornerRadius: 32))
    .padding(5)
    .shadow(radius: 1)
}
