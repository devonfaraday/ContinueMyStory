//
//  Keychain.swift
//  ContinueMyStory
//
//  Created by Christian McMullin on 10/11/17.
//  Copyright © 2017 Christian McMullin. All rights reserved.
//

import Foundation

struct Keychain {
    
    // MARK: Types
    
    private enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    
    // MARK: Properties
    
    private(set) var account: String
    private let accessGroup: String?
    
    // MARK: Intialization
    
    init(account: String, accessGroup: String? = nil) {
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain access
    
    func readPassword() throws -> String  {
        // Build a query to find the item that matches the service, account and access group.
        var query = Keychain.keychainQuery(withService: .appServiceID, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        return password
    }
    
    func savePassword(_ password: String) throws {
        // Encode the password into an Data object.
        guard let encodedPassword = password.data(using: .utf8) else { fatalError("Could not encode password") }
        do {
            // Check for an existing item in the keychain.
            try _ = readPassword()
            // Update the existing item with the new password.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            let query = Keychain.keychainQuery(withService: .appServiceID, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        } catch KeychainError.noPassword {
            /*
             No password was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = Keychain.keychainQuery(withService: .appServiceID, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    mutating func renameAccount(_ newAccountName: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        let query = Keychain.keychainQuery(withService: .appServiceID, account: self.account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
        self.account = newAccountName
    }
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = Keychain.keychainQuery(withService: .appServiceID, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    static func passwordItems(forService service: String, accessGroup: String? = nil) throws -> [Keychain] {
        // Build a query for all items that match the service and access group.
        var query = Keychain.keychainQuery(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse
        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }
        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String : AnyObject]] else { throw KeychainError.unexpectedItemData }
        // Create a `KeychainInterface` for each dictionary in the query result.
        var passwordItems = [Keychain]()
        for result in resultData {
            guard let account  = result[kSecAttrAccount as String] as? String else { throw KeychainError.unexpectedItemData }
            let passwordItem = Keychain(account: account, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }
        return passwordItems
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }
}

//Usage drop in a viewDidLoad to see functionality
/*
 let email = Keychain(account: .emailAccountKey)
 let password = Keychain(account: .passwordAccountKey)
 let authToken = Keychain(account: .authTokenAccountKey)
 
 do {
 try email.savePassword("test@email.com")
 try password.savePassword("testPassword")
 try authToken.savePassword("Q3nT40^%xISx-Q3W1FvTntqkHj&Ll1&%_)LhZjI0!rM#$1Dj)o7Zqzvf$s$73g_o")
 try print(email.readPassword())
 try print(password.readPassword())
 try print(authToken.readPassword())
 try email.deleteItem()
 try password.deleteItem()
 try authToken.deleteItem()
 try print(email.readPassword())
 try print(password.readPassword())
 try print(authToken.readPassword())
 }
 catch {
 print("error with keychain item")
 }
 */
