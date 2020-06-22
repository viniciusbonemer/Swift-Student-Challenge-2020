import UIKit

extension UILayoutGuide {
    
    public var center: CGPoint {
        CGPoint(x: self.layoutFrame.midX, y: self.layoutFrame.midY)
    }
    
}
