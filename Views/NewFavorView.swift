import SwiftUI

// This file contains the UI for the New Favor sheet.


struct NewFavorSheet: View {    
    @State private var isPresented = false
    @State var selectedDetent: PresentationDetent = .large
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(role: .cancel, action: {}, label: {
                    Text("Annulla")
                        .foregroundStyle(.red)
                })
                .padding(20)
                Spacer()
            }
            
            HStack {
                Text("Richiedi un nuovo Favore")
                    .font(.headline)
                    .padding()
                
                Spacer()
                HStack {
                    Image(systemName: "arrowtriangle.down.circle")
                    ZStack {
                        Circle()
                            .foregroundStyle(.orange)
                            .frame(width: 40, height: 40)
                            .shadow(radius: 3)
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(.white)
                            .scaledToFit()
                            .frame(width: 20, height: 20)                        
                    }
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(Rectangle())
                .cornerRadius(5)
                
            }
            .padding(10)
            .onTapGesture(perform: {
                isPresented = true
            })
            
            VStack(spacing: 0) {
                TextField("Titolo", text: .constant(""))
                    .padding(12)
                    .font(.body)
                    .padding(.horizontal)
                    .background(Color(.secondarySystemBackground))
                    .textInputAutocapitalization(.sentences)
                
                Divider()
                
                TextField("Descrizione", text: .constant(""))
                    .padding(12)
                    .font(.body)
                    .padding(.horizontal)
                    .background(Color(.secondarySystemBackground))           
                    .textInputAutocapitalization(.sentences)
            }
            .cornerRadius(8)
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            VStack(spacing: 0) {
                HStack {
                    Toggle(isOn: .constant(false), label: {
                        Text("Tutto il giorno")
                    })
                    .padding(5)
                    .padding(.horizontal)
                }
                .background(Color(.secondarySystemBackground))
                
                Divider()
                
                HStack {
                    DatePicker("Inizio", selection: .constant(Date()),displayedComponents: [.date, .hourAndMinute])
                        .padding(5)
                        .padding(.horizontal)
                }
                .background(Color(.secondarySystemBackground))
                
                Divider()
                
                HStack {
                    DatePicker("Fine", selection: .constant(Date().addingTimeInterval(3600)),displayedComponents: [.date, .hourAndMinute])
                        .padding(5)
                        .padding(.horizontal)
                }
                .background(Color(.secondarySystemBackground))
            }
            .cornerRadius(8)
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
            
            VStack(spacing: 0) {
                Toggle(isOn: .constant(false), label: {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color(.systemRed))
                            Image(systemName: "car.fill")
                                .foregroundStyle(Color(.white))
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                        }
                        .cornerRadius(3)
                        
                        Text("Auto Necessaria")
                    }
                })
                .padding(5)
                .padding(.horizontal)
                .tint(.green)
                
                Divider()
                
                Toggle(isOn: .constant(true), label: {
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color(.systemGreen))
                            Image(systemName: "hammer.fill")
                                .foregroundStyle(Color(.white))
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                        }
                        .cornerRadius(3)
                        
                        Text("Faticoso")
                    }
                })
                .padding(5)
                .padding(.horizontal)
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
            .tint(.green)
            
            Spacer().frame(height: 20)
            
            HStack {
                Text("Luogo")
                    .padding(12)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    // Your action here
                } label: {
                    Label("Scegli", systemImage: "pin.fill")
                        .foregroundColor(.white) // Set the text color to white
                        .padding(8) // Add some padding to the button
                        .background(Color.green) // Set the background color to green
                        .cornerRadius(8) // Add corner radius for rounded corners
                }
                
                Spacer().frame(width: 10)
                
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal)
            
            Spacer()
        }
        .sheet(isPresented: $isPresented, content: {
            NewFavorIconSheet()
        })
        .presentationDetents([.large], selection: $selectedDetent)
        .presentationDragIndicator(.visible)
    }
}
