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


public class LoginView_flat7: LoginView_default {

	@IBOutlet private var titleLabel: UILabel?
	@IBOutlet private var subtitleLabel: UILabel?
	@IBOutlet private var userNamePlaceholder: UILabel?
	@IBOutlet private var passwordPlaceholder: UILabel?


	//MARK: LoginView

	override public func onCreated() {
		super.onCreated()

		setFlat7ButtonBackground(loginButton)

		BaseScreenlet.setHUDCustomColor(Flat7ThemeBasicGreen)
	}

	override public var userName: String? {
		didSet {
			userNamePlaceholder!.changeVisibility(visible: userName != "")
		}
	}

	override public func onSetTranslations() {
		titleLabel!.text = LocalizedString("flat7", key: "login-title", obj: self)
		subtitleLabel!.text = LocalizedString("flat7", key: "login-subtitle", obj: self)
		userNamePlaceholder!.text = LocalizedString("flat7" ,key: "login-email", obj: self)
		passwordPlaceholder!.text = LocalizedString("flat7", key: "login-password", obj: self)

		loginButton!.replaceAttributedTitle(LocalizedString("flat7", key: "login-login", obj: self),
				forState: .Normal)

		userNameField!.placeholder = "";
		passwordField!.placeholder = "";
	}


	//MARK: UITextFieldDelegate

	internal func textField(textField: UITextField!,
			shouldChangeCharactersInRange range: NSRange,
			replacementString string: String!)
			-> Bool {

		let newText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)

		let placeHolder = textField == userNameField ? userNamePlaceholder : passwordPlaceholder

		placeHolder!.changeVisibility(visible: newText != "")

		return true
	}

}
