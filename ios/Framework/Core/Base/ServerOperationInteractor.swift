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

public class ServerOperationInteractor: Interactor {

	public var cacheStrategy = CacheStrategyType.RemoteFirst

	public var currentOperation: ServerOperation?


	override public func start() -> Bool {
		self.currentOperation = createOperation()

		if let currentOperation = self.currentOperation {
			getCacheStrategyImpl(cacheStrategy)(
				currentOperation,
				whenSuccess: {
					self.completedOperation(currentOperation)
					self.callOnSuccess()
				},
				whenFailure: { err in
					currentOperation.lastError = err
					self.completedOperation(currentOperation)
					self.callOnFailure(err)
				})

			return true
		}

		self.callOnFailure(NSError.errorWithCause(.AbortedDueToPreconditions))

		return false
	}

	override public func cancel() {
		currentOperation?.cancel()
		cancelled = true
	}


	public func createOperation() -> ServerOperation? {
		return nil
	}

	public func completedOperation(op: ServerOperation) {
	}

	override public func callOnSuccess() {
		super.callOnSuccess()
		currentOperation = nil
	}

	override public func callOnFailure(error: NSError) {
		super.callOnFailure(error)
		currentOperation = nil
	}

	public func readFromCache(op: ServerOperation, result: AnyObject? -> Void) {
		result(nil)
	}

	public func writeToCache(op: ServerOperation) {
	}

	public func getCacheStrategyImpl(strategyType: CacheStrategyType) -> CacheStrategy {
		return defaultStrategyRemote
	}
		if let operation = createOperation() {
			result = operation.validateAndEnqueue() {
				self.completedOperation(operation)

				if let error = $0.lastError {
					self.callOnFailure(error)
				}
				else {
					self.callOnSuccess()
				}
			}
		}
		else {
			self.callOnFailure(NSError.errorWithCause(.AbortedDueToPreconditions))
		}

		return result
	}


	public func createOperation() -> ServerOperation? {
		return nil
	}

	public func completedOperation(op: ServerOperation) {
	}

}
