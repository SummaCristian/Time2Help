import SwiftUI

// This file contains the UI for the New Favor sheet.

struct NewFavorSheet: View {
    var body: some View {
        VStack {
            Text("Nuovo Favore")
                .font(.title)
                .padding()
            
            // Add more form fields or content here
            Text("Here you can create a new favor")
                .padding()
            
            Spacer()
        }
        .presentationDetents([.medium, .large]) // Available on iOS 16+ for adjusting sheet size
    }
}
