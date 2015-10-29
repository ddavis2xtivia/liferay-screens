/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit


public class ForgotPasswordView_flat7: ForgotPasswordView_default {

	@IBOutlet private var titleLabel: UILabel?
	@IBOutlet private var subtitleLabel: UILabel?
	@IBOutlet private var userNamePlaceholder: UILabel?


	//MARK: ForgotPasswordView

	override public func onCreated() {
		super.onCreated()

		setFlat7ButtonBackground(requestPasswordButton)

		BaseScreenlet.setHUDCustomColor(Flat7ThemeBasicGreen)
	}

	override public func onSetTranslations() {
		titleLabel!.text = LocalizedString("flat7", key: "forgotpassword-title", obj: self)
		subtitleLabel!.text = LocalizedString("flat7", key: "forgotpassword-subtitle", obj: self)
		userNamePlaceholder!.text = LocalizedString("flat7", key: "forgotpassword-email", obj: self)

		requestPasswordButton!.replaceAttributedTitle(
				LocalizedString("flat7", key: "forgotpassword-request", obj: self),
				forState: .Normal)

		userNameField!.placeholder = "";
	}


	//MARK: ForgotPasswordView
	
	override public var userName: String? {
		didSet {
			userNamePlaceholder!.changeVisibility(visible: userName != "")
		}
	}


	//MARK: UITextFieldDelegate
	
	internal func textField(textField: UITextField!,
			shouldChangeCharactersInRange range: NSRange,
			replacementString string: String!)
			-> Bool {

		let newText = (textField.text! as NSString).stringByReplacingCharactersInRange(range,
				withString:string)

		userNamePlaceholder!.changeVisibility(visible: newText != "")

		return true
	}

}
