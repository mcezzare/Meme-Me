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
    
    // MARK: Shared object
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemesTableView.reloadData()
    }
    
    // MARK: Init data and datasources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    // MARK: Data table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath) as! SentMemesTableViewCell
        
        let meme = appDelegate.memes[indexPath.row]
        cell.thumbnailImageView.image = meme.memedImage
        cell.memeTitleLabel.text = "\(String(describing: meme.topText)) \(String(describing: meme.bottomText))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Send do Meme View
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
    // MARK: To delete the item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: Allow complete drag left to delete Item
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // MARK: Fix height size of row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}
