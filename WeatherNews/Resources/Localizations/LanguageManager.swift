//
//  LanguageManager.swift
//  WeatherNews
//
//  Created by Macos on 11/01/2026.
//

import Foundation
import SwiftUI
import Combine
import ObjectiveC



@MainActor
class LanguageManager: ObservableObject {
    @Published var currentLanguage: AppLanguage

    init() {
        let saved = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        currentLanguage = AppLanguage(rawValue: saved) ?? .english
        Bundle.setLanguage(currentLanguage.rawValue)
    }

    func setLanguage(_ language: AppLanguage) {
        guard language != currentLanguage else { return }

        UserDefaults.standard.set(language.rawValue, forKey: "appLanguage")
        Bundle.setLanguage(language.rawValue)

        currentLanguage = language
    }
}



private var bundleKey: UInt8 = 0

extension Bundle {
    static func setLanguage(_ language: String) {
        // Override main bundle class
        object_setClass(Bundle.main, PrivateBundle.self)
        objc_setAssociatedObject(Bundle.main, &bundleKey, language, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    private class PrivateBundle: Bundle {
        override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
            let language = objc_getAssociatedObject(self, &bundleKey) as? String ?? "en"
            guard let path = self.path(forResource: language, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                return super.localizedString(forKey: key, value: value, table: tableName)
            }
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
