//
//  MemeCollectionViewController.swift
//  Meme1.1
//
//  Created by Guido Roos on 01/07/2023.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    private let sectionInsets = UIEdgeInsets(
        top: 20.0,
        left: 10.0,
        bottom: 20.0,
        right: 10.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue or create a reusable table view cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as! MemeCollectionCell
        
        // Configure the cell with the data from your data source
        let meme = memes[indexPath.row]
        cell.image.image = meme.memedImage
        
        return cell
    }
    
    private func setupNavigationBar() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToEditMeme))
        
        addItem.tintColor = UIColor.gray
        
        navigationItem.rightBarButtonItem = addItem
        navigationItem.title = "Sent Memes"
    }
    
    
    @objc
    private func navigateToEditMeme () {
        let editMemeController = storyboard?.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        
        present(editMemeController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated),
            name: Notification.Name("DataUpdatedNotification"),
            object: nil
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MemeCollectionCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    @objc
    private func dataUpdated() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (3 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
}

