import SwiftUI

struct FaqScreen: View {
    
    let isInExplanationView: Bool
    @Binding var showExplanationTemp: Bool
    
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // Guided tour
                Button {
                    withAnimation {
                        showExplanationTemp = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "figure.wave")
                        
                        Text("Tour")
                    }
                    .font(.subheadline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .background {
                        if isInExplanationView {
                            Capsule()
                                .foregroundStyle(.gray.gradient)
                        } else {
                            Capsule()
                                .foregroundStyle(.blue.gradient)
                        }
                    }
                }
                .disabled(isInExplanationView)
            }
        }
    }
}

#Preview {
//    FaqScreen(showExplanationTemp: .constant(false))
}
