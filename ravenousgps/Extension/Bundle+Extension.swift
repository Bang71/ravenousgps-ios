//
//  Bundle+Extension.swift
//  ravenousgps
//
//  Created by 신병기 on 4/15/24.
//

import Foundation

extension Bundle {
    var googleMapsApiKey: String {
        return infoDictionary?["GOOGLE_MAPS_API_KEY"] as! String
    }
}
