import UIKit

extension String {
    
    func hexToColor() -> UIColor {
        let hexString = self.first == "#" ? String(self.dropFirst()) : self
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            let b = CGFloat((hexNumber & 0x0000ff)) / 255
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        } else {
            return UIColor(red: 255, green: 0, blue: 255, alpha: 1)
        }
    }
}
