//
//  CustomActionSheetAction.swift
//
//  Created by ToKoRo on 2014-12-08.
//

public enum CustomActionSheetActionStyle: Int {
    case Default = 0
    case Cancel = 1
    case Destructive = 10
    case Selected = 100
}

public class CustomActionSheetAction {

    public let title: String
    public let style: CustomActionSheetActionStyle
    public var handler: ((CustomActionSheetAction) -> Void)?

    public init(title: String, style: CustomActionSheetActionStyle, handler: ((CustomActionSheetAction) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
}
