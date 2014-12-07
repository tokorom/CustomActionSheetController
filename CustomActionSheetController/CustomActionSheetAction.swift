//
//  CustomActionSheetAction.swift
//
//  Created by ToKoRo on 2014-12-08.
//

public enum CustomActionSheetActionStyle {
    case Default
    case Cancel
    case Destructive
    case Selected
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
