//
//  editProfileViewController.swift
//  MoneyPlant App
//
//  Created by admin15 on 29/12/24.
//

import UIKit

protocol ProfileUpdateDelegate: AnyObject {
    func didUpdateProfile(firstName: String, lastName: String, dob: String, phone: String, profileImage: UIImage?)
}

class editProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: ProfileUpdateDelegate?
    
    var firstName: String?
    var lastName: String?
    var dob: String?
    var phone: String?
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add 16 points of indentation on the left of the text field
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
           firstNameTextField.leftView = paddingView
           firstNameTextField.leftViewMode = .always
           
           // Similarly for other text fields
           let lastNamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
           lastNameTextField.leftView = lastNamePaddingView
           lastNameTextField.leftViewMode = .always
           
           let dobPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
           dobTextField.leftView = dobPaddingView
           dobTextField.leftViewMode = .always
           
           let phonePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
           phoneTextField.leftView = phonePaddingView
           phoneTextField.leftViewMode = .always
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
                dobTextField.text = dob
                phoneTextField.text = phone
        ImageView.image = profileImage ?? UIImage(systemName: "person.circle.fill")
        ImageView.layer.cornerRadius = ImageView.frame.size.width / 2
        ImageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfilePicture))
               ImageView.addGestureRecognizer(tapGesture)
    
        
        // Do any additional setup after loading the view.
    }
    
    @objc func selectProfilePicture() {
           let picker = UIImagePickerController()
           picker.delegate = self
           picker.sourceType = .photoLibrary
           present(picker, animated: true)
       }
       
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
           let updatedFirstName = firstNameTextField.text ?? ""
           let updatedLastName = lastNameTextField.text ?? ""
           let updatedDob = dobTextField.text ?? ""
           let updatedPhone = phoneTextField.text ?? ""
           
           // Send updated data to ProfileViewController
           delegate?.didUpdateProfile(
               firstName: updatedFirstName,
               lastName: updatedLastName,
               dob: updatedDob,
               phone: updatedPhone,
               profileImage: ImageView.image
           )
           
           dismiss(animated: true) // Use dismiss if you present modally
       }
       
       // MARK: - UIImagePickerControllerDelegate
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let selectedImage = info[.originalImage] as? UIImage {
               ImageView.image = selectedImage
           }
           dismiss(animated: true)
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
