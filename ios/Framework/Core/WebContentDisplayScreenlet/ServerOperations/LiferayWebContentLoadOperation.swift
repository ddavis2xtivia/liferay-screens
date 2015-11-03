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
	public var templateId: Int64?

	public var resultHTML: String?


	//MARK: ServerOperation

	override public func validateData() -> ValidationError? {
		let error = super.validateData()

		if error == nil {
			if groupId == nil {
				return ValidationError("webcontentdisplay-screenlet", "undefined-group")
			}

			if (articleId ?? "") == "" {
				return ValidationError("webcontentdisplay-screenlet", "undefined-article")
			}
		}

		return error
	}

	override public func doRun(session session: LRSession) {
		var result:String

        do {
            if templateId != nil {
                let service = LRScreensjournalarticleService_v62(session: session)
                
                result = try service.getJournalArticleContentWithGroupId(groupId!,
                    articleId: articleId!,
                    templateId: templateId!,
                    locale: NSLocale.currentLocaleString)
            }
            else {
                let service = LRJournalArticleService_v62(session: session)
                
                result = try service.getArticleContentWithGroupId(groupId!,
                    articleId: articleId!,
                    languageId: NSLocale.currentLocaleString,
                    themeDisplay: nil)
            }
            
            resultHTML = result
        } catch {
            resultHTML = nil
        }
	}

}
