import SwiftUI

enum MultiProfileIconConfig {
    case box
    case markerBig
    case markerSmall
}

struct MultiProfileIconView: View {
    @Binding var config: MultiProfileIconConfig
    @Binding var users: [User]
        

    var body: some View {
        let count = users.count
        
        ZStack {                
            if count > 1 {
                if count > 2 {
                    // Icon 3
                    ProfileIconView(
                        username: users[2].$nameSurname,
                        color: users[2].$profilePictureColor,
                        size: .small
                    )
                    .scaleEffect(config == .box ? 0.6 : config == .markerBig ? 0.8 : 0.6)
                    .offset(
                        x: config == .box ? -4 : config == .markerBig ? 18 : 14,
                        y: config == .box ? 12 : config == .markerBig ? 24 : 18
                    )
                }
                
                // Icon 2
                ProfileIconView(
                    username: users[1].$nameSurname,
                    color: users[1].$profilePictureColor,
                    size: .small
                )
                .scaleEffect(config == .box ? 0.75 : config == .markerBig ? 0.8 : 0.6)
                .offset(
                    x: config == .box ? 8 : config == .markerBig ? 6 : 6, 
                    y: config == .box ? 8 : config == .markerBig ? 22 : 14
                )
            }
            
            // Icon 1
            ProfileIconView(
                username: users[0].$nameSurname,
                color: users[0].$profilePictureColor,
                size: .small
            )
            .scaleEffect(config == .box ? (count == 1 ? 1 : 0.9) : config == .markerBig ? (count == 1 ? 1 : 0.8) : (count == 1 ? 0.8 : 0.6))
            .offset(
                x: config == .box ? (count == 1 ? 0 : -5) : config == .markerBig ? (count == 1 ? 16 : 14) : (count == 1 ? 12 : 10), 
                y: config == .box ? (count == 1 ? 0 : -2) : config == .markerBig ? (count == 1 ? 16 : 14) : (count == 1 ? 12 : 8)
            )
            
            if count > 3 {
                // Icon +N
                Text("+" + String(count - 3))
                    .font(.caption2.bold())
                    .background {
                        Circle()
                            .fill(.thinMaterial)
                            .frame(width: 20, height: 20)
                    }
                    .offset(
                        x: config == .box ? 12 : config == .markerBig ? 24 : 22, 
                        y: config == .box ? -10 : config == .markerBig ? 8 : 6)
                    .scaleEffect(config == .markerSmall ? 0.8 : 1)
            }
        }
        .frame(width: 50, height: 50)

        // Debug
//        .background {
//            if config == .box {
//                Rectangle()
//                    .frame(width: 50, height: 50)
//            } else {
//                Circle()
//                    .frame(width: config == .markerBig ? 50 : 30)
//            }
//        }
    }
}

#Preview {
    HStack(spacing: 100) {
        // Box
        VStack(spacing: 100) {
            Text("Box")
            MultiProfileIconView(
                config: .constant(.box),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.box),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.box),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.box),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")),
                    User(nameSurname: .constant("Giorgio Bianchi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("brown")),
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.box),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")),
                    User(nameSurname: .constant("Giorgio Bianchi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("brown")),
                    User(nameSurname: .constant("Giovanna Gialli"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("yellow"))
                ])
            )
        }
        
        // Marker Big
        VStack(spacing: 100) {
            Text("Marker Big")
            
            MultiProfileIconView(
                config: .constant(.markerBig),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerBig),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerBig),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerBig),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")),
                    User(nameSurname: .constant("Giorgio Bianchi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("brown")),
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerBig),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")),
                    User(nameSurname: .constant("Giorgio Bianchi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("brown")),
                    User(nameSurname: .constant("Giovanna Gialli"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("yellow"))
                ])
            )
        }
        
        // Marker Small
        VStack(spacing: 100) {
            Text("Marker Small")
            
            MultiProfileIconView(
                config: .constant(.markerSmall),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerSmall),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerSmall),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue"))
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerSmall),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")),
                    User(nameSurname: .constant("Giorgio Bianchi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("brown")),
                ])
            )
            
            MultiProfileIconView(
                config: .constant(.markerSmall),
                users: .constant([
                    User(nameSurname: .constant("Mario Rossi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("red")),
                    User(nameSurname: .constant("Giuseppe Verdi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("green")),
                    User(nameSurname: .constant("Sara Russo"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("blue")),
                    User(nameSurname: .constant("Giorgio Bianchi"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("brown")),
                    User(nameSurname: .constant("Giovanna Gialli"), neighbourhood: .constant("Duomo"), profilePictureColor: .constant("yellow"))
                ])
            )
        }
    }
}
