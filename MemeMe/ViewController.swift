//
//  ViewController.swift
//  MemeMe
//
//  Created by Mario Cezzare on 03/12/18.
//  Copyright © 2018 Mario Cezzare. All rights reserved.
//

import UIKit

struct Meme{
    var topText: String?
    var bottomText: String?
    var memedImage: UIImage?
    var originalImage: UIImageView?
    
    init(topText: String, bottomText: String, originalImage: UIImageView, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

