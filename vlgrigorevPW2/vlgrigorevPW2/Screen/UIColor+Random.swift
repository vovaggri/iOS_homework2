import UIKit

extension UIColor {
    func random() -> UIColor {
        return UIColor(
            displayP3Red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
}

