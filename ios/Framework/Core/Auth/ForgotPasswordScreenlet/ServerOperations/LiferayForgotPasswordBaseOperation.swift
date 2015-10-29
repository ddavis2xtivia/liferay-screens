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


public class LiferayForgotPasswordBaseOperation: ServerOperation {

	public var companyId: Int64 = 0

	public var resultPasswordSent: Bool?

	override public var hudLoadingMessage: HUDMessage? {
		return (LocalizedString("forgotpassword-screenlet", key: "loading-message", obj: self),
		details: LocalizedString("forgotpassword-screenlet", key: "loading-details", obj: self))
	}
	override public var hudFailureMessage: HUDMessage? {
		return (LocalizedString("forgotpassword-screenlet", key: "loading-error", obj: self), details: nil)
	}
	override public var hudSuccessMessage: HUDMessage? {
		return (LocalizedString("forgotpassword-screenlet", key: successMessageKey, obj: self),
				details: LocalizedString("forgotpassword-screenlet", key: "loaded-details", obj: self))
	}

	internal var viewModel: ForgotPasswordViewModel {
		return screenlet.screenletView as! ForgotPasswordViewModel
	}

	private var successMessageKey = ""


	//MARK ServerOperation

	override func validateData() -> Bool {
		var valid = super.validateData()

		if valid && viewModel.userName == nil {
			showValidationHUD(
					message: LocalizedString("forgotpassword-screenlet", key: "validation", obj: self))

			valid = false
		}

		return valid
	}

	override func postRun() {
		if lastError != nil {
			successMessageKey = resultPasswordSent! ? "password-sent" : "reset-sent"
		}
	}

	override func doRun(session session: LRSession) {
		var outError: NSError?

		let result: Bool?
		do {
			result = try sendForgotPasswordRequest(
							service: LRScreensuserService_v62(session: session))
		} catch let error as NSError {
			outError = error
			result = nil
		}

		if outError != nil {
			lastError = outError!
			resultPasswordSent = nil
		}
		else if result != nil {
			lastError = nil
			resultPasswordSent = result
		}
		else {
			lastError = NSError.errorWithCause(.InvalidServerResponse, userInfo: nil)
			resultPasswordSent = nil
		}
	}


	//MARK: Template Methods
	
	internal func sendForgotPasswordRequest(
			service service: LRScreensuserService_v62) throws
			-> Bool {
		let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)

		assertionFailure("sendForgotPasswordRequest must be overriden")

		throw error
	}

}
