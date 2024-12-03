import SwiftUI

struct RequestedFavorsView: View {
    @ObservedObject var viewModel: MapViewModel
    
    // The Database, where the Favors are stored
    @ObservedObject var database: Database
    
    @Binding var user: User
    
    // An Optional<Favor> used as a selector for a Favor:
    // nil => no Favor selected
    // *something* => that Favor is selected
    @State var selectedFavor: Favor? = nil
    
    @Binding var selectedReward: Reward?
    var rewardNameSpace: Namespace.ID
    
    
    var body: some View {
        NavigationStack {
            List {
                // Requested Favors
                Section(
                    content: {
                        // Favors
                        if (database.favors.filter({ $0.author.id == user.id }).count) == 0 {
                            Text("Nessun Favore richiesto ...")
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)) {
                                ForEach(database.favors.filter({ $0.author.id == user.id })) { favor in
                                    FavorBoxView(favor: favor)
                                        .onTapGesture {
                                            selectedFavor = favor
                                        }
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    },
                    header: {
                        Text("I tuoi favori")
                    },
                    footer: {
                        Text("Monitora lo stato dei Favori che hai richiesto")
                            .safeAreaPadding(.bottom, 40)
                    }
                )
            }
        }
        .navigationTitle("I tuoi Favori")
        .navigationDestination(item: $selectedFavor) { favor in
            FavorDetailsSheet(viewModel: viewModel, database: database, selectedFavor: $selectedFavor, user: user, favor: favor, selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace)
        }
    }
}
