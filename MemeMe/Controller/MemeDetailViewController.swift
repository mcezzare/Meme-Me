//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mario Cezzare on 04/01/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit


class MemeDetailViewController : UIViewController{
    
    // MARK: - Outlets
    
    @IBOutlet var memeImageView: UIImageView!
    
    // MARK: - Properties
    var meme: Meme!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //To edit a created Meme, add a edit button on navigation bar
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
    }
    
    // MARK: - Segues
    @objc func editMeme(){
        let memeEditorViewController = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditorViewController.memeToModify = meme
        present(memeEditorViewController, animated: true)
    }
    
}
