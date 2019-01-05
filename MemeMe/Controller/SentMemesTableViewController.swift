//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Mario Cezzare on 04/01/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController : UITableViewController {
    
    // MARK: Outlets
    @IBOutlet var sentMemesTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemesTableView.reloadData()
    }
    
    // MARK:init data and datasources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath) as! SentMemesTableViewCell
        
        let meme = appDelegate.memes[indexPath.row]
        print("#########DEBUG#######")
        print(meme)
        print("#########DEBUG#######")
        cell.thumbnailImageView.image = meme.memedImage
        cell.memeTitleLabel.text = "\(String(describing: meme.topText)) \(String(describing: meme.bottomText))"
        return cell
    }
    
    // MARK: Fix height size of row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}
