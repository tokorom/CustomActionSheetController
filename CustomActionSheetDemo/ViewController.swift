//
//  ViewController.swift
//  CustomActionSheetDemo
//
//  Created by tokorom on 12/7/14.
//  Copyright (c) 2014 tokoro. All rights reserved.
//

import UIKit
import CustomActionSheetController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func action(sender: AnyObject) {
        let alert = CustomActionSheetController.actionSheet(title: "", message: "", sender: sender)
        
        alert.addAction(CustomActionSheetAction(title: "Take Photo", style: .Default, handler: { [weak self] action in
            self?.alertMessage(action.title)
            return
        }))
        alert.addAction(CustomActionSheetAction(title: "Select Images", style: .Default, handler: { [weak self] action in
            self?.alertMessage(action.title)
            return
        }))
        alert.addAction(CustomActionSheetAction(title: "Cancel", style: .Cancel, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func manyActions(sender: AnyObject) {
        let alert = CustomActionSheetController.actionSheet(title: "", message: "", sender: sender)
        
        for index in 0..<20 {
            alert.addAction(CustomActionSheetAction(title: toString(index), style: .Default, handler: { [weak self] action in
                self?.alertMessage(action.title)
                return
            }))
        }
        alert.addAction(CustomActionSheetAction(title: "Cancel", style: .Cancel, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func selectedSample(sender: AnyObject) {
        let alert = CustomActionSheetController.actionSheet(title: "", message: "", sender: sender)
        
        for index in 0..<10 {
            var style: CustomActionSheetActionStyle
            switch index {
            case 5:
                style = .Selected
            case 9:
                style = .Destructive
            default:
                style = .Default
            }
            alert.addAction(CustomActionSheetAction(title: toString(index), style: style, handler: { [weak self] action in
                self?.alertMessage(action.title)
                return
            }))
        }
        alert.addAction(CustomActionSheetAction(title: "Cancel", style: .Cancel, handler: nil))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    func alertMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { [weak self] (action: UIAlertAction!) -> Void in
            return
        })
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

