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


public class LiferayDDLFormRecordLoadOperation: ServerOperation {

	public var recordId: Int64?

	public var resultRecord: [String:AnyObject]?
	public var resultRecordId: Int64?


	override public var hudLoadingMessage: HUDMessage? {
		return (LocalizedString("ddlform-screenlet", key: "loading-record-message", obj: self),
				details: LocalizedString("ddlform-screenlet", key: "loading-record-details", obj: self))
	}
	override public var hudFailureMessage: HUDMessage? {
		return (LocalizedString("ddlform-screenlet", key: "loading-record-error", obj: self), details: nil)
	}


	//MARK: ServerOperation

	override func validateData() -> Bool {
		var valid = super.validateData()

		valid = valid && (recordId != nil)

		return valid
	}

	override internal func doRun(session session: LRSession) {
		let service = LRScreensddlrecordService_v62(session: session)

		resultRecord = nil
		resultRecordId = nil

		let recordDictionary: [NSObject: AnyObject]!
		do {
			recordDictionary = try service.getDdlRecordWithDdlRecordId(recordId!,
							locale: NSLocale.currentLocaleString)
		} catch let error as NSError {
			lastError = error
			recordDictionary = nil
		}

		if lastError == nil {
			if recordDictionary is [String:AnyObject] {
				resultRecord = recordDictionary as? [String:AnyObject]
				resultRecordId = self.recordId!
			}
			else {
				lastError = NSError.errorWithCause(.InvalidServerResponse)
			}
		}
	}

}
