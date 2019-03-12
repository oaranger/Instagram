//
//  SharePhotoController.swift
//  FirebaseInstagram
//
//  Created by Binh Huynh on 1/10/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            print(selectedImage)
            imageView.image = selectedImage
        }
    }
    
    var textView: UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(240, 240, 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text, caption.count > 0 else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Failed to save photo to DB", error)
                return
            }
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShare() {
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image", error)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadUrl, error) in
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to fetch downloadUrl", error)
                    return
                }
                guard let imageUrl = downloadUrl?.absoluteString else { return }
                print("Successfully uploaded post image", imageUrl)
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
            
        }
        
    }
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, widtth: 0, height: 100)
        
        view.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: -8, paddingRight: 0, widtth: 84, height: 0)
        
        view.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, widtth: 0, height: 0)
    }
}
