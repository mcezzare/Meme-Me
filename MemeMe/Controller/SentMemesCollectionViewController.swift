//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Mario Cezzare on 05/01/19.
//  Copyright © 2019 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    //MARK: Outlets
    @IBOutlet var sentMemesCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Shared object
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUIDefaultState()
    }

    private func resetUIDefaultState(){
        sentMemesCollectionView.reloadData()
        //sentMemesCollectionView.allowsMultipleSelection = true
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: 135, height: 135)
    }

    // MARK: Init data and datasources
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = appDelegate.memes[indexPath.row]
        cell.backgroundImageView.image = meme.memedImage
        
        return cell
    }
    
    // MARK: Send do Meme View
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
}
