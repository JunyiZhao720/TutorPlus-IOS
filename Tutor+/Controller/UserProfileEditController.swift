//
//  ViewController.swift
//  Tutor+_Profile
//
//  Created by Bo Lan  on 10/15/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit

class UserProfileEditController: UIViewController{
    

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameEditor: UITextField!
    @IBOutlet weak var emailEditor: UITextField!
    @IBOutlet weak var genderTextBox: UITextField!
    @IBOutlet weak var genderDropDown: UIPickerView!
    @IBOutlet weak var majorEditor: UITextField!
    @IBOutlet weak var universityEditor: UITextField!
    @IBOutlet weak var tutorSwitch: UISwitch!
    @IBOutlet weak var tutorStatus: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var personalState: UITextView!
    
    var imagePicker: UIImagePickerController!
    
    let genderList = ["Male","Female","Rather not to say"]
    var selectedGender: String?
    var bottomOffset = CGPoint(x: 0, y: 800)
    
    var schoolData = ["UCSC", "UCSC", "beijing university"]
    var classData = ["CMPS115", "CMPS101", "CMPE110"]
    var gradeData = ["A", "A", "B"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Update Schedule
        updateDate()
        
        // Initialize navigation bar titile
        self.navigationItem.title = "Profile Edit"
        
        // Do initialization
        initializePersonalStatementTextField()
        initializeFirebaseInfo()
        initializeImage()
       
        // Calling gender dropdown
        createGenderPicker()
        createToolbar()

        // Reload courseTableView
        courseTableView.reloadData()
        courseTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // ------------------------------------------------------------------------------------
    // Initialization functions
    
    private func initializeFirebaseInfo(){
        nameEditor.text = FirebaseUser.shared.name
        emailEditor.text = FirebaseUser.shared.email
        genderTextBox.text = FirebaseUser.shared.gender
        majorEditor.text = FirebaseUser.shared.major
        universityEditor.text = FirebaseUser.shared.university
    }
    
    private func initializePersonalStatementTextField(){
        personalState.text = "Personal Statement. Watch my video here: www.youtube.com"
        personalState.backgroundColor = UIColor(hue: 0.5333, saturation: 0.02, brightness: 0.94, alpha: 1.0)
        personalState.font = UIFont.systemFont(ofSize: 20)
        personalState.textColor = UIColor.black
        personalState.font = UIFont.boldSystemFont(ofSize: 20)
        personalState.font = UIFont(name:"Verdana", size: 17)
        personalState.isEditable = true
        personalState.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        personalState.isSelectable = true
        personalState.isEditable = false
        personalState.dataDetectorTypes = UIDataDetectorTypes.link
        personalState.isEditable = true
        personalState.autocorrectionType = UITextAutocorrectionType.yes
        personalState.spellCheckingType = UITextSpellCheckingType.yes
        personalState.autocapitalizationType = UITextAutocapitalizationType.none
    }
    
    private func initializeImage(){
        imageButton.layer.cornerRadius = imageButton.frame.size.width/2
        imageButton.clipsToBounds = true
        imageButton.layer.borderColor = UIColor.white.cgColor
    }
    
    // End initialization functions
    // ------------------------------------------------------------------------------------
    
    
    // ------------------------------------------------------------------------------------
    // Buttons
    
    // save button
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
        
        // Go back to previous page
        self.performSegue(withIdentifier: "ProfileEditToProfile", sender: self)
    }
    
    // tutor swtich
    @IBAction func tutorSwitchValueChanged(_ sender: Any) {
       
        if (tutorSwitch.isOn == true) {
            scrollView.setContentOffset(bottomOffset, animated: true)
            saveButton.frame.origin.y += bottomOffset.y
            scrollView.isScrollEnabled = true
            self.tutorStatus.text = "Yes!  I'm a great tutor"
        } else{
            scrollView.setContentOffset(CGPoint(x:0, y: 0), animated: true)
            saveButton.frame.origin.y -= bottomOffset.y
            scrollView.isScrollEnabled = false
            self.tutorStatus.text = "Sorry, not now"
        }
    }
    
    // image button choose images
    @IBAction func choosePhoto(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let photoLibraryAction = UIAlertAction(title: "Use Photo Library", style: .default){(action) in
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // End buttons
    // ------------------------------------------------------------------------------------
    
    
    // ------------------------------------------------------------------------------------
    // Dropdown menu
    
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
    
    // End Dropdown menu
    // ------------------------------------------------------------------------------------
    
    
    // ------------------------------------------------------------------------------------
    // Course Listview
    
    @IBOutlet weak var addSchool: UITextField!
    @IBOutlet weak var addClass: UITextField!
    @IBOutlet weak var addGradeText: UITextField!
    
    @IBAction func addCell(_ sender: Any) {
        schoolData.append(addSchool.text!)
        classData.append(addClass.text!)
        gradeData.append(addGradeText.text!)
        
        let indexPath = IndexPath(row: schoolData.count - 1, section: 0)
        
        courseTableView.beginUpdates()
        courseTableView.insertRows(at: [indexPath], with: .automatic)
        courseTableView.endUpdates()
        
        addSchool.text = ""
        view.endEditing(true)
    }
    
    // End Course Listview
    // ------------------------------------------------------------------------------------
    
    
    

    // ------------------------------------------------------------------------------------
    // Schedule
    
    var date: Array<Character> = Array(repeating: "0", count: 28)
    
    @IBOutlet var dataBtn: [UIButton]!
    
    @IBAction func dateClicked(_ sender: UIButton) {
        if dataBtn[sender.tag].backgroundColor == UIColor.gray{
            dataBtn[sender.tag].backgroundColor = UIColor.init(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.0)
            date[sender.tag] = "1"
            print(("string: "), getDate())
        }else{
            dataBtn[sender.tag].backgroundColor = UIColor.gray
            date[sender.tag] = "0"
            print(("string: "), getDate())
        }
    }
    
    func getDate()-> String{
        return toString()
    }
    
    //这下面写个setter，
    
    func setDate(){   //<--假设你pass个string下来叫 dateDownloade
        let dateDownloade = "0010100010111101010010010101"
        let update = Array(dateDownloade)
        for i in 0...27{
            date[i] = update[i]
        }
    }
    
    func updateDate (){
        //这里call setter
        setDate()
        for i in 0...27{
            if date[i] == "1"{dataBtn[i].backgroundColor = UIColor.init(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.0)}
            else{dataBtn[i].backgroundColor = UIColor.gray}
        }
    }
    
    //tostring
    func toString()-> String{
        let stringDate = String(date)
        return stringDate
    }
    
    // End Schedule
    // ------------------------------------------------------------------------------------

}

// ------------------------------------------------------------------------------------
// Delegates

// gender dropdown menu delegates
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

// course tableview delegates
extension UserProfileEditController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserProfileEditCourseCell
        cell?.schoolLabel.text = schoolData[indexPath.row]
        cell?.classLabel.text = classData[indexPath.row]
        cell?.gradeLabel.text = gradeData[indexPath.row]
        cell?.cellDelegate = self
        cell?.index = indexPath
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            self.schoolData.remove(at: indexPath.row)
            self.classData.remove(at: indexPath.row)
            self.gradeData.remove(at: indexPath.row)
            self.courseTableView.reloadData()
        }
    }

}

// cell delegates
extension UIViewController: TableViewNew {
    func onClick(index: Int) {

        print("\(index) is clicked")
    }
}

// image delegates
extension UserProfileEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.setImage(chosenImage, for: .normal)
        
        FirebaseTrans.shared.uploadFile(folder: FirebaseTrans.IMAGE_FOLDER, id: "1122", fileExtension: ".png", data: chosenImage.pngData()!)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// End Delegates
// ------------------------------------------------------------------------------------


