//
//  PhotoPicker.swift
//
//  Created by Andrey Fedorchuk on 21.12.2020.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(phot1: self)
    }
    
    @Binding var photos: [UIImage?]
    @Binding var showPicker: Bool
    //@Binding var pictures: [WidgetImageRow]
    let cw: ContentView
    let widgetMask: [[Int]]
    let imageCount: Int
    
    
    var any = PHPickerConfiguration(photoLibrary: .shared())
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configu = PHPickerConfiguration()
        configu.filter = .images
        configu.selectionLimit = imageCount
        
        let picker = PHPickerViewController(configuration: configu)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var phot: PhotoPicker
        init(phot1: PhotoPicker) {
            phot = phot1
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            self.phot.showPicker.toggle()
            self.phot.photos = []
            for photo in results {
                if photo.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    photo.itemProvider.loadObject(ofClass: UIImage.self) { (imagen, err) in
                        guard let photo1 = imagen else {
                            print("\(String(describing: err?.localizedDescription))")
                            return
                        }
                        DispatchQueue.main.async {
                            self.phot.photos.append(photo1 as? UIImage)
                            self.phot.cw.updatePicturesArray(self.phot.cw.widgetMask)
                        }
                    }
                } else {
                    print("No photos was loaded")
                }
            }
        }
    }
}
