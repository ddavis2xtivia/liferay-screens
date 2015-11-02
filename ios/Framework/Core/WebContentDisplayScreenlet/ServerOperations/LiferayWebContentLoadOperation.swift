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


public class LiferayWebContentLoadOperation: ServerOperation {

	public var groupId: Int64?
	public var articleId: String?

	public var resultHTML: String?


	override public var hudLoadingMessage: HUDMessage? {
		return (LocalizedString("webcontentdisplay-screenlet", key: "loading-message", obj: self),
				details: LocalizedString("webcontentdisplay-screenlet", key: "loading-details", obj: self))
	}
	override public var hudFailureMessage: HUDMessage? {
		return (LocalizedString("webcontentdisplay-screenlet", key: "loading-error", obj: self), details: nil)
	}


	//MARK: ServerOperation

	override func validateData() -> Bool {
		var valid = super.validateData()

		valid = valid && (groupId != nil)
		valid = valid && (articleId != nil && articleId! != "")

		return valid
	}

	override internal func doRun(session session: LRSession) {
		let service = LRJournalArticleService_v62(session: session)

		resultHTML = nil

		let result: String!
		do {
			result = try service.getArticleContentWithGroupId(groupId!,
							articleId: articleId!,
							languageId: NSLocale.currentLocaleString,
							themeDisplay: nil)
		} catch let error as NSError {
			lastError = error
			result = nil
		}

		if lastError == nil {
			resultHTML = result
		}
	}

}