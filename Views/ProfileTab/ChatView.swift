import SwiftUI

enum MessageAuthor {
    case personal
    case other
}

struct DayStruct: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var messages: [MessageStruct]
}

struct MessageStruct: Identifiable {
    var id: UUID = UUID()
    var text: String
    var date: Date
    var author: MessageAuthor
}

struct ChatView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var other: User
    @Binding var showChat: Bool
    
    @State private var message: String = ""
    
    @State private var days: [DayStruct] = []
    
    @FocusState private var textfieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        ForEach(days) { day in
                            Section {
                                ForEach(day.messages) { message in
                                    HStack {
                                        if message.author == .personal {
                                            Spacer()
                                        }
    
                                        HStack(alignment: .bottom, spacing: 12) {
                                            Text(message.text)
    
                                            Text(getHourMinute(date: message.date))
                                                .font(.footnote)
                                                .foregroundStyle(.gray)
                                                .offset(y: 8)
                                        }
                                        .padding(.all, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(message.author == .personal ? .blue : colorScheme == .dark ? .black : .white)
                                                .opacity(message.author == .personal && colorScheme == .light ? 0.15 : 0.25)
                                                .shadow(color: .gray.opacity(0.4), radius: 8)
                                        }
                                        .frame(maxWidth: .infinity, alignment: message.author == .personal ? .trailing : .leading)
                                        .frame(maxWidth: 270)
                                        .padding(.all, 4)
    
                                        if message.author == .other {
                                            Spacer()
                                        }
                                    }
                                }
                            } header: {
                                Text(getDayHeader(date: day.date))
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(.background, in: .rect(cornerRadius: 12))
                                    .padding(.top, 12)
                                    .padding(.bottom, 8)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
                .defaultScrollAnchor(.bottom)
                .scrollDismissesKeyboard(.immediately)
                .frame(maxWidth: .infinity, alignment: .bottom)
                .safeAreaPadding(.bottom, 50)
                .background {
                    Rectangle()
                        .foregroundStyle(.regularMaterial)
                        .background {
                            ZStack {
                                Rectangle()
                                    .fill(.primary.opacity(0.1))
                            }
                        }
                        .overlay {
                            LinearGradient(colors: [other.profilePictureColor.toColor()!.opacity(0.9), other.profilePictureColor.toColor()!.opacity(0.6), other.profilePictureColor.toColor()!.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .opacity(0.8)
                                .blur(radius: 100)
                        }
                }
//                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            TextField(text: $message) {
                                Text("Scrivi un messaggio")
                            }
                            .focused($textfieldFocused)
                            
                            if !message.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.red, .red.opacity(0.2))
                                    .onTapGesture {
                                        message = ""
                                    }
                            }
                        }
                        .padding(.vertical, 6)
                        .padding(.leading, 16)
                        .padding(.trailing, 12)
                        .background(colorScheme == .dark ? Color(.systemGray5) : .white, in: .capsule)
                        .background(.gray.opacity(0.4), in: .capsule.stroke(lineWidth: 1))
                        
                        
                        Button {
                            withAnimation {
                                days[days.count - 1].messages.append(MessageStruct(text: message, date: .now, author: .personal))
                                message = ""
                            }
                        } label: {
                            Image(systemName: "arrow.up")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .frame(width: 35, height: 35)
                        }
                        .disabled(message.isEmpty)
                        .background(
                            Circle()
                                .foregroundStyle(message.isEmpty ? .gray : .blue)
                        )
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 12)
                    .frame(height: 50)
                    .background(Color(.systemGray6))
                }
            }
            .presentationDragIndicator(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Esci", role: .cancel) {
                        showChat = false
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(other.nameSurname)
                            .font(.headline)
                    }
                }
            }
        }
        .onAppear {
            days.append(DayStruct(date: .now.addingTimeInterval(-522000), messages: [
                MessageStruct(text: "Ciao, ti contatto per aiutarti con il trasloco! Tra una settimana giusto?", date: .now.addingTimeInterval(-522000), author: .other),
                MessageStruct(text: "Sì esatto😊", date: .now.addingTimeInterval(-521700), author: .personal),
                MessageStruct(text: "Ci troviamo in Via Alessandro Manzoni 3 alle 11", date: .now.addingTimeInterval(-521640), author: .personal),
                MessageStruct(text: "👍🏻", date: .now.addingTimeInterval(-521640), author: .other)
            ]))
            days.append(DayStruct(date: .now.addingTimeInterval(-180), messages: [
                MessageStruct(text: "Ciao, quindi va bene domani per le 11? Anche 12, come preferisci😊", date: .now.addingTimeInterval(-180), author: .other)
            ]))
        }
    }
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
//        df.dateFormat = "ddd, d mmm"

        df.dateStyle = .short
        df.timeStyle = .none
        df.doesRelativeDateFormatting = true

        return df
    }
    
    func getDayHeader(date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Ieri"
        } else if Calendar.current.isDateInToday(date) {
            return "Oggi"
        } else {
            let dateFormatted = DateFormatter()
            dateFormatted.dateFormat = "E, d MMM"

            return dateFormatted.string(from: date)
        }
    }
    
    func getHourMinute(date: Date) -> String {
        return date.formatted(date: .omitted, time: .shortened)
    }
}
