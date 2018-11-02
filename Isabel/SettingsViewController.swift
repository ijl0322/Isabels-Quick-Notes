//
//  SettingsViewController.swift
//  Isabel
//
//  Created by Isabel Lee on 10/31/18.
//  Copyright © 2018 littlstar. All rights reserved.
//

import UIKit
import Photos
class SettingsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  @IBAction func backButton(_ sender: UIButton) {
    performSegue(withIdentifier: "unwindVC", sender: self)
  }
  
  @IBAction func addBackgroundImage(_ sender: UIButton) {
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
  
  @IBAction func toggleBackgroundImage(_ sender: UIButton) {
    if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsNoteApp") {
      let backgroundOn = userDefaults.bool(forKey: "toggleBackgroundImage")
      userDefaults.set(!backgroundOn, forKey: "toggleBackgroundImage")
      userDefaults.synchronize()
      let title = !backgroundOn ? "ON" : "OFF"
      toggleBackgroundButton.setTitle(title, for: UIControlState.normal)
    }
  }
  
  @IBOutlet weak var toggleBackgroundButton: UIButton!
  let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsNoteApp") {
          let title = userDefaults.bool(forKey: "toggleBackgroundImage") ? "ON" : "OFF"
          toggleBackgroundButton.setTitle(title, for: UIControlState.normal)
        }
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
  
  func pleaseGrantAccessAlert(accessType: String){
    let alert = UIAlertController(title: "Please grant access", message: "Benny cam need to access your \(accessType) to put cute bunnies on your photo!", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
      UIApplication.shared.open(NSURL(string:UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
    }))
    
    present(alert, animated: true, completion: nil)
  }
}

