//
//  WidgetView.swift
//
//  Created by Andrey Fedorchuk on 21.12.2020.
//

import SwiftUI

struct WidgetView: View {
    
    let wImageRow: [WidgetImage]
    
    var body: some View {
            HStack() {
                ForEach(wImageRow) { image in
                    Image(uiImage: UIImage(data: image.widgetImage)!)
                        .resizable()
                        .cornerRadius(10)
                }
            }
            .padding()
    }
}
