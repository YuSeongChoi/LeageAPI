//
//  Extension.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/03.
//

import Foundation

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}

extension Encodable {
    var toData: Data? {
        guard let data: Data = try? JSONEncoder().encode(self) else { return nil }
        return data
    }
}

extension String {
    // percent encode by encoding except alphanumeric + unreserved special character(-._-/?)
    func addingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}
