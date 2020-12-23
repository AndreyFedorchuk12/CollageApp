//
//  ContentView.swift
//
//  Created by Andrey Fedorchuk on 21.12.2020.
//

import SwiftUI
import PhotosUI
import WidgetKit

struct ContentView: View {
    
    @AppStorage("collage", store: UserDefaults(suiteName: "group.com.andreyfedorchuk.PhotoCollage"))
    var collageData: Data = Data()
    
    @State var imageCount = 3
    
    @State var pictures = [ WidgetImageRow(wImageArr: [WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 0)],  id: 0),
         WidgetImageRow(wImageArr: [WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 1), WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 2)],  id: 1)
    ]
    
    @State var collage = CollageModel(wImageArr: [ WidgetImageRow(wImageArr: [WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 0)],  id: 0),
        WidgetImageRow(wImageArr: [WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 1), WidgetImage(widgetImage: UIImage(named: "imagePlaceholder"), id: 2)],  id: 1)
      ], id: 0)
    
    @State var shouldHideMenuButtons = false
    @State var shouldHideLayoutButtons = true
    @State var shouldHidePhotoButtons = true
    @State var widgetMask: [[Int]] = [[0, 0], [1, 1]]
    
    @State var photo: [UIImage?] = []
    @State var showPicker = false
    @State var any = PHPickerConfiguration()
    
    func save() {
        guard let collageData = try? JSONEncoder().encode(collage) else {return}
        self.collageData = collageData
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func updatePicturesArray(_ inputMask: [[Int]]) {
        var photoIndex: Int = 0
        for mask in inputMask {
            self.pictures[mask[0]].wImageArr = []
            if mask[1] >= 0 {
                for _ in 0...mask[1] {
                    self.pictures[mask[0]].wImageArr.append(WidgetImage(widgetImage: photo.indices.contains(photoIndex) ? photo[photoIndex] : UIImage(named: "imagePlaceholder"), id: photoIndex))
                    photoIndex += 1
                }
            }
        }
        self.collage.wImageArr = self.pictures
        save()
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.darkGray).ignoresSafeArea()
                VStack {
                    
                    // widget
                    RoundedRectangle(cornerRadius: 20.0)
                        .foregroundColor(.gray)
                        .aspectRatio(1, contentMode: .fit)
                        .padding()
                        .overlay(
                            ForEach(pictures) { pictureRow in
                                WidgetView(wImageRow: pictureRow.wImageArr)
                            }
                        )
                    Spacer()
                    
                    // bottom navigator
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.gray)
                            .ignoresSafeArea()
                            .frame(height: 200, alignment: .bottom)
                            .overlay(
                                ZStack {
                                    // layout
                                    VStack {
                                        HStack {
                                            Button(action: {
                                                updatePicturesArray([[0, 0], [1, 1]])
                                                self.widgetMask = [[0, 0], [1, 1]]
                                                self.imageCount = 3
                                            }) {
                                                Text("Layout 1")
                                                    .foregroundColor(.white)
                                            }
                                            .opacity(shouldHideLayoutButtons ? 0 : 1)
                                            
                                            Button(action: {
                                                updatePicturesArray([[0, 1], [1, -1]])
                                                self.widgetMask = [[0, 1], [1, -1]]
                                                self.imageCount = 2
                                            }) {
                                                Text("Layout 2")
                                                    .foregroundColor(.white)
                                            }
                                            .opacity(shouldHideLayoutButtons ? 0 : 1)
                                            
                                            Button(action: {
                                                updatePicturesArray([[0, 0], [1, 0]])
                                                self.widgetMask = [[0, 0], [1, 0]]
                                                self.imageCount = 2
                                            }) {
                                                Text("Layout 3")
                                                    .foregroundColor(.white)
                                            }
                                            .opacity(shouldHideLayoutButtons ? 0 : 1)
                                            
                                            Button(action: {
                                                updatePicturesArray([[0, 1], [1, 1]])
                                                self.widgetMask = [[0, 1], [1, 1]]
                                                self.imageCount = 4
                                            }) {
                                                Text("Layout 4")
                                                    .foregroundColor(.white)
                                            }
                                            .opacity(shouldHideLayoutButtons ? 0 : 1)
                                            
                                        }
                                        Divider().opacity(shouldHideLayoutButtons ? 0 : 1)
                                        HStack(spacing: 150) {
                                            Text("Layout").opacity(shouldHideLayoutButtons ? 0 : 1)
                                            Button(action: {
                                                shouldHideMenuButtons = false
                                                shouldHideLayoutButtons = true
                                            }) {
                                                Text("Close")
                                                    .foregroundColor(.white)
                                            }
                                            .opacity(shouldHideLayoutButtons ? 0 : 1)
                                        }
                                    }
                                    
                                    // photos
                                    
                                    VStack {
                                        HStack {
                                            ForEach(pictures) { picture in
                                                ForEach(picture.wImageArr) { pictureImage in
                                                    Button(action: {
                                                        self.showPicker.toggle()
                                                        self.any.filter = .images
                                                    }) {
                                                        Image(uiImage: UIImage(data: pictureImage.widgetImage)!)
                                                            .resizable()
                                                            .aspectRatio(1, contentMode: .fit)
                                                            .frame(width: 70, height: 70)
                                                            .cornerRadius(10)
                                                    }
                                                    .opacity(shouldHidePhotoButtons ? 0 : 1)
                                                }
                                            }
                                        }
                                        Divider().opacity(shouldHidePhotoButtons ? 0 : 1)
                                        HStack(spacing: 150) {
                                            Text("Photos")
                                                .opacity(shouldHidePhotoButtons ? 0 : 1)
                                            Button(action: {
                                                shouldHideMenuButtons = false
                                                shouldHidePhotoButtons = true
                                            }) {
                                                Text("Close")
                                                    .foregroundColor(.white)
                                            }
                                            .opacity(shouldHidePhotoButtons ? 0 : 1)
                                        }
                                    }
                                }
                            )
                        HStack(spacing: 80) {
                            Button(action: {
                                shouldHideMenuButtons = true
                                shouldHideLayoutButtons = false
                            }) {
                                Image(systemName: "rectangle.split.2x2")
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            .opacity(shouldHideMenuButtons ? 0 : 1)
                            
                            Button(action: {
                                shouldHideMenuButtons = true
                                shouldHidePhotoButtons = false
                            }) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            .opacity(shouldHideMenuButtons ? 0 : 1)
                        }
                    }.sheet(isPresented: self.$showPicker) {
                        PhotoPicker(photos: self.$photo, showPicker: $showPicker, cw: self, widgetMask: self.widgetMask, imageCount: self.imageCount)
                }
            }
            }.navigationBarTitle("Widget")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
