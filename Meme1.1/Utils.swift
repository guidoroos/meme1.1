//
//  Utils.swift
//  Meme1.1
//
//  Created by Guido Roos on 01/07/2023.
//

import UIKit

struct Utils {
    static let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(
            name: "HelveticaNeue-CondensedBlack",
            size: 40
        )!,
        NSAttributedString.Key.strokeWidth: -2
    ]
}
