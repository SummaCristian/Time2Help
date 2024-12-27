import SwiftUI

@main
struct AppTime2Help2App: App {
    
    @AppStorage("showlogin") var showLogin: Bool = true
    @AppStorage("nameSurname") var nameSurname: String = ""
    @AppStorage("selectedColor") var selectedColor: String = "blue"
    @AppStorage("selectedNeighbourhood") var selectedNeighbourhood: String = "Duomo"
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    
    @StateObject private var viewModel = MapViewModel()
    
    var body: some Scene {
        WindowGroup {
            if showLogin {
                LoginView(showLogin: $showLogin, isSatelliteMode: $isSatelliteMode, viewModel: viewModel, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
            } else {
                ContentView(isSatelliteMode: $isSatelliteMode, viewModel: viewModel, nameSurname: $nameSurname, selectedColor: $selectedColor, selectedNeighbourhood: $selectedNeighbourhood)
            }
        }
    }
}
