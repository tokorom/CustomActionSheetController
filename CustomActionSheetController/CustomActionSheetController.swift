//
//  CustomActionSheetController.swift
//
//  Created by ToKoRo on 2014-12-07.
//

import UIKit

public class CustomActionSheetController: UIViewController {

    @IBOutlet weak var actionsTable: UITableView?
    @IBOutlet weak var cancelActionsTable: UITableView?

    var actions = [CustomActionSheetAction]()
    var cancelActions = [CustomActionSheetAction]()

    public var forceInterfaceOrientation: UIInterfaceOrientation?

    public override func viewDidLoad() {
        super.viewDidLoad()
    
        self.actionsTable?.separatorInset = UIEdgeInsetsZero
        self.actionsTable?.layoutMargins = UIEdgeInsetsZero
        self.cancelActionsTable?.separatorInset = UIEdgeInsetsZero
        self.cancelActionsTable?.layoutMargins = UIEdgeInsetsZero

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let maxHeight: CGFloat = 640
            var contentHeight = CGFloat(44 * self.actions.count)
            if maxHeight < contentHeight {
                contentHeight = maxHeight
                self.actionsTable?.scrollEnabled = true
            }
            self.preferredContentSize = CGSizeMake(320, contentHeight)
        }
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        self.forceInterfaceOrientation = nil
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        self.actionsTable?.reloadData()
        self.cancelActionsTable?.reloadData()
        self.updateActionsTableFrame()
    }

    public override func shouldAutorotate() -> Bool {
        if nil != self.forceInterfaceOrientation {
            return false
        }
        return true
    }

    public override func supportedInterfaceOrientations() -> Int {
        if let forceInterfaceOrientation = self.forceInterfaceOrientation {
            switch forceInterfaceOrientation {
            case .Portrait:
                return Int(UIInterfaceOrientationMask.Portrait.rawValue)
            case .PortraitUpsideDown:
                return Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
            case .LandscapeLeft:
                return Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
            case .LandscapeRight:
                return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
            default:
                break
            }
        }
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }

    public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if UIDevice.currentDevice().orientation.isPortrait {
            return .Portrait
        }
        return self.interfaceOrientation
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        for (index, action) in enumerate(self.actions) {
            if .Selected == action.style {
                self.scrollToIndex(index)
                break
            }
        }
    }

    public class func actionSheet(#title: String?, message: String?, sender: AnyObject? = nil) -> CustomActionSheetController {

        let frameworkBundle = NSBundle(identifier: "me.tokoro.CustomActionSheetController")

        var storyboardName: String

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            storyboardName = "CustomActionSheetForPad"
        } else {
            storyboardName = "CustomActionSheet"
        }

        let storyboard = UIStoryboard(name: storyboardName, bundle: frameworkBundle)
        let viewController = storyboard.instantiateInitialViewController() as CustomActionSheetController

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            viewController.modalPresentationStyle = .Popover
            viewController.popoverPresentationController?.backgroundColor = UIColor.blackColor()
        } else {
            viewController.modalPresentationStyle = .Custom
            viewController.transitioningDelegate = viewController
        }

        if let barButtonItem = sender as? UIBarButtonItem {
            viewController.popoverPresentationController?.barButtonItem = barButtonItem
        } else if let view = sender as? UIView {
            viewController.popoverPresentationController?.sourceView = view
            viewController.popoverPresentationController?.sourceRect = self.topCenterInView(view)
        } else if let viewController = sender as? UIViewController {
            viewController.popoverPresentationController?.sourceView = viewController.view
            viewController.popoverPresentationController?.sourceRect = self.topCenterInView(viewController.view)
        } else if let window = UIApplication.sharedApplication().keyWindow {
            viewController.popoverPresentationController?.sourceView = window
            viewController.popoverPresentationController?.sourceRect = self.topCenterInView(window)
        }
        return viewController
    }

    class func topCenterInView(view: UIView) -> CGRect {
        let bounds = view.bounds
        return CGRectMake(bounds.size.width / 2, bounds.size.height / 2, 1, 1)
    }

    public func addAction(action: CustomActionSheetAction) {
        switch action.style {
        case .Cancel:
            self.cancelActions.append(action)
        default:
            self.actions.append(action)
        }
    }

    func updateActionsTableFrame() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            if let table = self.actionsTable {
                let contentSize = table.contentSize
                var frame = table.frame
                frame.size.height = contentSize.height
                let bottomY = CGRectGetMinY(self.cancelActionsTable?.frame ?? CGRectZero) - 10
                frame.origin.y = bottomY - CGRectGetHeight(frame)
                let minY: CGFloat = 20.0
                if minY > CGRectGetMinY(frame) {
                    table.scrollEnabled = true
                    frame.origin.y = minY
                    frame.size.height = bottomY - minY
                }
                table.frame = frame
            }
        }
    }

}

// MARK: - UITableViewDataSource

extension CustomActionSheetController: UITableViewDataSource {

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.actionsTable == tableView {
            return self.actions.count
        } else if self.cancelActionsTable == tableView {
            return self.cancelActions.count
        }
        return 0
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var action: CustomActionSheetAction?
        var cellIdentifier: String
        if self.actionsTable == tableView {
            action = self.actions[indexPath.row]
            switch action!.style {
            case .Destructive:
                cellIdentifier = "Destructive"
            case .Selected:
                cellIdentifier = "Selected"
            default:
                cellIdentifier = "Default"
            }
        } else if self.cancelActionsTable == tableView {
            action = self.cancelActions[indexPath.row]
            cellIdentifier = "Cancel"
        } else {
            cellIdentifier = "Default"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CustomActionSheetCell
        cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        if let action = action {
            cell.updateWithAlertAction(action)
        }
        return cell
    }

    public func dismissWithAction(action: CustomActionSheetAction?) {
        self.dismissViewControllerAnimated(true) { _ in
            if let action = action {
                action.handler?(action)
            }
        }
    }

// MARK: - Private Methods

    func scrollToIndex(index: Int) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        self.actionsTable?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
    }

}

// MARK: - UITableViewDelegate

extension CustomActionSheetController: UITableViewDelegate {

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var action: CustomActionSheetAction?
        if self.actionsTable == tableView {
            action = self.actions[indexPath.row]
        } else if self.cancelActionsTable == tableView {
            action = self.cancelActions[indexPath.row]
        }

        dispatch_async(dispatch_get_main_queue()) { [weak self] _ in
            self?.dismissWithAction(action)
            return
        }
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension CustomActionSheetController: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        return CustomActionSheetPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

}
