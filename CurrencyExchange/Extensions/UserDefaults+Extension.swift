//
//  UserDefaults+Extension.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

//MARK: Save/Get codable data models

extension UserDefaults {
    func save<T: Encodable>(model: T, forKey key: String) throws {
        do {
            let data = try JSONEncoder().encode(model)
            set(data, forKey: key)
        } catch {
            throw error
        }
    }
    
    func getModel<T: Decodable>(forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else { return nil }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            return nil
        }
    }
}

//MARK: Reset UD.

extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
