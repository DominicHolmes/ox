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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        saveButton.isEnabled = false
        nameField.becomeFirstResponder()
    }
}
