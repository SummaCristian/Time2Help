import SwiftUI

struct AcceptedFavorsView: View {
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
    
    @Binding var showInteractedFavorOverlay: Bool
    @Binding var lastFavorInteracted: Favor?
    @Binding var lastInteraction: FavorInteraction?
    
    
    var body: some View {
        NavigationStack {
            List {
                // Accepted Favors
                Section(
                    content: {
                        // Favors
                        if (database.favors.filter({ $0.helpers.contains(where: { $0.id == user.id }) }).count) == 0 {
                            Text("Nessun Favore accettato ...")
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)) {
                                ForEach(database.favors.filter({ $0.helpers.contains(where: { $0.id == user.id }) })) { favor in
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
                        Text("Favori presi in carico")
                    },
                    footer: {
                        Text("Controlla i Favori che hai accettato di svolgere")
                            .safeAreaPadding(.bottom, 40)
                    }
                )
            }
        }
        .navigationTitle("Favori accettati")
        .navigationDestination(item: $selectedFavor) { favor in
            FavorDetailsSheet(viewModel: viewModel, database: database, selectedFavor: $selectedFavor, user: user, favor: favor, selectedReward: $selectedReward, rewardNameSpace: rewardNameSpace, showInteractedFavorOverlay: $showInteractedFavorOverlay, lastFavorInteracted: $lastFavorInteracted, lastInteraction: $lastInteraction)
        }
    }
}
