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
    
    weak var delegate: ProfileUpdateDelegate?
    
    var firstName: String?
    var lastName: String?
    var dob: String?
    var phone: String?
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add padding for text fields
        addPadding(to: firstNameTextField)
        addPadding(to: lastNameTextField)
        addPadding(to: dobTextField)
        addPadding(to: phoneTextField)
        
        // Load existing profile data
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        dobTextField.text = dob
        phoneTextField.text = phone
        
        // Load profile image from UserDefaults
        if let imageData = UserDefaults.standard.data(forKey: "profileImage") {
            ImageView.image = UIImage(data: imageData)
        } else {
            ImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        ImageView.layer.cornerRadius = ImageView.frame.size.width / 2
        ImageView.clipsToBounds = true
        ImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfilePicture))
        ImageView.addGestureRecognizer(tapGesture)
    }
    
    func addPadding(to textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    @objc func selectProfilePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            ImageView.image = selectedImage
        }
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let updatedFirstName = firstNameTextField.text ?? ""
        let updatedLastName = lastNameTextField.text ?? ""
        let updatedDob = dobTextField.text ?? ""
        let updatedPhone = phoneTextField.text ?? ""

        // Save profile image in UserDefaults
        if let imageData = ImageView.image?.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profileImage")
        }
        
        // Save profile name in UserDefaults
        UserDefaults.standard.set("\(updatedFirstName) \(updatedLastName)", forKey: "profileName")

        // Send updated data to ProfileViewController
        delegate?.didUpdateProfile(
            firstName: updatedFirstName,
            lastName: updatedLastName,
            dob: updatedDob,
            phone: updatedPhone,
            profileImage: ImageView.image
        )
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

