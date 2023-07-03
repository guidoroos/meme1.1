//
//  MemeDetailViewController.swift
//  Meme1.1
//
//  Created by Guido Roos on 01/07/2023.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
        
    }
}
