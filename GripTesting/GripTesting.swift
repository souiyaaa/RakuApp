//
//  GripTesting.swift
//  GripTesting
//
//  Created by Surya on 11/06/25.
//

import XCTest
@testable import RakuApp

final class GripTesting: XCTestCase {
    
    private var viewModel: GripViewModel!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = GripViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.viewModel = nil
    }

    

    func testPredictionSuccess() throws {
        let testBundle = Bundle(for: type(of: self))
        
        guard let imageURL = testBundle.url(forResource: "badmin1", withExtension: "png"),
              let testImage = UIImage(contentsOfFile: imageURL.path) else {
            XCTFail("Test image not found or invalid.")
            return
        }

        viewModel.selectedImage = testImage
        viewModel.classifyImage()

        print("Prediction label: \(viewModel.classLabel)")
        XCTAssertFalse(viewModel.classLabel.isEmpty)
        XCTAssertNotEqual(viewModel.classLabel, "Invalid image.")
        XCTAssertNotEqual(viewModel.classLabel, "Prediction failed.")
    }
}
