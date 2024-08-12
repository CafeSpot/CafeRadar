import Foundation
import SwiftUI

// color
struct CafeColor{
    static let basicColor: Color = Color(hex: 0x6A3A26)
    static let basicColor_fade: Color = Color(UIColor(red: 0x8b / 255, green: 0x45 / 255, blue: 0x13 / 255, alpha: 0.5))
    static let basicColor_background: Color = Color(hex: 0xF3BD75)
}

extension Color{
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
