//
//  ViewController.swift
//  Isabel
//
//  Created by Isabel Lee on 10/25/18.
//  Copyright © 2018 littlstar. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

  @IBAction func clearButton(_ sender: UIButton) {
    notesTextView.text = ""
    if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsQuickNotes") {
      userDefaults.set(notesTextView.text, forKey: "notes")
      userDefaults.synchronize()
    }
  }
  
  @IBAction func saveButton(_ sender: UIButton) {
    endEditing()
  }
  
  @IBOutlet weak var notesTextView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()

    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(gesture(_:)))
    swipeGestureRecognizer.direction = .down
    notesTextView.addGestureRecognizer(swipeGestureRecognizer)
    
    if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsQuickNotes") {
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
      if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsQuickNotes") {
        userDefaults.set(notesTextView.text, forKey: "notes")
        userDefaults.synchronize()
      }
    }
  }
  
  @objc func gesture(_ recognizer: UIGestureRecognizer) {
    endEditing()
  }
  
  @IBAction func unwindToVC(sender: UIStoryboardSegue) {}
}

extension ViewController: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    endEditing()
  }
}
