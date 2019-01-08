//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Mario Cezzare on 03/12/18.
//  Copyright © 2018 Mario Cezzare. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton : UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    @IBOutlet weak var toolbarTopBootom: UIToolbar!
    @IBOutlet weak var toolbarBottomBootom: UIToolbar!
    @IBOutlet weak var cancelButton : UIBarButtonItem!
    @IBOutlet weak var shareButton : UIBarButtonItem!
    
    // MARK: Instance names
    var currentImageSelected:UIImage?
    
    // MARK: Editing Mode for a current Meme
    var memeToModify:Meme!
    
    // MARK: Delegates
    let myTextFieldDelegate = MyTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // MARK: Textfields and TextField Delegate
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareButton.isEnabled = imagePickerView.image != nil
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: User Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        self.openImagePicker(UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        self.openImagePicker(UIImagePickerController.SourceType.camera)
    }
    
    // MARK: Choose image from album or camera
    func  openImagePicker( _ type: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func resetUI(){
        configureUI()
        self.imagePickerView.image = nil
        shareButton.isEnabled = false
        // Now back to memes list
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: From UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            imagePickerView.image = image
            self.currentImageSelected = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User cancelled selection")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UI Common style configs of textFields
    let memeTextAttribs: [String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "Impact", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2
    ]
    
    func configureUI(){
        configureTextProperties(textFieldTop, "TOP")
        configureTextProperties(textFieldBottom, "BOTTOM")
        if self.memeToModify != nil {
            self.imagePickerView.image = self.memeToModify.originalImage
        }
    }
    
    func configureTextProperties(_ textField: UITextField, _ defaulText: String) {
        textField.delegate = self.myTextFieldDelegate
        textField.defaultTextAttributes = memeTextAttribs
        textField.textAlignment = .center
        if self.memeToModify != nil {
            self.textFieldTop.text = self.memeToModify.topText
            self.textFieldBottom.text = self.memeToModify.bottomText
        } else {
            textField.text = defaulText
        }
        
    }
    
    // MARK : Fix keyboard position
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    // MARK: - Meme Operations
    
    // MARK: Get the screenshot of current Meme
    func generateMemedImage() -> UIImage {
        // MARK: Hide toolbar and navbar
        setToolbarHidden(true,animated: true)
        // MARK: Capture all Screen and Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // MARK: Show toolbar and navbar
        setToolbarHidden(false,animated: true)
        return memedImage
    }
    
    // MARK: Remove toolBar from ScreenShot
    func setToolbarHidden(_ hidden: Bool, animated: Bool){
        self.toolbarTopBootom.isHidden = hidden
        self.toolbarBottomBootom.isHidden = hidden
    }
    
    // MARK: Alert user about the save operation of meme
    func notifyUser(title: String, message: String){
        let ac = UIAlertController(title: title, message: message , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: Share the Meme and if success , save the image to the album
    @IBAction func share() {
        let items = [generateMemedImage()]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if (completed && error == nil){
                let meme = Meme(topText: self.textFieldTop.text!,
                                bottomText: self.textFieldBottom.text!,
                                memedImage: items[0],
                                originalImage: self.imagePickerView.image!
                    
                )
                // MARK: - Add it to the memes array in the Application Delegate
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                
                UIImageWriteToSavedPhotosAlbum(meme.memedImage, nil, nil, nil)
                self.notifyUser(title: "Saved!", message: "Your altered image has been saved to your photos.")
                
            } else if( error != nil){
                self.notifyUser(title: "Save error", message: error!.localizedDescription)
                print("Error saving the meme \(error!.localizedDescription)")
            }
        }
        present(activityVC, animated: true)
        // Fix for IPad devices don't crash
        if let popOver = activityVC.popoverPresentationController{
            popOver.sourceView = self.view
        }
    }
    
}
