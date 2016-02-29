import UIKit

extension UIColor {
	convenience init (hex: Int) {
		self.init(hex:hex, alpha: 1.0)
	}
	
	convenience init (hex: Int, alpha: CGFloat) {
		self.init(
			red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0,
			green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0,
			blue: (CGFloat(hex & 0xFF)) / 255.0,
			alpha: alpha)
	}
	
  
}