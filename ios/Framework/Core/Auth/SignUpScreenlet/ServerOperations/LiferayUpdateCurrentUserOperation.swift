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


public class LiferayUpdateCurrentUserOperation: ServerOperation {

	public var resultUserAttributes: [String:AnyObject]?

	override public  var hudLoadingMessage: HUDMessage? {
		return (LocalizedString("signup-screenlet", key: "saving-message", obj: self),
				details: LocalizedString("signup-screenlet", key: "saving-details", obj: self))
	}
	override public var hudFailureMessage: HUDMessage? {
		return (LocalizedString("signup-screenlet", key: "saving-error", obj: self), details: nil)
	}

	private var viewModel: SignUpViewModel {
		return screenlet.screenletView as! SignUpViewModel
	}


	//MARK: ServerOperation

	override func validateData() -> Bool {
		let valid = super.validateData()

		if valid && viewModel.emailAddress == nil {
			showValidationHUD(message: LocalizedString("signup-screenlet", key: "validation", obj: self))

			return false
		}

		if viewModel.password == SessionContext.currentBasicPassword {
			showValidationHUD(message: LocalizedString("signup-screenlet", key: "validation-password", obj: self))

			return false
		}

		return true
	}

	override func doRun(session session: LRSession) {
		func attributeAsString(key: String) -> String {
			return SessionContext.userAttribute(key) as! String
		}

		func attributeAsId(key: String) -> Int64 {
			return Int64(SessionContext.userAttribute(key) as! Int)
		}


		let service = LRUserService_v62(session: session)

		var outError: NSError?

		//FIXME 
		// Values marked with (!!) will be overwritten in the server
		// The JSON WS API isn't able to handle this scenario correctly
		let result: [NSObject: AnyObject]!
		do {
			result = try service.updateUserWithUserId(attributeAsId("userId"),
							oldPassword: SessionContext.currentBasicPassword,
							newPassword1: viewModel.password ?? "",
							newPassword2: viewModel.password ?? "",
							passwordReset: false,
							reminderQueryQuestion: attributeAsString("reminderQueryQuestion"),
							reminderQueryAnswer: "", // (!!)
							screenName: attributeAsString("screenName"),
							emailAddress: viewModel.emailAddress,
							facebookId: attributeAsId("facebookId"),
							openId: attributeAsString("openId"),
							languageId: attributeAsString("languageId"),
							timeZoneId: attributeAsString("timeZoneId"),
							greeting: attributeAsString("greeting"),
							comments: attributeAsString("comments"),
							firstName: viewModel.firstName ?? "",
							middleName: viewModel.middleName ?? "",
							lastName: viewModel.lastName ?? "",
							prefixId: 0, 		// (!!)
							suffixId: 0, 		// (!!)
							male: true, 		// (!!)
							birthdayMonth: 1, 	// (!!)
							birthdayDay: 1, 	// (!!)
							birthdayYear: 1970, // (!!)
							smsSn: "", 			// (!!)
							aimSn: "", 			// (!!)
							facebookSn: "", 	// (!!)
							icqSn: "", 			// (!!)
							jabberSn: "", 		// (!!)
							msnSn: "", 			// (!!)
							mySpaceSn: "", 		// (!!)
							skypeSn: "", 		// (!!)
							twitterSn: "", 		// (!!)
							ymSn: "", 			// (!!)
							jobTitle: viewModel.jobTitle ?? "",
							groupIds: [NSNumber(longLong: LiferayServerContext.groupId)],
							organizationIds: [AnyObject](),
							roleIds: [AnyObject](),
							userGroupRoles: [AnyObject](),
							userGroupIds: [AnyObject](),
							serviceContext: nil)
		} catch let error as NSError {
			outError = error
			result = nil
		}

		if outError != nil {
			lastError = outError!
			resultUserAttributes = nil
		}
		else if result?["userId"] == nil {
			lastError = NSError.errorWithCause(.InvalidServerResponse, userInfo: nil)
			resultUserAttributes = nil
		}
		else {
			lastError = nil
			resultUserAttributes = result as? [String:AnyObject]
		}
	}

}
