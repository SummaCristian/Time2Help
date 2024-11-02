import SwiftUI
import MapKit

// This file contains the UI for the Favor's Details sheet, that appears when clicking on an existing Favor

struct FavorDetailsSheet: View {
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss

    // The Favor whose details are being showed
    @State var favor: Favor
    
    // The UI
    var body: some View {
        // The GeometryReader is used to achieve a top alignment for the UI
        GeometryReader { _ in
            // The ScrollView is needed to be able to scroll through the UI
            Form {
                Section() {
                    HStack {
                        // The Favor's Title
                        VStack {
                            Text(favor.title)
                                .font(.largeTitle)
                                .bold()
                            
                            // The Favor's Author's Name
                            Text(favor.author)
                                .fontWidth(.compressed)
                                .font(.system(size: 10))
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        // The Favor's Reward                        
                        CreditNumberView(favor: favor)
                    }
                    .padding()
                    .cornerRadius(10)
                }
                
                // The Favor's Description
                Section(
                    content: {
                        Text(favor.description)
                    }, 
                    header: {
                        Text("DESCRIZIONE")
                    }
                )
                
                // The Favor's Date data
                Section(
                    content: {
                        HStack {
                            Text("Data di inizio:")
                            Spacer()
                            Text(favor.startingDate.formatted(date: .long, time: .omitted))
                                .bold()
                                .foregroundStyle(favor.color.color)
                        }
                        
                        HStack {
                            Text("Data di fine:")
                            Spacer()
                            Text(favor.endingDate.formatted(date: .long, time: .omitted))
                                .bold()
                                .foregroundStyle(favor.color.color)
                        }
                        
                        HStack {
                            Text("Ora:")
                            
                            Spacer()
                            
                            Text(favor.startingDate.formatted(date: .omitted, time: .shortened))
                                .bold()
                                .foregroundStyle(favor.color.color)
                            
                            Image(systemName: "arrow.right")
                            
                            Text(favor.endingDate.formatted(date: .omitted, time: .shortened))
                                .bold()
                                .foregroundStyle(favor.color.color)
                        }
                        
                        HStack {
                            Text("Durata:")
                            
                            Spacer()
                            
                            Text(calculateTime(favor: favor))
                                .bold()
                                .foregroundStyle(favor.color.color)
                        }
                    },
                    header: {
                        Text("DATA E ORA")
                    }
                )
                
                // The Additional Infos (only shown if needed)
                if favor.isCarNecessary || favor.isHeavyTask {
                    Section(
                        content: {
                            // Is Car Necessary
                            HStack() {
                                if favor.isCarNecessary{
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .foregroundStyle(.white)
                                            .bold()
                                        
                                        Text("Auto necessaria")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                    .padding()
                                    .background(Color(.systemRed))
                                    .cornerRadius(10)
                                }
                                
                                // Is Heavy Task
                                if favor.isHeavyTask{
                                    HStack {
                                        Image(systemName: "hammer.fill")
                                            .foregroundStyle(.white)
                                            .bold()
                                        
                                        Text("Faticoso")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                    .padding()
                                    .background(Color(.systemGreen))
                                    .cornerRadius(10)
                                }
                            }
                        }, 
                        header: {
                            Text("INFO")
                        })
                }
                
                // The Favor's Location
                Section(
                    content: {
                        // A Map to show a preview of the Location
                        Map(
                            bounds: MapCameraBounds(minimumDistance: 500, maximumDistance: 500),
                            interactionModes: [] // No interactions allowed
                        ) {
                            Annotation("", coordinate: favor.location, content: {
                                // Only this Favor is shown in this mini-Map
                                FavorMarker(favor: favor, isSelected: .constant(true))
                            })
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                    },
                    header: {
                        Text("POSIZIONE")
                    }
                )
            }
            
            // The Accept Favor Button
            // it is outside the ScrollView, because it hovers on top of the rest of the UI.
            // This allows to have it always in the same spot, always accessible
            VStack{
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // TODO: Accept Favor
                        dismiss()
                    }) {
                        Label("Accetta Favore", systemImage: "checkmark")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.blue)
                    .shadow(radius: 10)
                    .hoverEffect(.highlight)
                    
                    Spacer()
                }
            }
            .padding()
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium, .large])
        }
    }
}

// Extension of Color, used to define colors using hex
extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) % 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double((hex & 0xFF)) / 255.0,
            opacity: alpha
        )
    }
}

// Function that calculates the time duration of a Favor, and returns it as a String,
// that is then used to display that information inside the UI.
func calculateTime(favor: Favor) -> String {
    let timeInterval = favor.endingDate.timeIntervalSince(favor.startingDate)
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    formatter.allowedUnits = [.day, .hour, .minute]
    
    return formatter.string(from: timeInterval)!
}
