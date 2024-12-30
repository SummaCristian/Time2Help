import SwiftUI

struct FaqScreen: View {
    var body: some View {
        Form {
            HStack {
                Spacer()
                
                Image(systemName: "questionmark.bubble.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.secondary)
                    .shadow(radius: 10)
                
                Spacer()
            }
                .listRowBackground(Color.clear)
            
            Section(
                content: {
                    List {
                        ForEach(FAQs.allCases) { faq in
                            faqView(faq: faq.faq)
                        }
                    }
                }, header: {
                    Text("Domande chieste frequentemente (FAQ)")
                }
            )
        }
        .navigationTitle("Domande")
    }
}

#Preview {
    FaqScreen()
}
