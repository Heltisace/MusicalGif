//
//  RoundLabel.swift
//  testMusic1
//
//  Created by Heltisace on 23.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import FLAnimatedImage

class RoundGif: FLAnimatedImageView {
    convenience init(type: FLAnimatedImageView) {
        self.init(type: type)
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    override var clipsToBounds: Bool {
        didSet {
            //layer.cornerRadius = 10
        }
    }
}
