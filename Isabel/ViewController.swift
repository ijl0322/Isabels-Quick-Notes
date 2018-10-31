//
//  ViewController.swift
//  Isabel
//
//  Created by Isabel Lee on 10/25/18.
//  Copyright © 2018 littlstar. All rights reserved.
//

import UIKit
import Photos
class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  @IBAction func clearButton(_ sender: UIButton) {
    notesTextView.text = ""
  }
  
  @IBAction func saveButton(_ sender: UIButton) {
    endEditing()
  }
  
  @IBAction func selectImage(_ sender: UIButton) {
    if checkPhotoLibraryAuthorization(){
      print("photo library access granted")
      imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
      self.present(imagePicker, animated: true){
      }
    } else {
      print("photo library access not granted")
      pleaseGrantAccessAlert(accessType: "photo library")
    }
  }
  
  @IBOutlet weak var notesTextView: UITextView!
  let imagePicker = UIImagePickerController()
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    imagePicker.allowsEditing = false
    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(gesture(_:)))
    swipeGestureRecognizer.direction = .down
    notesTextView.addGestureRecognizer(swipeGestureRecognizer)
    
    if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsNoteApp") {
      notesTextView.text = userDefaults.string(forKey: "notes") ?? ""
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func endEditing() {
    if notesTextView.isFirstResponder {
      notesTextView.resignFirstResponder()
      if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsNoteApp") {
        userDefaults.set(notesTextView.text, forKey: "notes")
        userDefaults.synchronize()
      }
    }
  }
  
  @objc func gesture(_ recognizer: UIGestureRecognizer) {
    endEditing()
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
    if pickedImage !== nil {
      print("image selected")
      let archiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.isabeljlee.isabelsNoteApp")!.appendingPathComponent("photo.jpeg")
      print(archiveURL)
      let jpgImageData = UIImageJPEGRepresentation(pickedImage!, 1.0)
      do {
        try jpgImageData!.write(to: archiveURL)
      } catch {
        print(error)
      }
    }
    dismiss(animated: true, completion: nil)
  }
  
  //Check if the user has granted photo library access, return true if yes, else return false
  func checkPhotoLibraryAuthorization() -> Bool {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .denied: return false
    case .authorized: return true
    case .restricted: return false
      
    case .notDetermined:
      var requestFinish = false
      var status = false
      PHPhotoLibrary.requestAuthorization({ (newStatus) in
        
        if (newStatus == PHAuthorizationStatus.authorized) {
          print("Granted access to photo Library")
          requestFinish = true
          status = true
        }
        else {
          print("Denied access to photo Library")
          requestFinish = true
        }
      })
      
      while (requestFinish == false) {
        
      }
      return status
    }
  }
  
  
  //Present an alert view controller to ask user to grant access to camera or photo library.
  //Takes user to the settings page when they click "OK"
  func pleaseGrantAccessAlert(accessType: String){
    let alert = UIAlertController(title: "Please grant access", message: "Benny cam need to access your \(accessType) to put cute bunnies on your photo!", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
      UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
    }))
    
    present(alert, animated: true, completion: nil)
  }

}

extension ViewController: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    endEditing()
  }
}
