//
//  TodayViewController.swift
//  Isabel's Quick Notes
//
//  Created by Isabel Lee on 10/25/18.
//  Copyright © 2018 littlstar. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var notesLabel: UILabel!
  override func viewDidLoad() {
        super.viewDidLoad()
        var notes = ""
        if let userDefaults = UserDefaults(suiteName: "group.isabeljlee.isabelsNoteApp") {
          notes = userDefaults.string(forKey: "notes") ?? "Nothing!"
        }
        notesLabel.text = notes
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        // Do any additional setup after loading the view from its nib.
    
        let archiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.isabeljlee.isabelsNoteApp")!.appendingPathComponent("photo.jpeg")
        let image = UIImage(contentsOfFile: archiveURL.path)
        imageView.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
  
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
      let expanded = activeDisplayMode == .expanded
      preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
      notesLabel.alpha = expanded ? 0 : 1
      imageView.alpha = expanded ? 1 : 0
    }
}
