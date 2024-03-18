/*
 See LICENSE folder for this sample’s licensing information.
 */

import SwiftUI

enum Theme: String {

    case mybubblegum
    case mybuttercup
    case myindigo
    case mylavender
    case mymagenta
    case mynavy
    case myorange
    case myoxblood
    case myperiwinkle
    case mypoppy
    case mypurple
    case myseafoam
    case mysky
    case mytan
    case myteal
    case myyellow

    var accentColor: Color {
        switch self {
            case .mybubblegum, .mybuttercup, .mylavender, .myorange, .myperiwinkle, .mypoppy,
                .myseafoam, .mysky,
                .mytan, .myteal, .myyellow:
                return .black
            case .myindigo, .mymagenta, .mynavy, .myoxblood, .mypurple: return .white
        }
    }

    var mainColor: Color {
        Color(rawValue)
    }

    static subscript(n: Int) -> Theme {  //Theme[2]
        let index = n % 16
        switch index {
            case 0: return .mybubblegum
            case 1: return .mybuttercup
            case 2: return .myindigo
            case 3: return .mylavender
            case 4: return .mymagenta
            case 5: return .mynavy
            case 6: return .myorange
            case 7: return .myoxblood
            case 8: return .myperiwinkle
            case 9: return .mypoppy
            case 10: return .mypurple
            case 11: return .myseafoam
            case 12: return .mysky
            case 13: return .mytan
            case 14: return .myteal
            case 15: return .myyellow
            default: return .mybubblegum
        }
    }
}
