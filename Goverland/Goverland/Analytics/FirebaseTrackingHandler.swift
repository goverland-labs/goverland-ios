//
//  FirebaseTrackingHandler.swift
//  Goverland
//
//  Created by Andrey Scherbovich on 13.07.23.
//

import Foundation
import FirebaseAnalytics
import Firebase

final class FirebaseTrackingHandler: TrackingHandler {
    private let nameLengthRange = (1...40)
    private let nameBodyCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
    private let nameHeadCharacterSet = CharacterSet.letters
    private let stringParameterLengthRange = (1...100)
    private let propertyNameLengthRange = (1...24)
    private let propertyValueLengthRange = (0...36)

    func track(event: String, parameters: [String: Any]?) {
        check(name: event)

        if let parameters = parameters {
            for (name, value) in parameters {
                check(name: name)
                assert(value as? NSString != nil || value as? NSNumber != nil,
                       "Event parameter value \(value) for key \(name) is of unsupported type: \(type(of: value))")

                if let stringValue = value as? NSString {
                    assert(stringParameterLengthRange.contains(stringValue.length),
                           "Event parameter value \(stringValue) for key \(name) is too long: \(stringValue.length)")
                }
            }
        }
        Analytics.logEvent(event, parameters: parameters)
    }

    func setUserProperty(_ value: String, for property: UserProperty) {
        assert(propertyNameLengthRange.contains(property.rawValue.count), "wrong property name length")
        assert(propertyValueLengthRange.contains(value.count), "wrong property value length")

        Analytics.setUserProperty(value, forName: property.rawValue)
    }

    func setTrackingEnabled(_ value: Bool) {
        Analytics.setAnalyticsCollectionEnabled(value)
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(value)
    }

    private func check(name: String) {
        assert(nameLengthRange.contains(name.count), "name length is \(name.count)")
        assert(name.rangeOfCharacter(from: nameBodyCharacterSet.inverted) == nil,
               "name contains forbidden characters: \(name)")
        assert(String(name.first!).rangeOfCharacter(from: nameHeadCharacterSet.inverted) == nil,
               "name starts with forbidden character: \(name)")
    }
}
