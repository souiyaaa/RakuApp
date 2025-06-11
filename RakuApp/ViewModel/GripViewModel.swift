import Foundation
import CoreML
import SwiftUI
import PhotosUI
import UIKit

class GripViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var classLabel: String = ""

    private var imageClassifier: BadmintonGrip?

    init() {
        do {
            imageClassifier = try BadmintonGrip(configuration: MLModelConfiguration())
        } catch {
            print("Failed to load model: \(error)")
            
        }
    }

    func classifyImage() {
        guard let selectedImage = selectedImage,
              let pixelBuffer = selectedImage.toCVPixelBuffer() else {
            classLabel = "Invalid image."
            return
        }

        do {
            let prediction = try imageClassifier?.prediction(image: pixelBuffer)
            classLabel = prediction?.target ?? "Unknown"
        } catch {
            print("Prediction error: \(error)")
            classLabel = "Prediction failed."
        }
    }
}
