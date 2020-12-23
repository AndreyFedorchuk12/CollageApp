//
//  PhotoCollageWidget.swift
//  PhotoCollageWidget
//
//  Created by Andrey Fedorchuk on 22.12.2020.
//

import WidgetKit
import SwiftUI

struct CollageEntry: TimelineEntry {
    let date: Date = Date()
    let collage: CollageModel
}

struct Provider: TimelineProvider {
    
    @AppStorage("collage", store: UserDefaults(suiteName: "group.com.andreyfedorchuk.PhotoCollage"))
    var collageData: Data = Data()


    func placeholder(in context: Context) -> CollageEntry {
        guard let collage = (try? JSONDecoder().decode(CollageModel.self, from: collageData)) else {
            return CollageEntry(collage: CollageModel(wImageArr: [ WidgetImageRow(wImageArr: [WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 1)],  id: 1),
               WidgetImageRow(wImageArr: [WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 2), WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 3)],  id: 2)
             ], id: 1))
        }
        return CollageEntry(collage: collage)
    }

    func getSnapshot(in context: Context, completion: @escaping (CollageEntry) -> Void) {
        guard let collage = try? JSONDecoder().decode(CollageModel.self, from: collageData) else {return}
        let entry = CollageEntry(collage: collage)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CollageEntry>) -> Void) {
        guard let collage = try? JSONDecoder().decode(CollageModel.self, from: collageData) else {return}
        let entry = CollageEntry(collage: collage)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct PlaceholderView: View {
    let entry: Provider.Entry

    var body: some View {
        ZStack {
                Color(.gray)
                ForEach(entry.collage.wImageArr) { pictureRow in
                    WidgetView(wImageRow: pictureRow.wImageArr)
                }
        }
    }
}

struct WidgetEntryView: View {
    let entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemMedium:
            ZStack {
                Color(.gray)
                ForEach(entry.collage.wImageArr) { pictureRow in
                    WidgetView(wImageRow: pictureRow.wImageArr)
                }
            }
            
        default:
            ZStack {
                Color(.gray)
                ForEach(entry.collage.wImageArr) { pictureRow in
                    WidgetView(wImageRow: pictureRow.wImageArr)
                }
            }
        }
    }
}

@main
struct PhotoCollageWidget: Widget {
    private let kind: String = "PhotoCollageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
