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
        // To show more cells when device is in landscape orientation
        let space: CGFloat
        let dimension: CGFloat
        if (UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) { //swift 4.2 if (UIDevice.current.orientation.isPortrait) {
            space = 3.0
            dimension = (view.frame.size.width - (2 * space)) / 3
        } else {
            space = 1.0
            dimension = (view.frame.size.width - (1 * space)) / 5
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
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
