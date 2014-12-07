//
//  CustomActionSheetCell.swift
//
//  Created by ToKoRo on 2014-12-07.
//

import UIKit

public class CustomActionSheetCell: UITableViewCell {

    @IBOutlet weak var label: UILabel?

    public func updateWithAlertAction(action: CustomActionSheetAction) {
        self.label?.text = action.title
    }

    public override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.7
        } else {
            self.alpha = 1.0
        }
    }
    
}
