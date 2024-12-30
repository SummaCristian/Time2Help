import SwiftUI

enum FAQImagePosition {
    case trailing
    case bottom
}

struct FAQ {
    let icon: String
    let color: Color
    let question: String
    let answer: String
    let body: AnyView?
    let imagePosition: FAQImagePosition
    
    init(
        icon: String = "star.fill",
        color: Color = .gray,
        question: String,
        answer: String,
        imagePosition: FAQImagePosition = .bottom,
        @ViewBuilder body: () -> some View
    ) {
        self.icon = icon
        self.color = color
        self.question = question
        self.answer = answer
        self.imagePosition = imagePosition
        self.body = AnyView(body())
    }
    
    init(
        icon: String,
        color: Color,
        question: String,
        answer: String,
        imagePosition: FAQImagePosition = .bottom
    ) {
        self.icon = icon
        self.color = color
        self.question = question
        self.answer = answer
        self.imagePosition = imagePosition
        self.body = nil
    }
}

struct faqView: View {
    let faq: FAQ
    
    var body: some View {
        DisclosureGroup(
            content: {
                VStack {
                    HStack {
                        Text(faq.answer)
                            .font(.callout)
                        
                        Spacer()
                        
                        if faq.imagePosition == .trailing {
                            faq.body
                        }
                    }
                    
                    if faq.imagePosition == .bottom {
                        faq.body
                    }
                }
            },
            label: {
            HStack {
                Image(systemName: faq.icon)
                    .foregroundStyle(faq.color)
                    .font(.title2.bold())
                
                Text(faq.question)
                    .font(.title3.bold())
                    .foregroundStyle(Color.primary)
                
            }
        })
    }
}

#Preview {
    VStack {
        faqView(
            faq: FAQ(icon: "star.fill", color: .yellow, question: "What is a FAQ?", answer: "This is a FAQ", imagePosition: .trailing) {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 100, height: 100)
            }
        )
        
        faqView(
            faq: FAQ(icon: "star.fill", color: .yellow, question: "What is a FAQ?", answer: "This is a FAQ", imagePosition: .bottom ) {
                Rectangle()
                    .fill(.blue)
                    .frame(height: 200)
            }
        )
    }
}
