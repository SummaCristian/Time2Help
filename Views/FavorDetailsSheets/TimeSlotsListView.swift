import SwiftUI

struct TimeSlotsList: View {
    @Binding var slots: [TimeSlot]
    
    var isEditable: Bool = true
    
    @State var tint: Color = .accentColor
    
    var days: [Date] {
        return extractDays()
    }
    
    var body: some View {
        if isEditable {
            List {
                ForEach($slots) { slot in
                    HStack {
                        DatePicker("", selection: slot.startingDate, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        
                        Image(systemName: "arrow.right")
                            .bold()
                        
                        DatePicker("", selection: slot.endingDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        
                        
                        if slots.count > 1 {
                            Image(systemName: "line.horizontal.3")
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(5)
                    .deleteDisabled(slots.count == 1)
                }
                .onDelete(perform: { indexSet in
                    slots.remove(atOffsets: indexSet)
                })
                .onMove(perform: { indices, newOffset in
                    slots.move(fromOffsets: indices, toOffset: newOffset)
                })
                
                // Last button
                HStack{
                    Spacer()
                    
                    Button(
                        action: {
                            withAnimation {
                                slots.append(TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600)))
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                    .bold()
                                
                                Text("Aggiungi fascia")
                                    .bold()
                            }
                        }
                    )
                    //.tint(tint)
                    .buttonStyle(BorderedButtonStyle())
                    .buttonBorderShape(.capsule)
                    .padding(.vertical, 6)
                }
            }
        } else {
                // View only variant
                List {
                    // The unique days in which there exists a TimeSlot.
                    // Each day will have its own Row, which is why we need to extract them
//                    let days: [Date] = extractDays()
                    
                    ForEach(days, id: \.self) { day in
                        HStack {
                            // Day indication per-row
                            Text(day.formatted(date: .long, time: .omitted))
                                .bold()
                                .foregroundStyle(tint)
                            
                            Spacer()
                            
                            // Time Slots
                            VStack {
                                let calendar = Calendar.current
                                let slotsInDay = slots.filter({ calendar.isDate($0.startingDate, inSameDayAs: day)})
                                
                                ForEach(slotsInDay) { slot in
                                    HStack {
                                        Text(slot.startingDate.formatted(date: .omitted, time: .shortened))
                                            .foregroundStyle(tint)
                                        
                                        Image(systemName: "arrow.right")
                                        
                                        Text(slot.endingDate.formatted(date: .omitted, time: .shortened))
                                            .foregroundStyle(tint)
                                    }
                                    .bold()
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
            
        }
    }
    
    // Extracts the unique Days in which there is a TimeSlot
    func extractDays() -> [Date] {
        var days: [Date] = []
        let calendar = Calendar.current
        
        for slot in slots {
            if !(days.contains(where: { calendar.isDate($0, inSameDayAs: slot.startingDate)})) {
                days.append(slot.startingDate)
            }
        }
        
        return days
    }
}

#Preview {
    VStack() {
        // Editable
        TimeSlotsList(slots: .constant(
            [TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600)),
             TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600)),
             TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600)),
             TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600))
            ]))
        
        // Non Editable
        TimeSlotsList(slots: .constant(
            [TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600)),
             TimeSlot(startingDate: Date().addingTimeInterval(36000), endingDate: Date().addingTimeInterval(36200)),
             TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600)),
             TimeSlot(startingDate: Date(), endingDate: Date().addingTimeInterval(3600))
            ]), isEditable: false)
    }
}
