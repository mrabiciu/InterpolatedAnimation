//
//  Interpolated.swift
//  Animation
//
//  Created by Max on 12/15/16.
//  Copyright © 2016 Maxim Rabiciuc. All rights reserved.
//

import Foundation
import UIKit

func interpolate<T: Interpolated>(from: T, to: T, percent: Double) -> T {
  return T.interpolated(from: from, to: to, percent: percent)
}

protocol Interpolated {
  static func interpolated(from: Self, to: Self, percent: Double) -> Self
}

extension CGRect: Interpolated {
  static func interpolated(from: CGRect, to: CGRect, percent: Double) -> CGRect {
    return CGRect(
      x: interpolate(from: from.origin.x, to: to.origin.x, percent: percent),
      y: interpolate(from: from.origin.y, to: to.origin.y, percent: percent),
      width: interpolate(from: from.size.width, to: to.size.width, percent: percent),
      height: interpolate(from: from.size.height, to: to.size.height, percent: percent)
    )
  }
}

extension CGAffineTransform: Interpolated {
  static func interpolated(from: CGAffineTransform, to: CGAffineTransform, percent: Double) -> CGAffineTransform {
    return CGAffineTransform(
      a: interpolate(from: from.a, to: to.a, percent: percent),
      b: interpolate(from: from.b, to: to.b, percent: percent),
      c: interpolate(from: from.c, to: to.c, percent: percent),
      d: interpolate(from: from.d, to: to.d, percent: percent),
      tx: interpolate(from: from.tx, to: to.tx, percent: percent),
      ty: interpolate(from: from.ty, to: to.ty, percent: percent)
    )
  }
}

extension UIColor: Interpolated {
  static func interpolated(from: UIColor, to: UIColor, percent: Double) -> Self {
    var fromRed: CGFloat = 0, fromBlue: CGFloat = 0, fromGreen: CGFloat = 0, fromAlpha: CGFloat = 0
    from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
    
    var toRed: CGFloat = 0, toBlue: CGFloat = 0, toGreen: CGFloat = 0, toAlpha: CGFloat = 0
    to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
    
    return self.init(
      red: interpolate(from: fromRed, to: toRed, percent: percent),
      green: interpolate(from: fromGreen, to: toGreen, percent: percent),
      blue: interpolate(from: fromBlue, to: toBlue, percent: percent),
      alpha: interpolate(from: fromAlpha, to: toAlpha, percent: percent)
    )
  }
}

extension CGFloat: Interpolated {
  static func interpolated(from: CGFloat, to: CGFloat, percent: Double) -> CGFloat {
    return from + (to - from) * CGFloat(percent)
  }
}
