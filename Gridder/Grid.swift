import UIKit

public enum Primitive<Element> {
    case empty
    case element(Element)
}

public indirect enum Grid<Element> {
    case primitive(CGSize, Primitive<Element>)
    case beside(Grid<Element>, CGFloat, Grid<Element>)
    case below(Grid<Element>, CGFloat, Grid<Element>)
    case align(CGPoint, Grid<Element>)
    
    public init() { self = .primitive(CGSize(width: 0, height: 0), .empty) }
}

extension Grid {
    public var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
        case let .beside(l, gap, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: sizeL.width + sizeR.width + gap, height: max(sizeL.height, sizeR.height))
        case let .below(l, gap, r):
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: max(sizeL.width, sizeR.width), height: sizeL.height + sizeR.height + gap)
        case .align(_, let r):
            return r.size
        }
    }
    
    public func aligned(to position: CGPoint) -> Grid {
        return .align(position, self)
    }
}

precedencegroup HorizontalCombination {
    higherThan: VerticalCombination
    associativity: left
}

precedencegroup VerticalCombination {
    associativity: left
}

infix operator ||| : HorizontalCombination

infix operator --- : VerticalCombination

extension Grid {
    public static func ||| (l: Grid<Element>, r: Grid<Element>) -> Grid<Element> {
        return .beside(l, 0, r)
    }
    
    public static func ||| (l: Grid<Element>, g: CGFloat) -> Grid<Element> {
        return .beside(l, g, Grid<Element>())
    }
    
    public static func ||| (g: CGFloat, r: Grid<Element>) -> Grid<Element> {
        return .beside(Grid<Element>(), g, r)
    }
    
    
    
    public static func --- (l: Grid<Element>, r: Grid<Element>) -> Grid<Element> {
        return .below(l, 0, r)
    }
    
    public static func --- (g: CGFloat, r: Grid<Element>) -> Grid<Element> {
        return .below(Grid<Element>(), g, r)
    }
    
    public static func --- (l: Grid<Element>, g: CGFloat) -> Grid<Element> {
        return .below(l, g, Grid<Element>())
    }
}

extension Grid {
    public func map<T>(_ transform: (Element) throws -> T) rethrows -> Grid<T> {
        switch self {
        case .primitive(let size, let pmt):
            if case let .element(e) = pmt {
                let t = try transform(e)
                return .primitive(size, .element(t))
            } else {
                return .primitive(size, .empty)
            }
        case let .beside(l, gap, r):
            return .beside(try l.map(transform), gap, try r.map(transform))
        case let .below(l, gap, r):
            return .below(try l.map(transform), gap, try r.map(transform))
        case .align(let p, let r):
            return .align(p, try r.map(transform))
        }
    }
}


































