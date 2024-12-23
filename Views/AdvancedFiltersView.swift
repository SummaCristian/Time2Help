import SwiftUI

struct AdvancedFiltersView: View {
    @State var screenWidth: CGFloat
    @State var screenHeight: CGFloat
    
    @ObservedObject var filter: FilterModel
    
    @Binding var isAdvancedFiltersViewShowing: Bool
    
    @State private var internalMaxDuration: Int = 24
    @State private var isAllDaySelected = false
    @State private var showTimePickers = false
    
    @State private var temporaryFilter: FilterModel = FilterModel()
    
    @State private var isAllTypesSelectedTemp: Bool = true
    @State private var isPrivateTypeSelectedTemp: Bool = true
    @State private var isPublicTypeSelectedTemp: Bool = true
    
    var body: some View {
            ScrollView {
                VStack {
                    // Category Filters
                    HStack(spacing: 5) {
                        Image(systemName: "tag.fill")
                        VStack(alignment: .leading) {
                            Text("Categorie")
                                .font(.title3.bold())
                            
                            Text("Seleziona le categorie che ti interessano")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    LazyVGrid(columns: Array(repeating: .init(.fixed(55)), count: 5), spacing: 0) {
                        ForEach(FavorCategory.allCases) { category in
                            CategoryBoxView(category: category, filter: temporaryFilter)
                                .frame(maxHeight: 60)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    if temporaryFilter.selectedCategories.contains(category) {
                                        temporaryFilter.deselectCategory(category: category)
                                    } else {
                                        temporaryFilter.selectCategory(category: category)
                                    }
                                }
                        }
                    }
                    
                    // Date and Time Filters
                    HStack(spacing: 5) {
                        Image(systemName: "clock.fill")
                        VStack(alignment: .leading) {
                            Text("Data, ora e durata")
                                .font(.title3.bold())
                            
                            Text("Imposta data, ora o durata per filtrare i Favori")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    
                    // Starting Date and Time
                    Toggle(isOn: $isAllDaySelected, label: {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundStyle(Color(.white))
                                .frame(width: 30, height: 30)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundStyle(Color(.systemYellow))
                                }
                            
                            VStack(alignment: .leading) {
                                Text("Tutto il giorno")
                                
                                Text("Imposta qualunque orario")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    })
                    .tint(.yellow)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thickMaterial)
                    }
                    
                    HStack {
                        VStack {
                            Text("Inizio")
                                .font(.headline.bold())
                            
                            if !showTimePickers {
                                DatePicker("Inizio", selection: $temporaryFilter.startingDate, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            DatePicker("Inizio", selection: $temporaryFilter.startingDate, displayedComponents: .date)
                                .labelsHidden()
                            
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.thickMaterial)
                        }
                        
                        // Ending Date and Time
                        VStack {
                            Text("Fine")
                                .font(.headline.bold())
                            
                            if !showTimePickers {
                                DatePicker("Fine", selection: $temporaryFilter.endingDate, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                            }
                            DatePicker("Fine", selection: $temporaryFilter.endingDate, displayedComponents: .date)
                                .labelsHidden()
                            
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.thickMaterial)
                        }
                    }
                    .tint(.yellow)
                    
                    // Duration
                    Stepper(value: $internalMaxDuration, in: 0 ... 24, step: 1) {
                        HStack(alignment: .center) {
                            Text("Durata:")
                            
                            Spacer()
                            
                            Text(String(temporaryFilter.maxDuration))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.yellow)
                                .contentTransition(.numericText())
                            
                            Text("ore")
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thickMaterial)
                    }
                    .tint(.yellow)
                    
                    // Public and Private types
                    HStack(spacing: 5) {
                        Image(systemName: "person.2.fill")
                        
                        VStack(alignment: .leading) {
                            Text("Tipo di Favore")
                                .font(.title3.bold())
                            
                            Text("Filtra in base alla tua preferenza sul tipo")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    VStack {
                        Toggle(isOn: $isAllTypesSelectedTemp, label: {
                            HStack(spacing: 8) {
                                Image(systemName: "person.2.fill")
                                    .foregroundStyle(Color(.white))
                                    .frame(width: 30, height: 30)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundStyle(Color(.blue))
                                    }
                                
                                Text("Tutti")
                            }
                        })
                        .tint(.blue)
                        
                        if !isAllTypesSelectedTemp {
                            
                            Divider()
                            
                            Toggle(isOn: $isPrivateTypeSelectedTemp, label: {
                                HStack(spacing: 8) {
                                    Image(systemName: FavorType.privateFavor.icon)
                                        .foregroundStyle(Color(.white))
                                        .frame(width: 30, height: 30)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color(.blue))
                                        }
                                    
                                    Text("Singolo")
                                }
                            })
                            .tint(.blue)
                            
                            Divider()
                            
                            Toggle(isOn: $isPublicTypeSelectedTemp, label: {
                                HStack(spacing: 8) {
                                    Image(systemName: FavorType.publicFavor.icon)
                                        .font(.subheadline)
                                        .foregroundStyle(Color(.white))
                                        .frame(width: 30, height: 30)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundStyle(Color(.blue))
                                        }
                                    
                                    Text("Gruppo")
                                }
                            })
                            .tint(.blue)
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thickMaterial)
                    }
                    
                    // Car Needed and Heavy Task Filters
                    HStack(spacing: 5) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        
                        VStack(alignment: .leading) {
                            Text("Info aggiuntive")
                                .font(.title3.bold())
                            
                            Text("Escludi ciò che ritieni di non poter fare")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    VStack {
                        Toggle(isOn: $temporaryFilter.isCarNeededSelected, label: {
                            HStack(spacing: 8) {
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
                        
                        Toggle(isOn: $temporaryFilter.isHeavyTaskSelected, label: {
                            HStack(spacing: 8) {
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
                }
                .padding(.vertical, 70)
                .padding(.horizontal)
        .padding(.horizontal)
        .padding(.vertical, 24)
        .frame(width: screenWidth > 500 ? 360 : screenWidth - 40, alignment: .top)
        .frame(maxHeight: screenHeight > 900 ? 780 : 600)
        
        .overlay {
            // Title and Close Button
            VStack {
                VStack {
                    HStack {
                        Text("Filtri avanzati")
                            .font(.title.bold())
                        
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
                }
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
                        .tint(.blue)
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
            
            isAllTypesSelectedTemp = temporaryFilter.isAllTypesSelected
            isPrivateTypeSelectedTemp = temporaryFilter.isPrivateTypeSelected
            isPublicTypeSelectedTemp = temporaryFilter.isPublicTypeSelected
        }
        .onChange(of: internalMaxDuration) {_, _ in
            withAnimation {
                temporaryFilter.maxDuration = internalMaxDuration
            }    
        }
        .onChange(of: isAllDaySelected) { old, new in
            if new {
                // Is All Day
                temporaryFilter.setTime(of: [.startingTime], hour: 0, minute: 0, second: 0)
                temporaryFilter.setTime(of: [.endingTime], hour: 23, minute: 59, second: 59)
                
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
        .onChange(of: isAllTypesSelectedTemp) { old, new in
            if new {
                withAnimation {
                    temporaryFilter.selectType(type: .all)
                }
            } else {
                withAnimation {
                    temporaryFilter.selectType(type: .privateFavor)
                }
            }
        }
        .onChange(of: isPrivateTypeSelectedTemp) {old, new in
            if new {
                withAnimation {
                    if isPublicTypeSelectedTemp {
                        temporaryFilter.selectType(type: .all)
                    } else {
                        temporaryFilter.selectType(type: .publicFavor)
                    }
                }
            } else {
                withAnimation {
                    if isPublicTypeSelectedTemp {
                        temporaryFilter.selectType(type: .publicFavor)
                    } else {
                        temporaryFilter.selectType(type: .privateFavor)
                    }
                }
            }
        }
        .onChange(of: isPublicTypeSelectedTemp) {old, new in
            if new {
                withAnimation {
                    if isPrivateTypeSelectedTemp {
                        temporaryFilter.selectType(type: .all)
                    } else {
                        temporaryFilter.selectType(type: .privateFavor)
                    }
                }
            } else {
                withAnimation {
                    if isPrivateTypeSelectedTemp {
                        temporaryFilter.selectType(type: .privateFavor)
                    } else {
                        temporaryFilter.selectType(type: .publicFavor)
                    }
                }
            }
        }
        .onChange(of: temporaryFilter.isAllTypesSelected) { _, _ in
            isAllTypesSelectedTemp = temporaryFilter.isAllTypesSelected
        }
        .onChange(of: temporaryFilter.isPrivateTypeSelected) { _, _ in
            isPrivateTypeSelectedTemp = temporaryFilter.isPrivateTypeSelected    
        }
        .onChange(of: temporaryFilter.isPublicTypeSelected) { _, _ in
            isPublicTypeSelectedTemp = temporaryFilter.isPublicTypeSelected
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
    .padding()
    .background {
        RoundedRectangle(cornerRadius: 32)
            .fill(.thinMaterial)
    }
}
