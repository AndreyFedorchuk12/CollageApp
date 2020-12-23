//
//  WidgetImageRow.swift
//  testProject
//
//  Created by Andrey Fedorchuk on 21.12.2020.
//

import Foundation

struct WidgetImageRow: Codable, Identifiable {
    var wImageArr: [WidgetImage]
    var id: Int
}
