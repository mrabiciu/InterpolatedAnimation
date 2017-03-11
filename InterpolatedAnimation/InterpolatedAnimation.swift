//
//  InterpolatedAnimation.swift
//  Animation
//
//  Created by Max on 12/14/16.
//  Copyright © 2016 Maxim Rabiciuc. All rights reserved.
//

import Foundation
import UIKit

@objc public class KeyFrame: NSObject {
  let percent: Double
  let action: () -> Void
  public init(percent: Double, action: @escaping () -> Void) {
    self.percent = percent
    self.action = action
  }
}

@objc class InterpolationCurve: NSObject {
  /// InterpolatedAnimation will run its percent value through this function before applying changes to its affected views
  public let curveFunction: (Double) -> Double
  required init(_ curveFunction: @escaping (Double) -> Double) {
    self.curveFunction = curveFunction
    super.init()
  }
  
  /// Similar to system os rubber band effects
  static var rubberBand: InterpolationCurve {
    return self.rubberBand(dampingFactor: 0.5)
  }
  
  /// Linear interpolation that goes past the (0, 1) boundaries
  static var linearUnbounded: InterpolationCurve {
    return self.init() { return $0 }
  }
  
  /// Linear interpolation that is bounded to (0, 1)
  static var linearBounded: InterpolationCurve {
    return self.init() { return min(max(0, $0), 1) }
  }
  
  /// Rubber band effect with a custom damping factor
  /// - parameter dampingFactor: 0 for no damping, 1 for maximum damping
  static func rubberBand(dampingFactor: Double) -> InterpolationCurve {
    let convertedFactor = 1 - min(max(0, dampingFactor), 1)
    return self.init() { percent in
      if percent > 1 {
        return 1 + log10(percent) * convertedFactor
      } else if percent < 0 {
        return 0 - log10(abs(percent) + 1) * convertedFactor
      }
      return percent
    }
  }
  
}

@objc public class InterpolatedAnimation: NSObject {
  /// Determines how much of the view's state is captured at each key frame
  public enum CaptureMode {
    /// Only captures properties when their value changes between keyFrames
    ///
    /// For example. If you run the following:
    /// 1. Keyframe(percent: 0) { backgroundColor = .white }
    /// 2. Keyframe(percent: 0.5) { }
    /// 3. Keyframe(percent: 1) { backgroundColor = .black }
    ///
    /// When animation is at 0.5 backgroundColor will be gray. The value of backgroundColor at the 0.5 keyframe was ignored because backgroundColor had not changed from its previous value
    case updatesOnly

    /// Captures all properties of a view at each key frame
    ///
    /// For example. If you run the following:
    /// 1. Keyframe(percent: 0) { backgroundColor = .white }
    /// 2. Keyframe(percent: 0.5) { }
    /// 3. Keyframe(percent: 1) { backgroundColor = .black }
    ///
    /// When animation is at 0.5 backgroundColor will be white because the backgroundColor was white when the view was captured
    case exact
  }
  
  /// This curve is applied as a filter to the value of percent
  private let interpolationCurve: InterpolationCurve = .rubberBand
  
  /// Setting this causes an to update the properties of all affected views.
  /// Properties will be set to a value that is interpolated using the new value of percent
  public var percent: Double = 0 {
    didSet { moveToPercent(percent) }
  }
  
  /// Superview that encapsulates all updated views
  private weak var view: UIView?
  private let captureMode: CaptureMode
  /// Contains the captured states for each view in the tree
  private var viewMapping: [UIView: ViewPropertyInterpolator] = [:]
  private var translatesMapping: [UIView: Bool] = [:]
  private var constraintsToRestore: [NSLayoutConstraint] = []
  
  public convenience init(view: UIView, animation: @escaping () -> Void) {
    self.init(view: view, keyFrames: [KeyFrame(percent: 1, action: animation)])
  }
  
  public init(view: UIView, captureMode: CaptureMode = .updatesOnly, keyFrames: [KeyFrame]) {
    self.view = view
    self.captureMode = captureMode
    super.init()
    // Traverse the view tree and capture initial state of each view
    
    var initialConstraints = Set<NSLayoutConstraint>()
    view.forEachSubview { view in
      view.constraints.forEach { initialConstraints.insert($0) }
      viewMapping[view] = ViewPropertyInterpolator(view)
     }
    
    // Capture all other key frames
    keyFrames.forEach { addKeyFrame($0) }
    
    var finalConstraints = Set<NSLayoutConstraint>()
    view.forEachSubview { view in
      view.constraints.forEach { finalConstraints.insert($0) }
    }
    
    // If we detect there was a constraint update we remove all constraints in this view tree
    // This avoids causing unsatisfiable constraints
    // Constraints can be restored to their initial state by calling restoreConstraints()
    if !finalConstraints.subtracting(initialConstraints).isEmpty {
      constraintsToRestore = Array(finalConstraints)
      NSLayoutConstraint.deactivate(constraintsToRestore)
    }
    
    view.forEachSubview { view in
      guard var modifier = viewMapping[view] else { return }
      // Reduce the amount of memory used
      // If a property was never updated we don't actually store it's state
      modifier.cleanup()
      if !modifier.isEmpty {
        viewMapping[view] = modifier
      } else {
        viewMapping[view] = nil
      }
      translatesMapping[view] = view.translatesAutoresizingMaskIntoConstraints
      view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    // Reset back to initial state
    percent = 0
    moveToPercent(0)
  }
  
  deinit {
    restoreConstraints()
  }
  
  private var hasRestoredConstraints = false
  public func restoreConstraints() {
    guard !hasRestoredConstraints else { return }
    hasRestoredConstraints = true
    translatesMapping.forEach { view, value in
      view.translatesAutoresizingMaskIntoConstraints = value
    }
    NSLayoutConstraint.activate(constraintsToRestore)
  }
  
  private func addKeyFrame(_ keyFrame: KeyFrame) {
    guard let view = self.view else { return }

    // Move to the percent we're about to capture for
    // We do this so we don't over-capture properties that don't need capturing
    let initialPercent = self.percent
    moveToPercent(keyFrame.percent)
    
    // Run the action and capture all view properties
    keyFrame.action()
    view.forEachSubview { view in
      viewMapping[view]?.captureState(of: view, at: keyFrame.percent, captureMode: captureMode)
    }
    // Go back to initial state
    moveToPercent(initialPercent)
  }

  private func moveToPercent(_ percent: Double) {
    let percent = interpolationCurve.curveFunction(percent)
    // It's important that we update parents before children
    // Otherwise children's layout would be invalidated by parent's frame upate
    var alreadyLaidOut = Set<UIView>()
    
    view?.forEachSubview { view in
      viewMapping[view]?.move(view: view, to: percent)
    }
  }
}


public extension UIView {
  /// Creates an InterpolatedAnimation which will capture the passed in view along with all of its children
  ///
  /// NOTE: Although animation is marked as escaping, the closure will be executed and thrown away within this call. No need to worry about retain cycles
  func interpolatedAnimation(_ animation: @escaping (Void) -> ()) -> InterpolatedAnimation {
    return InterpolatedAnimation(view: self, animation: animation)
  }
  
  
  /// Creates an InterpolatedAnimation which will capture the passed in view along with all of its children.
  /// State will be captured for every key frame and the animation will interpolate between states defined in each key frames
  ///
  /// NOTE: All closures will be executed and thrown away within this call. No need to worry about retain cycles
  func interpolatedAnimation(captureMode: InterpolatedAnimation.CaptureMode = .updatesOnly, _ keyFrames: KeyFrame...) -> InterpolatedAnimation {
    return InterpolatedAnimation(view: self, captureMode: captureMode, keyFrames: keyFrames)
  }
}

fileprivate extension UIView {
  func forEachSubview(_ block: (UIView) -> Void) {
    var views: [UIView] = [self]
    while !views.isEmpty {
      guard let current = views.first else { return }
      views.remove(at: 0)
      block(current)
      views = views + current.subviews
    }
  }
}
