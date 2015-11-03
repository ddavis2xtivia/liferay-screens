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

public class LiferayAssetListPageOperation: LiferayPaginationOperation {

	public var groupId: Int64?
	public var classNameId: Int64?
	public var portletItemName: String?


	//MARK: ServerOperation

	override public func validateData() -> ValidationError? {
		let error = super.validateData()

		if error == nil {
			if groupId == nil {
				return ValidationError("assetlist-screenlet", "undefined-group")
			}

			if classNameId == nil {
				return ValidationError("assetlist-screenlet", "undefined-classname")
			}
		}

		return error
	}

	override public func doRun(session session: LRSession) {
		if let portletItemName = portletItemName {
			let service = LRScreensassetentryService_v62(session: session)

            do {
			let responses = try service.getAssetEntriesWithCompanyId(LiferayServerContext.companyId,
				groupId: groupId!,
				portletItemName: portletItemName,
				locale: NSLocale.currentLocaleString)
                if let entriesResponse = responses as? [[String:AnyObject]] {
                    let serverPageContent = entriesResponse

                    resultPageContent = serverPageContent
                    resultRowCount = serverPageContent.count
                }
                else {
                    throw NSError.errorWithCause(.InvalidServerResponse, userInfo: nil)
                }
            } catch {
                lastError = error as NSError
            }
		}
		else {
			super.doRun(session: session)
		}
	}

	//MARK: LiferayPaginationOperation

	override internal func doGetPageRowsOperation(session session: LRBatchSession, startRow: Int, endRow: Int) {
		let service = LRScreensassetentryService_v62(session: session)

        do {
            if let portletItemName = portletItemName {
                try service.getAssetEntriesWithCompanyId(LiferayServerContext.companyId,
                    groupId: groupId!,
                    portletItemName: portletItemName,
                    locale: NSLocale.currentLocaleString)
            }
            else {
                var entryQueryAttributes = configureEntryQueryAttributes()

                entryQueryAttributes["start"] = startRow
                entryQueryAttributes["end"] = endRow

                let entryQuery = LRJSONObjectWrapper(JSONObject: entryQueryAttributes)

                try service.getAssetEntriesWithAssetEntryQuery(entryQuery,
                    locale: NSLocale.currentLocaleString)
            }
        } catch {
            lastError = error as NSError
        }
	}

	override internal func doGetRowCountOperation(session session: LRBatchSession) {
		let service = LRAssetEntryService_v62(session: session)
		let entryQueryAttributes = configureEntryQueryAttributes()
		let entryQuery = LRJSONObjectWrapper(JSONObject: entryQueryAttributes)

        do {
            try service.getEntriesCountWithEntryQuery(entryQuery)
        } catch {
            lastError = error as NSError
        }
	}


	//MARK: Private methods

	private func configureEntryQueryAttributes() -> [NSString : AnyObject] {
		var entryQueryAttributes: [NSString : AnyObject] = [:]

		entryQueryAttributes["classNameIds"] = NSNumber(longLong: classNameId!)
		entryQueryAttributes["groupIds"] = NSNumber(longLong: groupId!)
		entryQueryAttributes["visible"] = "true"

		return entryQueryAttributes
	}

}
