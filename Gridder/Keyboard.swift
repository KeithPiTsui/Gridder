import UIKit

public struct Keyboard {
    
    public enum Mode {
        case defaultKeyboard
        case numberPunctuationKeyboard
        case numberSymbolKeyboard
        case alphaKeyboard
        case numericKeyboard
    }
    
    public static let symbols = "()[]{}#%^*+=-\\|~<>€£¥•/:&$@_"
    public static let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    public static let puncutations = ".,?!';\""
    public static let numbers = "1234567890"
    
    //
    public static let numberPunctuationKeyboardGrid: Grid<Key> = {
        let a = "123456789" --- "-/:;()$&@\""
        let c = "modechangeSym" ||| 0.1 ||| ".,?!'" ||| 0.1 ||| "backspace><1.2"
        let d = "modechangeABC" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
        return a --- c --- d
    }()
    //
    public static let symbolKeyboardGrid: Grid<Key> = {
        
        let a = "[]{}#%^*+=" --- "_\\|~<>€£¥•"
        let c = "modechange123" ||| 0.1 ||| ".,?!'" ||| 0.1 ||| "backspace><1.2"
        let d = "modechangeABC" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
        
        return a --- c --- d
    }()
    ////
    public static let defaultKeyboardGrid: Grid<Key> = {
        let a = "QWERTYUIOP" --- 0.5 ||| "ASDFGHJKL" ||| 0.5
        let c = "shift><1.2" ||| 0.1 ||| "ZXCVBNM" ||| 0.1 ||| "backspace><1.2"
        let d = "modechange123" ||| "keyboardchange" ||| "settings" ||| "space><4" ||| "return><2"
        
        return a --- c --- d
    }()
    
    
    public static let alphaKeyboardGrid: Grid<Key> = {
        return "QWERTYUIOP"
            --- 0.5 ||| "ASDFGHJKL" ||| 0.5
            --- 1.3 ||| "ZXCVBNM" ||| 0.1 ||| "backspace><1.2"
            --- 1
    }()
    
    public static let numberKeyboardGrid: Grid<Key> = {
        return "123" --- "456" --- "789" --- 1 ||| "0" ||| "backspace"
    }()
    
    fileprivate static let keywords: [String] = ["shift", "backspace","modechange123","modechangeABC","modechangeSym","keyboardchange","space","return", "settings"]
}

extension String {
  public var chars: [String] {
    return self.characters.reduce([]) {(initializer:[String], element: Character) -> [String] in
      var strings = initializer
      strings.append("\(element)")
      return strings
    }
  }
}


extension String {
    fileprivate var compositeGrid: Grid<Key> {
        return chars.map{ $0.singularGrid }.reduce(Grid()){$0 ||| $1}
    }
    
    fileprivate var singularGrid: Grid<Key> {
        let values = self.components(separatedBy: "><")
        guard values.count >= 1 && values.count <= 3 else { fatalError("keyboard layout syntax error") }
        let key: Key = Key(stringLiteral: values.first!)
        if values.count == 1 {
            return .primitive(CGSize.one, .element(key))
        } else if values.count == 2 {
            guard let w = Double(values[1]) else { fatalError("keyboard layout syntax error") }
            return .primitive(CGSize(width: w, height: 1), .element(key))
        } else if values.count == 3 {
            guard let w = Double(values[1]) else { fatalError("keyboard layout syntax error") }
            guard let h = Double(values[2]) else { fatalError("keyboard layout syntax error") }
            return .primitive(CGSize(width: w, height: h), .element(key))
        } else {
            fatalError("keyboard layout syntax error")
        }
    }
    
    fileprivate var grid: Grid<Key> {
        guard let value = self.components(separatedBy: "><").first else { fatalError("keyboard layout syntax error") }
        return Keyboard.keywords.contains(value) ? self.singularGrid : self.compositeGrid
    }
    
    fileprivate static func ||| (g: CGFloat, r: String) -> Grid<Key> {
        return .beside(Grid(), g, r.grid)
    }
    
    fileprivate static func ||| (l: String, g: CGFloat) -> Grid<Key> {
        return .beside(l.grid, g, Grid())
    }
    
    fileprivate static func ||| (l: String, r: String) -> Grid<Key> {
        return .beside(l.grid, 0, r.grid)
    }
    
    fileprivate static func ||| (l: String, r: Grid<Key>) -> Grid<Key> {
        return .beside(l.grid, 0, r)
    }
    
    fileprivate static func ||| (l: Grid<Key>, r: String) -> Grid<Key> {
        return .beside(l, 0, r.grid)
    }
    
    
    fileprivate static func --- (g: CGFloat, r: String) -> Grid<Key> {
        return .below(Grid(), g, r.grid)
    }
    
    fileprivate static func --- (l: String, g: CGFloat) -> Grid<Key> {
        return .below(l.grid, g, Grid())
    }
    
    
    fileprivate static func --- (l: String, r: String) -> Grid<Key> {
        return .below(l.grid, 0, r.grid)
    }
    
    fileprivate static func --- (l: Grid<Key>, r: String) -> Grid<Key> {
        return .below(l, 0, r.grid)
    }
    
    fileprivate static func --- (l: String, r: Grid<Key>) -> Grid<Key> {
        return .below(l.grid, 0, r)
    }
}

















