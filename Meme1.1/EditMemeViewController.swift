//
//  EditMemeViewController.swift
//  Meme1.1
//
//  Created by Guido Roos on 25/06/2023.
//




import Foundation
import UIKit

class EditMemeViewController : UIViewController,
                               UIImagePickerControllerDelegate,
                               UINavigationControllerDelegate,
                               UITextFieldDelegate
{
    
    var meme: Meme? = nil
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    private var shareItem:UIBarButtonItem!
    
    private var isBottomTextFieldEdited = false
    private var isTopTextFieldEdited = false
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let setMeme = meme {
            imageView.image = setMeme.originalImage
            topTextField.text = setMeme.topText
            bottomTextField.text = setMeme.bottomText
        }
        
        setupTextFields(textField: topTextField, defaultText:"TOP")
        setupTextFields(textField: bottomTextField, defaultText:"BOTTOM")
        
        setupNavigationBar()
        setupBottomToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField && !isTopTextFieldEdited {
            textField.text = ""
            isTopTextFieldEdited = true
        }
        
        if textField == bottomTextField && !isBottomTextFieldEdited {
            textField.text = ""
            isBottomTextFieldEdited = true
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTextFields(
        textField: UITextField,
        defaultText: String
    ) {
        textField.delegate = self
        textField.defaultTextAttributes = Utils.memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
        textField.borderStyle = .none
    }
    
    @objc
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func setupNavigationBar() {
        shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareItemTapped))
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelItemTapped))
        
        shareItem.tintColor = UIColor.gray
        shareItem.isEnabled = meme != nil
        
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = shareItem
        navigationItem.rightBarButtonItem = cancelItem
        navigationItem.title = ""
        
        navigationBar.items = [navigationItem]
    }
    
    func setupBottomToolbar() {
        let photoIcon = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: self, action: #selector(photoItemTapped))
        
#if targetEnvironment(simulator)
        photoIcon.isEnabled = false
#else
        UIImagePickerController.isSourceTypeAvailable(.camera)
#endif
        
        photoIcon.tintColor = UIColor.gray
        
        let albumText = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(albumItemTapped))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, photoIcon, flexSpace, albumText, flexSpace], animated: false)
    }
    
    @objc func shareItemTapped() {
        let meme = generateMemeImage()
        
        // On finish share save and navigate back to sent memes table view
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activity,completed, items, error) in
            if (completed) {
                self.save (meme: meme)
                self.dismiss(animated:true, completion: nil)
            }
            
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func cancelItemTapped() {
        imageView.image = nil
        shareItem.isEnabled = false
    }
    
    @objc func photoItemTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func albumItemTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            shareItem.isEnabled = true
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func save (meme: Meme) {
        appDelegate.memes.append(meme)
        
        NotificationCenter.default.post(name: Notification.Name("DataUpdatedNotification"), object: nil)
        
        self.dismiss(animated:true)
    }
    
    func generateMemeImage () -> Meme {
        // Hide toolbar and navbar
        toolbar.isHidden = true
        navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        navigationBar.isHidden = false
        
        let meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            originalImage: imageView.image!,
            memedImage: memedImage
        )
        
        return meme
    }
}







