//
//  Created by Pierluigi Cifani on 07/03/2018.
//

import UIKit

//: Suggested by [@al_skipp](https://twitter.com/al_skipp)
extension UIEdgeInsets {
    public init(uniform: CGFloat) {
        top = uniform
        left = uniform
        bottom = uniform
        right = uniform
    }
}

//: Credit to [Adam Sharp](https://twitter.com/sharplet) & [Daniel Jalkut](https://twitter.com/danielpunkass)
extension UIEdgeInsets: ExpressibleByDictionaryLiteral {
    public typealias Key = EdgeKey
    public typealias Value = CGFloat

    public enum EdgeKey {
        case top
        case left
        case bottom
        case right
    }

    func keyPathForEdge(_ edgeKey: EdgeKey) -> WritableKeyPath<UIEdgeInsets, CGFloat> {
        switch edgeKey {
        case .top: return \UIEdgeInsets.top
        case .left: return \UIEdgeInsets.left
        case .bottom: return \UIEdgeInsets.bottom
        case .right: return \UIEdgeInsets.right
        }
    }

    public init(dictionaryLiteral elements: (EdgeKey, CGFloat)...) {
        self = UIEdgeInsets()

        for (inset, value) in elements {
            let keyPath = self.keyPathForEdge(inset)
            self[keyPath: keyPath] = value
        }
    }
}