import SwiftUI

struct AdvancedFiltersView: View {
    @State var screenWidth: CGFloat
    @State var screenHeight: CGFloat
    
    @ObservedObject var filter: FilterModel
    
    @Binding var isAdvancedFiltersViewShowing: Bool
    
    @State private var internalMaxDuration: Int = 24
    @State private var isAllDaySelected = false
    @State private var showTimePickers = false
    
    var body: some View {
        ScrollView {
            VStack() {
                
                // Title and Close Button
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
                        CategoryBoxView(category: category, filter: filter)
                            .frame(maxHeight: 60)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                if filter.selectedCategories.contains(category) {
                                    filter.deselectCategory(category: category)
                                } else {
                                    filter.selectCategory(category: category)
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
                
                HStack {
                    VStack {
                        Text("Inizio")
                            .font(.headline.bold())
                        
                        if !showTimePickers {
                            DatePicker("Inizio", selection: $filter.startingDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        DatePicker("Inizio", selection: $filter.startingDate, displayedComponents: .date)
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
                            DatePicker("Fine", selection: $filter.endingDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        DatePicker("Fine", selection: $filter.endingDate, displayedComponents: .date)
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
                        Text("Durata Massima:")
                        
                        Text(String(filter.maxDuration))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.yellow)
                            .contentTransition(.numericText())
                        
                        Text("ore")
                    }
                }
                .tint(.yellow)
                
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
                
                Toggle(isOn: $filter.isCarNeededSelected, label: {
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
                
                Toggle(isOn: $filter.isHeavyTaskSelected, label: {
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
                
                Button(
                    role: .destructive, 
                    action: {
                        filter.reset()
                    }, label: {
                        Label(
                            title: {
                                Text("Reset") 
                            },
                            icon: { 
                                Image(systemName: "arrow.counterclockwise")
                            }
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    })
                .buttonStyle(BorderedProminentButtonStyle())
                .buttonBorderShape(.capsule)
                .tint(.red)
                .hoverEffect(.lift)
                .shadow(radius: 10)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 24)
        }
        .frame(width: screenWidth > 500 ? 360 : screenWidth - 40, alignment: .top)
        .frame(maxHeight: screenHeight - 80)
        .onAppear {
            internalMaxDuration = filter.maxDuration
            
            if (
                filter.startingDate.isTime(hour: 0, minute: 0) &&
                filter.endingDate.isTime(hour: 23, minute: 59)
            ) {
                isAllDaySelected = true
            }
        }
        .onChange(of: internalMaxDuration) {_, _ in
            withAnimation {
                filter.maxDuration = internalMaxDuration
            }    
        }
        .onChange(of: isAllDaySelected) { old, new in
            if new {
                // Is All Day
                filter.setTime(of: [.startingTime], hour: 0, minute: 0, second: 0)
                filter.setTime(of: [.endingTime], hour: 23, minute: 59, second: 59)
                
                withAnimation {
                    showTimePickers = true
                }
            } else {
                // Not All Day
                filter.startingDate = .now
                filter.endingDate = .now.addingTimeInterval(3600)
                
                withAnimation {
                    showTimePickers = false
                }
            }
        }
        .sensoryFeedback(.levelChange, trigger: internalMaxDuration)
        .sensoryFeedback(.levelChange, trigger: filter.selectedCategories)
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
