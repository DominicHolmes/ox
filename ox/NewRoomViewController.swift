//
//  NewRoomViewController.swift
//  ox
//
//  Created by Dominic Holmes on 12/8/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

protocol RoomCreationDelegate: class {
    func didCreate(_ room: Room)
    func didCancel()
}

class NewRoomViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewToMove: UIView!
    
    weak var delegate: RoomCreationDelegate?
    
    @IBAction func saveButtonPressed() {
        if nameField.hasText {
            delegate?.didCreate(Room(name: nameField.text ?? "room", iconName: "n/a", color: .systemRed))
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nameFieldUpdated(sender: UITextField) {
        saveButton.isEnabled = sender.hasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.viewToMove.frame.origin.y == 140 {
                self.viewToMove.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.viewToMove.frame.origin.y != 140 {
            self.viewToMove.frame.origin.y = 140
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        saveButton.isEnabled = false
        nameField.becomeFirstResponder()
    }
}
