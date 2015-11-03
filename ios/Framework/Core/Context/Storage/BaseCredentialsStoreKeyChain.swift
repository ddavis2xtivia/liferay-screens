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

#if LIFERAY_SCREENS_FRAMEWORK
	import LRMobileSDK
	import KeychainAccess
#endif

enum BaseCredentialsError: ErrorType {
    case InvalidArgument
}

public class BaseCredentialsStoreKeyChain : CredentialsStore {

	public var authentication: LRAuthentication?
	public var userAttributes: [String:AnyObject]?

	public func storeCredentials(
			session: LRSession?,
			userAttributes: [String:AnyObject]?) throws {

		if session == nil { throw BaseCredentialsError.InvalidArgument }
		if session?.authentication == nil { throw BaseCredentialsError.InvalidArgument }
		if userAttributes == nil { throw BaseCredentialsError.InvalidArgument }
		if userAttributes!.isEmpty { throw BaseCredentialsError.InvalidArgument }

		let keychain = BaseCredentialsStoreKeyChain.keychain()

		try keychain.set(String(LiferayServerContext.companyId),
				key: "companyId")
		try keychain.set(String(LiferayServerContext.groupId),
				key: "groupId")

		let userData: NSData?
		do {
			userData = try NSJSONSerialization.dataWithJSONObject(userAttributes!,
							options: NSJSONWritingOptions())
		} catch {
			userData = nil
		}

		let bundleId = NSBundle.mainBundle().bundleIdentifier ?? "liferay-screens"
		try keychain.set(userData!, key: "\(bundleId)-user")

		try storeAuth(keychain: keychain, auth: session!.authentication!)
	}

	public func removeStoredCredentials() throws {
		let keychain = BaseCredentialsStoreKeyChain.keychain()

		try keychain.removeAll()

		let userKeychain = Keychain(service: NSBundle.mainBundle().bundleIdentifier!)

		try userKeychain.removeAll()
	}

	public func loadStoredCredentials() throws -> Bool {
		let keychain = BaseCredentialsStoreKeyChain.keychain()

		let companyId = try keychain.get("companyId")
					.map { Int($0) }
					.map { Int64($0!) }
		let groupId = try keychain.get("groupId")
					.map { Int($0) }
					.map { Int64($0!) }

		if companyId != LiferayServerContext.companyId
				|| groupId != LiferayServerContext.groupId {
			return false
		}

		let bundleId = NSBundle.mainBundle().bundleIdentifier ?? "liferay-screens"
		if let userData = try keychain.getData("\(bundleId)-user") {
			let json: AnyObject? =
					try NSJSONSerialization.JSONObjectWithData(userData,
						options: NSJSONReadingOptions())

			userAttributes = json as? [String:AnyObject]
		}
		else {
			userAttributes = nil
		}

		authentication = try loadAuth(keychain: keychain)

		return (authentication != nil && userAttributes != nil)
	}

	public func storeAuth(keychain keychain: Keychain, auth: LRAuthentication) throws {
		fatalError("This method must be overriden")
	}

	public func loadAuth(keychain keychain: Keychain) throws -> LRAuthentication?  {
		fatalError("This method must be overriden")
	}

	public class func storedAuthType() throws -> AuthType? {
		if let value = try keychain().get("auth_type") {
			return AuthType(rawValue: value)
		}

		return nil
	}

	public class func keychain() -> Keychain {
		let url = NSURL(string: LiferayServerContext.server)!
		return Keychain(server: url, protocolType: .HTTPS)
	}

}
