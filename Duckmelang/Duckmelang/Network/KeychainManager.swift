//
//  KeychainManager.swift
//  Duckmelang
//
//  Created by 김연우 on 2/20/25.
//

import Security
import Foundation

final class KeychainManager {
    
    static let shared = KeychainManager()
    private init() {}
    
    func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // 기존 값이 있다면 삭제
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("✅ Keychain 저장 성공: \(key) → \(value.prefix(10))...")
        } else {
            print("❌ Keychain 저장 실패: \(key) (에러 코드: \(status))")
        }
    }
    
    func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        print("⚠️ Keychain에서 \(key) 찾기 실패 (에러 코드: \(status))")
        return nil
    }
    
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("✅ Keychain에서 \(key) 삭제 성공")
        } else {
            print("⚠️ Keychain에서 \(key) 삭제 실패 (에러 코드: \(status))")
        }
    }
}


//MARK: - token사용법
//아래처럼 keychainManager을 가지고있는 TokenPlugin()을 이용하면 된다~~
//lazy var provider: MoyaProvider<[사용하는 api]> = {
//    return MoyaProvider<LoginAPI>(plugins: [TokenPlugin(),[사용하는 loggerPlugin]])
//}()
