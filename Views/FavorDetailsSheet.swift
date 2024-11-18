import SwiftUI
import MapKit

// This file contains the UI for the Favor's Details sheet, that appears when clicking on an existing Favor

struct FavorDetailsSheet: View {
    // Used to control the dismissal from inside the sheet
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var database: Database
    @Binding var selectedFavor: Favor?
    @State var user: User
    
    // The Favor whose details are being showed
    @State var favor: Favor
    
    @State private var isAuthorProfileSheetPresented = false
    @State private var isHelperProfileSheetPresented = false
        
    // The UI
    var body: some View {
        // The GeometryReader is used to achieve a top alignment for the UI
        GeometryReader { _ in
            // The ScrollView is needed to be able to scroll through the UI
             List {
                Section {
                    HStack {
                        // The Favor's Title
                        VStack(alignment: .leading, spacing: 10) {
                            Text(favor.title)
                                .font(.title)
                                .fontWeight(.black)
                            
                            HStack(spacing: 5) {
                                ProfileIconView(username: favor.author.$nameSurname, color: favor.author.$profilePictureColor, size: .small)
                                
                                // The Favor's Author's Name
                                Text(favor.author.nameSurname)
                                    .fontWidth(.compressed)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                            }
                            .padding(.vertical, 7)
                            .padding(.leading, 8)
                            .padding(.trailing, 11)
                            .foregroundStyle(.primary)
                            .background(
                                Capsule()
                                    .foregroundStyle(favor.author.profilePictureColor.toColor()!.opacity(0.2))
                            )
                            .hoverEffect(.lift)
                            .onTapGesture {
                                isAuthorProfileSheetPresented = true
                            }
                        }
                        
                        Spacer()
                        
                        FavorMarker(favor: favor, isSelected: .constant(true), isInFavorSheet: true)
                            .offset(x: -5, y: 45)
                            .frame(width: 100, height: 120)
                    }
                    .cornerRadius(10)
                }
                .listRowBackground(Color.clear)
                 
                 // The User who accepted it
                 if favor.helper != nil {
                     Section(
                        content: {
                            HStack(spacing: 5) {
                                ProfileIconView(username: favor.helper?.$nameSurname ?? .constant("Null"), color: favor.helper?.$profilePictureColor ?? .constant("blue"), size: .small)
                                
                                // The Favor's Author's Name
                                Text(favor.helper?.nameSurname ?? "Null")
                                    .fontWidth(.compressed)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                            }
                            .padding(.vertical, 7)
                            .padding(.leading, 8)
                            .padding(.trailing, 11)
                            .foregroundStyle(.primary)
                            .background(
                                Capsule()
                                    .foregroundStyle(favor.helper!.profilePictureColor.toColor()!.opacity(0.2))
                            )
                            .hoverEffect(.lift)
                            .onTapGesture {
                                if favor.helper?.id != user.id {
                                    isHelperProfileSheetPresented = true
                                }
                            }
                        },
                        header: {
                            Text("Accettato da")
                        }
                     )
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
                
                Section(
                    content: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Stato")
                                    .font(.title2)
                                    .bold()
                                Text(favor.status.textualForm)
                            }
                            
                            Spacer()
                            
                            CircularProgressView(value: favor.status.progressPercentage, size: .large, numberColor: favor.color, progressColor: favor.color)
                        }
                    },
                    header: {
                        Text("Stato di avanzamento")
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
                                .foregroundStyle(favor.color)
                        }
                        
                        HStack {
                            Text("Data di fine:")
                            Spacer()
                            Text(favor.endingDate.formatted(date: .long, time: .omitted))
                                .bold()
                                .foregroundStyle(favor.color)
                        }
                        
                        HStack {
                            Text("Ora:")
                            
                            Spacer()
                            
                            Text(favor.startingDate.formatted(date: .omitted, time: .shortened))
                                .bold()
                                .foregroundStyle(favor.color)
                            
                            Image(systemName: "arrow.right")
                            
                            Text(favor.endingDate.formatted(date: .omitted, time: .shortened))
                                .bold()
                                .foregroundStyle(favor.color)
                        }
                        
                        HStack {
                            Text("Durata:")
                            
                            Spacer()
                            
                            Text(calculateTime(favor: favor))
                                .bold()
                                .foregroundStyle(favor.color)
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
                                if favor.isCarNecessary {
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .foregroundStyle(.white)
                                            .bold()
                                        
                                        Text("Auto")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                    .frame(height: 50)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemRed).gradient)
                                    .cornerRadius(10)
                                }
                                
                                // Is Heavy Task
                                if favor.isHeavyTask {
                                    HStack {
                                        Image(systemName: "hammer.fill")
                                            .foregroundStyle(.white)
                                            .bold()
                                        
                                        Text("Faticoso")
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                    .frame(height: 50)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGreen).gradient)
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
                                FavorMarker(favor: favor, isSelected: .constant(true), isInFavorSheet: true)
                            })
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                    },
                    header: {
                        Text("POSIZIONE")
                    }
                )
                
                Text("") // To leave space for popup button
                    .frame(height: 0)
                    .listRowBackground(Color.clear)
                    .safeAreaPadding(.bottom, 34)
            }
            
            // The Accept Favor Button
            // it is outside the ScrollView, because it hovers on top of the rest of the UI.
            // This allows to have it always in the same spot, always accessible
            if favor.helper == nil && favor.author.id != user.id {
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Accepting the Favor
                            favor.helper = user
                            favor.status = .accepted
                            
                            dismiss()
                        }) {
                            Label("Accetta Favore", systemImage: "checkmark")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 45)
                                .background(.blue, in: .capsule)
                        }
                        .shadow(radius: 10)
                        .hoverEffect(.highlight)
                        
                        Spacer()
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .large])
        .sheet(isPresented: $isAuthorProfileSheetPresented, content: {
            ProfileView(database: database, selectedFavor: $selectedFavor, user: $favor.author)
        })
        /*.sheet(isPresented: $isHelperProfileSheetPresented, content: {
            ProfileView(database: database, selectedFavor: $selectedFavor, user: favor.$helper ?? nil)
        })*/
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
