//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Kevin Bates on 3/4/21.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameView: UILabel!
    
    var changedProfilePicture: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changedProfilePicture = false
        let user = PFUser.current()!
        let rawImageFile = user["profilePicture"]
        
        displayNameView.text = user.username
        if rawImageFile != nil {
            let imageFile = rawImageFile as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
        
            profileImage.af.setImage(withURL: url)
        }
        
        profileImage.layer.cornerRadius = profileImage.bounds.width/2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        
        let user = PFUser.current()!
        
        if changedProfilePicture {
            let imageData = profileImage.image!.pngData()
            let file = PFFileObject(data: imageData!)
        
            user["profilePicture"] = file
        
            user.saveInBackground { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    print("saved profile picture!")
                } else {
                    print("error!")
                }
            }
        }
        
        self.tabBarController?.selectedIndex = 0
    }
    
    
    @IBAction func chooseNewProfilePic(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 181, height: 181)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        profileImage.image = scaledImage
        changedProfilePicture = true
        
        dismiss(animated: true, completion: nil)
    }
}
