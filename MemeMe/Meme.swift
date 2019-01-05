//
//  Meme.swift
//  MemeMe
//
//  Created by Mario Cezzare on 03/01/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var memedImage: UIImage
    var originalImage: UIImageView
    
//    // MARK: init is not necessary
    init(topText: String, bottomText: String, originalImage: UIImageView, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
