//
//  ViewController.swift
//  Tutor+_Profile
//
//  Created by Bo Lan  on 10/15/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit

class UserProfileEditController: UIViewController,  UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameEditor: UITextField!
    @IBOutlet weak var genderTextBox: UITextField!
    @IBOutlet weak var genderDropDown: UIPickerView!
    @IBOutlet weak var majorEditor: UITextField!
    @IBOutlet weak var universityEditor: UITextField!
    @IBOutlet weak var tutorSwitch: UISwitch!
    @IBOutlet weak var tutorStatus: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var personalState: UITextView!
    
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var courseSearchTableView: UITableView!
    @IBOutlet weak var schoolSearchTableView: UITableView!

    @IBOutlet weak var addClass: UITextField!
    @IBOutlet weak var addGradeText: UITextField!
    
    var imagePicker: UIImagePickerController!
    
    let genderList = ["Male","Female","Rather not to say"]
    var selectedGender: String?
    var bottomOffset = CGPoint(x: 0, y: 400)
    
    var currentEditSchool = [String]()
    var currentEditCourse = [String]()
    
    var EditSchoolList = [String]()
    var EditCourseList = [String]()
    
    var classData = [String]()
    var gradeData = [String]()
    var deletedData = [String]()
    
    var isSchoolChosen = true
    var isCourseChosen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Update Schedule
        updateSchedule(schedule: FirebaseUser.shared.schedule)
        
        // Initialize navigation bar titile
        self.navigationItem.title = "Profile Edit"
        
        
        
        // Do initialization
        self.initializePersonalStatementTextField()
        initializeFirebaseInfo()
        initializeImage()
        
        initializeTextField()
        initializeTableView()
        
        // Calling gender dropdown
        createGenderPicker()
        createToolbar()

        // Reload courseTableView
        downloadSchoolColection()
        downloadCourseColection()
        
        self.hideKeyboardWhenTappedAroundII()
    }
    // ---------------------------------------------------------
    // keyboard issue
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return (true)
//    }
//
    // ------------------------------------------------------------------------------------
    // Initialization functions
    
    private func initializeFirebaseInfo(){
        nameEditor.text = FirebaseUser.shared.name
        genderTextBox.text = FirebaseUser.shared.gender
        majorEditor.text = FirebaseUser.shared.major
        universityEditor.text = FirebaseUser.shared.university
        
        classData = FirebaseUser.shared.classData
        gradeData = FirebaseUser.shared.gradeData
    }
    
    private func initializePersonalStatementTextField(){
        personalState.text = FirebaseUser.shared.ps
        personalState.backgroundColor = UIColor(hue: 0.5333, saturation: 0.02, brightness: 0.94, alpha: 1.0)
        personalState.font = UIFont.systemFont(ofSize: 20)
        personalState.textColor = UIColor.black
        personalState.font = UIFont.boldSystemFont(ofSize: 20)
        personalState.font = UIFont(name:"Verdana", size: 17)
        
        personalState.isEditable = true
        personalState.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        
        // make web links clickable
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
        
        if let image = FirebaseUser.shared.image{ imageButton.setImage(image, for: .normal) }
        else { imageButton.setImage(UIImage(named: "landscape"), for: .normal) }
    }
    
    private func initializeTableView(){
        courseTableView.delegate = self
        courseSearchTableView.delegate = self
        schoolSearchTableView.delegate = self
        
        courseTableView.dataSource = self
        courseSearchTableView.dataSource = self
        schoolSearchTableView.dataSource = self
        
        courseTableView.reloadData()
        courseTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func initializeTextField(){
        addClass.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        universityEditor.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func downloadSchoolColection(){
        
        FirebaseTrans.shared.downloadAllDocumentIdByCollection(collections: [FirebaseTrans.SCHOOL_COLLECTION], completion: {(data)in
            if let data = data{
                self.EditSchoolList = data
                self.currentEditSchool = self.EditSchoolList.filter({ school -> Bool in
                    school.lowercased().contains((self.universityEditor.text ?? "") .lowercased())
                })
                self.schoolSearchTableView.reloadData()
                debugHelpPrint(type: .UserProfileEditController, str: "\(self.currentEditSchool)")
            }
        })
    }
    
    private func downloadCourseColection(){
        
        if FirebaseUser.shared.university == nil || FirebaseUser.shared.university == "" { return }
        
        var theCollection = [FirebaseTrans.SCHOOL_COLLECTION]
        theCollection.append(FirebaseUser.shared.university!)
        theCollection.append(FirebaseTrans.COURSE_COLLECTION)
        
        FirebaseTrans.shared.downloadAllDocumentIdByCollection(collections: theCollection, completion: {(data)in
            if let data = data{
                self.EditCourseList = data
                self.currentEditCourse = data
                self.courseSearchTableView.reloadData()
                debugHelpPrint(type: .UserProfileEditController, str: "\(self.currentEditCourse)")
            }
        })
    }
    // ------------------------------------------------------------------------------------
    // TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.courseSearchTableView{
            return currentEditCourse.count
        }
        if tableView == self.schoolSearchTableView{
            return currentEditSchool.count
        }
        return classData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.courseSearchTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserEditCourseCell", for: indexPath) as! SearchViewTableViewCell
            cell.suggestionLabel.text = currentEditCourse[indexPath.row]
            return cell
        }
        if tableView == self.schoolSearchTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserEditSchoolCell", for: indexPath) as! SearchViewTableViewCell
            //debugHelpPrint(type: .UserProfileEditController, str: "current school: \(currentEditSchool)\n")
            //debugHelpPrint(type: .UserProfileEditController, str: "index:\(indexPath.row) count:\(currentEditSchool.count)")
            cell.suggestionLabel.text = currentEditSchool[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! UserProfileEditCourseCell
        cell.classLabel.text = classData[indexPath.row]
        cell.gradeLabel.text = gradeData[indexPath.row]
        cell.index = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.courseTableView && editingStyle == .delete {
            print("delete")
            
            self.deletedData.append(self.classData[indexPath.row])
            self.classData.remove(at: indexPath.row)
            self.gradeData.remove(at: indexPath.row)
            
            self.courseTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == courseSearchTableView{
            let currentCell = tableView.cellForRow(at: indexPath) as! SearchViewTableViewCell
            addClass.text = currentCell.suggestionLabel.text
            isCourseChosen = true
            courseSearchTableView.isHidden = true
        }
        
        if tableView == schoolSearchTableView{
            let currentCell = tableView.cellForRow(at: indexPath) as! SearchViewTableViewCell
            universityEditor.text = currentCell.suggestionLabel.text
            isSchoolChosen = true
            schoolSearchTableView.isHidden = true
        }
    }
    
    @objc func textFieldDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            if(textView == addClass){
                isCourseChosen = false
                courseSearchTableView.isHidden = true
            }
            
            if(textView == universityEditor){
                isSchoolChosen = false
                schoolSearchTableView.isHidden = true
            }
            return
        }
        
        if(textView == addClass){
            isCourseChosen = false
            courseSearchTableView.isHidden = false
            currentEditCourse = EditCourseList.filter({ course -> Bool in
                course.lowercased().contains(textView.text.lowercased())
            })
            courseSearchTableView.reloadData()
        }
        
        if(textView == universityEditor){
            isSchoolChosen = false
            schoolSearchTableView.isHidden = false
            currentEditSchool = EditSchoolList.filter({ school -> Bool in
                school.lowercased().contains(textView.text.lowercased())
            })
            schoolSearchTableView.reloadData()
        }
    }
    
    // ------------------------------------------------------------------------------------
    // Buttons
    
    // save button
    @IBAction func saveProfile(_ sender: Any) {
        
        // Check
        if !isSchoolChosen{
            AlertHelper.showAlert(fromController: self, message: "You have to choose course from the list we gave you.", buttonTitle: "Error")
            return
        }
        
        //Profile
        FirebaseUser.shared.name = nameEditor.text
        FirebaseUser.shared.gender = genderTextBox.text
        FirebaseUser.shared.major = majorEditor.text
        FirebaseUser.shared.university = universityEditor.text
        FirebaseUser.shared.ps = personalState.text
        FirebaseUser.shared.schedule = scheduleToString()
        FirebaseUser.shared.tag = classData
        
        // upload image
        if let _chosenImage = chosenImage{
            //It has a new image
            FirebaseUser.shared.uploadImage(data: _chosenImage.pngData()!, completion: {(success) in
                if success{
                    FirebaseUser.shared.image = _chosenImage
                    FirebaseUser.shared.uploadProfile()
                }
            })
        }else{
            // It doesn't have a new image
            FirebaseUser.shared.uploadProfile()
        }
        
        // upload and delete courses and grades
        FirebaseUser.shared.classData = self.classData
        FirebaseUser.shared.gradeData = self.gradeData
        
        debugHelpPrint(type: .UserProfileEditController, str: "deletedData: \(deletedData)")
        
        FirebaseUser.shared.deleteTutorCourses(courseList: deletedData)
        FirebaseUser.shared.uploadTutorCourses(courseList: classData, gradeList: gradeData)
        
        // Go back to previous page
        self.performSegue(withIdentifier: "ProfileEditToTabBar", sender: self)
    }
    
    // tutor swtich
    @IBAction func tutorSwitchValueChanged(_ sender: Any) {
       
        if (tutorSwitch.isOn == true) {
            scrollView.setContentOffset(bottomOffset, animated: true)
            //saveButton.frame.origin.y += bottomOffset.y
            
            // disable scrollview vertical scrolling
            scrollView.contentSize = CGSize(width: 1.0, height: 1300)
            scrollView.isScrollEnabled = true
            self.tutorStatus.text = "Yes!  I'm a great tutor"
        } else{
            scrollView.setContentOffset(CGPoint(x:0, y: 0), animated: true)
            //saveButton.frame.origin.y -= bottomOffset.y
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
    @objc override func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
    @IBAction func addCell(_ sender: Any) {
        if !isCourseChosen{
            AlertHelper.showAlert(fromController: self, message: "You have to chose the courses from the list!", buttonTitle: "Error")
            return
        }
        classData.append(addClass.text!)
        gradeData.append(addGradeText.text!)
        
        let indexPath = IndexPath(row: self.classData.count - 1, section: 0)
        
        courseTableView.beginUpdates()
        courseTableView.insertRows(at: [indexPath], with: .automatic)
        courseTableView.endUpdates()
        
        view.endEditing(true)
    }
    
    // ------------------------------------------------------------------------------------
    // Schedule
    
    var scheduleData: Array<Character> = Array(repeating: "0", count: 28)
    
    @IBOutlet var scheduleBtn: [UIButton]!
    
    @IBAction func dataClicked(_ sender: UIButton){
        if scheduleBtn[sender.tag].backgroundColor == UIColor.gray{
            scheduleBtn[sender.tag].backgroundColor = UIColor.init(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.0)
            scheduleData[sender.tag] = "1"
            debugHelpPrint(type: .UserProfileEditController, str: scheduleToString())
        }else{
            scheduleBtn[sender.tag].backgroundColor = UIColor.gray
            scheduleData[sender.tag] = "0"
            debugHelpPrint(type: .UserProfileEditController, str: scheduleToString())
        }
    }
    
    
    func updateSchedule (schedule: String?){
        if let schedule = schedule, schedule != ""{
            scheduleData = Array(schedule)
            for i in 0...27{
                if scheduleData[i] == "1"{scheduleBtn[i].backgroundColor = UIColor.init(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.0)}
                else{scheduleBtn[i].backgroundColor = UIColor.gray}
            }
        }
    }
    
    //tostring
    func scheduleToString()-> String{
        let stringDate = String(scheduleData)
        return stringDate
    }
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


// image delegates
var chosenImage : UIImage?

extension UserProfileEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.setImage(chosenImage, for: .normal)

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAroundII() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
}



