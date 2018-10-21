//
//  ViewController.swift
//  Tutor+_Profile
//
//  Created by Bo Lan  on 10/15/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit

class UserProfileEditController: UIViewController{
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var nameEditor: UITextField!
    @IBOutlet weak var emailEditor: UITextField!
    @IBOutlet weak var genderTextBox: UITextField!
    @IBOutlet weak var genderDropDown: UIPickerView!
    @IBOutlet weak var majorEditor: UITextField!
    @IBOutlet weak var universityEditor: UITextField!
    @IBAction func tutorButton(_ sender: Any) {
        
    }

    @IBOutlet weak var switchForTutor: UISwitch!

    
    let genderList = ["Male","Female","Rather not to say"]
    var selectedGender: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameEditor.text = FirebaseUser.shared.name
        emailEditor.text = FirebaseUser.shared.email
        genderTextBox.text = FirebaseUser.shared.gender
        majorEditor.text = FirebaseUser.shared.major
        universityEditor.text = FirebaseUser.shared.university

        //set image to circle
        theImage.layer.cornerRadius = theImage.frame.size.width/2
        theImage.clipsToBounds = true
        theImage.layer.borderColor = UIColor.white.cgColor
        
        //calling gender dropdown
//        createGenderPicker()
//        createToolbar()
//        switchForTutor.isOn = false
    }
    
    @IBAction func cancleEditProfile(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        //FirebaseUser.shared.image = theImage.UIImage
        FirebaseUser.shared.name = nameEditor.text
        FirebaseUser.shared.email = emailEditor.text
        FirebaseUser.shared.gender = genderTextBox.text
        FirebaseUser.shared.major = majorEditor.text
        FirebaseUser.shared.university = universityEditor.text
        
        FirebaseUser.shared.uploadDoc()
        
        debugHelpPrint(type: ClassType.UserProfileEditController, str: FirebaseUser.shared.name!)
        debugHelpPrint(type: ClassType.UserProfileEditController, str: FirebaseUser.shared.email!)
        debugHelpPrint(type: ClassType.UserProfileEditController, str: FirebaseUser.shared.gender!)
        debugHelpPrint(type: ClassType.UserProfileEditController, str: FirebaseUser.shared.major!)
        debugHelpPrint(type: ClassType.UserProfileEditController, str: FirebaseUser.shared.university!)
    }
    //gender dropdown Picker
    func createGenderPicker(){
        let genderPicker = UIPickerView()
        genderPicker.delegate = self
        
        genderTextBox.inputView = genderPicker
    }
    
    //gender dropdown-- adding "Done" button
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(UserProfileEditController.dismissKeyboard))
        
        toolBar.setItems([doneButton],animated:false)
        toolBar.isUserInteractionEnabled = true
        
        genderTextBox.inputAccessoryView = toolBar
        
    }
    
    //gender dropdown function
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
}

//gender Dropdown
extension UserProfileEditController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderList[row]
        genderTextBox.text = selectedGender
    }
    
}
