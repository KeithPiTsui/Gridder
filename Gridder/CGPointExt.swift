//
//  CGPointExt.swift
//  ExtSwift
//
//  Created by Pi on 19/02/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import UIKit

extension CGPoint {
    public init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}

extension CGPoint {
    public var size: CGSize { return CGSize(width: x, height: y) }
    public static let topCenter = CGPoint(x: 0.5, y: 0)
    public static let topLeft = CGPoint(x: 0, y: 0)
    public static let topRight = CGPoint(x: 1, y: 0)
    
    public static let center = CGPoint(x: 0.5, y: 0.5)
    public static let centerLeft = CGPoint(x: 0, y: 0.5)
    public static let centerRight = CGPoint(x: 1, y: 0.5)
    
    public static let bottomLeft = CGPoint(x: 0, y: 1)
    public static let bottomCenter = CGPoint(x: 0.5, y: 1)
    public static let bottomRight = CGPoint(x: 1, y: 1)
    
    public static func + (l: CGPoint, r: CGPoint) -> CGPoint {
        return CGPoint(x:l.x + r.x, y: l.y + r.y)
    }
}
