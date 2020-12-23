//
//  File.swift
//  testProject
//
//  Created by Andrey Fedorchuk on 21.12.2020.
//

import Foundation
import UIKit

struct WidgetImage: Identifiable, Codable {
    let widgetImage: Data
    var id: Int
    
    public init(widgetImage: UIImage?, id: Int) {
        if let safeImageData = widgetImage?.pngData() {
            self.widgetImage = safeImageData
        } else {
            self.widgetImage = Data()
        }
        self.id = id
    }
}
