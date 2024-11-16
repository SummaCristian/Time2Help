import SwiftUI

@main
struct AppTime2Help2App: App {
    
    @AppStorage("showlogin") var showLogin: Bool = true
    @AppStorage("nameSurname") var nameSurname: String = ""
    @AppStorage("selectedColor") var selectedColor: String = "blue"
    @AppStorage("selectedNeighbourhood") var selectedNeighbourhood: String = "Città Studi"
    
    var body: some Scene {
        WindowGroup {
            if showLogin {
                LoginView(showLogin: $showLogin, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
            } else {
                ContentView(nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
            }
        }
    }
}
