//
//  MyTextFieldDelegate.swift
//  MemeMe
//
//  Created by Mario Cezzare on 04/12/18.
//  Copyright © 2018 Mario Cezzare. All rights reserved.
//

import Foundation
import UIKit

class MyTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    // MARK:  Limpa campos padrão
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let isTopText = textField.text == "TOP"
        let isBottomText = textField.text == "BOTTOM"
        if isTopText || isBottomText {
            textField.text = ""
        }
    }
    
    // MARK:  Enter some o teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
