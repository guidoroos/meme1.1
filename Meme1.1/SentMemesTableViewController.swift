//
//  SentMemesTableViewController.swift
//  Meme1.1
//
//  Created by Guido Roos on 01/07/2023.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    private var editItem: UIBarButtonItem!
    private var selectedItemPosition:IndexPath? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! MemeTableCell
        
        let meme = memes[indexPath.row]
        cell.image.image = meme.memedImage
        cell.label.text = "\(meme.topText)...\(meme.bottomText)"
        
        return cell
    }
    
    private func setupNavigationBar() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToAddMeme))
        editItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(navigateToEditMeme))
        
        addItem.tintColor = UIColor.gray
        editItem.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = editItem
        self.navigationItem.rightBarButtonItem = addItem
        self.navigationItem.title = "Sent Memes"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedItemPosition == indexPath {
            let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
            detailController.meme = memes[indexPath.row]
            detailController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailController, animated: true)
        }
        else {
            selectedItemPosition = indexPath
            editItem.isEnabled = true
        }
    }
    
    @objc
    private func navigateToAddMeme () {
        let editMemeController = storyboard?.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        
        present(editMemeController, animated: true)
    }
    
    @objc
    private func navigateToEditMeme () {
        let editMemeController = storyboard?.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        
        
        if let position = selectedItemPosition {
            editMemeController.meme = memes[position.row]
        }
        
        present(editMemeController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated),
            name: Notification.Name("DataUpdatedNotification"),
            object: nil
        )
        
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MemeTableCell.self, forCellReuseIdentifier: "CellIdentifier")
    }
    
    @objc
    private func dataUpdated() {
        tableView.reloadData()
        selectedItemPosition = nil
        editItem.isEnabled = false
    }
}

