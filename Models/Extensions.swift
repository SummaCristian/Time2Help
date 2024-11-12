//
//  Extensions.swift
//  AppTime2Help2
//
//  Created by Mattia Di Nardo on 12/11/24.
//

import SwiftUI

extension Color {
    func toString() -> String {
        switch self {
        case Color(.systemBlue):
            return "blue"
        case Color(.systemBrown):
            return "brown"
        case Color(.systemCyan):
            return "cyan"
        case Color(.systemGreen):
            return "green"
        case Color(.systemIndigo):
            return "indigo"
        case Color(.systemMint):
            return "mint"
        case Color(.systemOrange):
            return "orange"
        case Color(.systemPink):
            return "pink"
        case Color(.systemPurple):
            return "purple"
        case Color(.systemRed):
            return "red"
        case Color(.systemTeal):
            return "teal"
        case Color(.systemYellow):
            return "yellow"
        default:
            return "primary"
        }
    }
}

extension String {
    func toColor() -> Color {
        switch self {
        case "blue":
            return Color(.systemBlue)
        case "brown":
            return Color(.systemBrown)
        case "cyan":
            return Color(.systemCyan)
        case "green":
            return Color(.systemGreen)
        case "indigo":
            return Color(.systemIndigo)
        case "mint":
            return Color(.systemMint)
        case "orange":
            return Color(.systemOrange)
        case "pink":
            return Color(.systemPink)
        case "purple":
            return Color(.systemPurple)
        case "red":
            return Color(.systemRed)
        case "teal":
            return Color(.systemTeal)
        case "yellow":
            return Color(.systemYellow)
        default:
            return .primary
        }
    }
}
