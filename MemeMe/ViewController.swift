//
//  ViewController.swift
//  MemeMe
//
//  Created by Mario Cezzare on 03/12/18.
//  Copyright © 2018 Mario Cezzare. All rights reserved.
//

import UIKit

struct Meme{
    var topText: String?
    var bottomText: String?
    var memedImage: UIImage?
    var originalImage: UIImageView?
    
    init(topText: String, bottomText: String, originalImage: UIImageView, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton : UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    @IBOutlet weak var toolbarTopBootom: UIToolbar!
    @IBOutlet weak var toolbarBottomBootom: UIToolbar!
    @IBOutlet weak var cancelButton : UIBarButtonItem!
    
    //MARK : Instance names
    var currentImageSelected:UIImage?
    //    var currentMemedImage:UIImageView?
    
    
    //MARK: Delegates
    let myTextFieldDelegate = MyTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // MARK: Textfields and TextField Delegate
        configureUI()
        self.textFieldTop.delegate = self.myTextFieldDelegate
        self.textFieldBottom.delegate = self.myTextFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: User Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        self.getAnImage(source: "album")
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        self.getAnImage(source: "camera")
    }
    
    // MARK: Choose image from album or camera
    func  getAnImage( source: String ){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if source == "album" {
            pickerController.sourceType = .photoLibrary
        } else if source == "camera"{
            pickerController.sourceType = .camera
        }
        
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func resetUI(){
        configureUI()
        self.imagePickerView.image = nil
        
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
    
    
    // MARK: UI Common style configs
    func configureUI(){
        configureTextProperties(textFieldTop, "TOP")
        configureTextProperties(textFieldBottom, "BOTTOM")
    }
    
    func configureTextProperties(_ textField: UITextField, _ defaulText: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let memeTextAttributes:[NSAttributedStringKey : Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.clear,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 80)!,
            .strokeWidth: -3.0,
            .paragraphStyle: paragraphStyle
        ]
        textField.attributedText = NSAttributedString(string: defaulText,attributes: memeTextAttributes)
        
        // make the background transparent
        textField.backgroundColor = UIColor.clear
        textField.text = defaulText
    }
    
    
    
    // MARK : Fix keyboard position
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
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
    
    // MARK: Meme Operations
    func save() {
        if let memedImage = generateMemedImage() as? UIImage {
            // Create the meme
            let meme = Meme(topText: textFieldTop.text!,
                            bottomText: textFieldBottom.text!,
                            originalImage: imagePickerView!,
                            memedImage: memedImage
            )
            
            UIImageWriteToSavedPhotosAlbum(memedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
        }
    }
    
    // MARK: Get the screenshot of current Meme
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        setToolbarHidden(true,animated: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        setToolbarHidden(false,animated: true)
        return memedImage
    }
    
    // MARK: Remove toolBar from ScreenShot
    func setToolbarHidden(_ hidden: Bool,
                          animated: Bool){
        self.toolbarTopBootom.isHidden = hidden
        self.toolbarBottomBootom.isHidden = hidden
    }
    
    //  MARK: Alert on operation save
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            notifyUser(title: "Save error", message: error.localizedDescription)
            print("error: \(error.localizedDescription)")
        } else {
            notifyUser(title: "Saved!", message: "Your altered image has been saved to your photos.")
            print("success : File saved")
        }
    }
    
    func notifyUser(title: String, message: String){
        let ac = UIAlertController(title: title, message: message , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true, completion: nil)
        //        self.present(ac, animated: true)
        
    }
    
    // MARK: Share the Meme
    @IBAction func share() {
        save()
        let items = [generateMemedImage()]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}


