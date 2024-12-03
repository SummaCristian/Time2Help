import SwiftUI

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        let points = (0..<6).map { i in
            let angle = Angle(degrees: Double(i) * 60).radians
            return CGPoint(
                x: centerX + CGFloat(cos(angle)) * width / 2,
                y: centerY + CGFloat(sin(angle)) * height / 2
            )
        }
        
        var path = Path()
        path.move(to: points.first!)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        
        return path
    }
}

struct Rhombus: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        let points = (0..<4).map { i in
            let angle = Angle(degrees: Double(i) * 90).radians
            return CGPoint(
                x: centerX + CGFloat(cos(angle)) * width / 2,
                y: centerY + CGFloat(sin(angle)) * height / 2
            )
        }
        
        var path = Path()
        path.move(to: points.first!)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        
        return path
    }
}

struct Octagon: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.size.width
        let height = rect.size.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        let points = (0..<8).map { i in
            let angle = Angle(degrees: Double(i) * 45).radians
            return CGPoint(
                x: centerX + CGFloat(cos(angle)) * width / 2,
                y: centerY + CGFloat(sin(angle)) * height / 2
            )
        }
        
        var path = Path()
        path.move(to: points.first!)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    VStack(spacing: 30) {
        Hexagon()
            .frame(width: 50, height: 50)
            .rotationEffect(Angle(degrees: 30))
        
        Rhombus()
        .frame(width: 50, height: 50)
        
        Octagon()
            .frame(width: 50, height: 50)
    }
}

