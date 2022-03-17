//
//  ContentView.swift
//  AVTest
//
//  Created by Глеб Михновец on 20.01.2022.
//

import SwiftUI
import AVFoundation
import AppKit
import Combine
import CoreMedia

struct ContentView: View {

    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            MyView(captureSession: viewModel.captureSession).hueRotation(Angle(degrees: 180)).saturation(5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class MyView: NSViewRepresentable {
    
    let captureSession: AVCaptureSession
    
    init(captureSession: AVCaptureSession){
        self.captureSession = captureSession
    }
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        //https://github.com/FlexMonkey/LiveCameraFiltering/blob/master/LiveCameraFiltering/ViewController.swift
        //let filter = CIFilter(name:"CIComicEffect")!
        let filter = CIFilter(name: "CIColorPosterize", parameters: ["inputLevels" : 4])
        //let filter = CIFilter(name: "CISpotColor")
        //let filter = CIFilter(name: "CIBumpDistortion")
        //let filter = CIFilter(name: "CIColorInvert")
//        let filter = CIFilter(name: "CIToneCurve")
        layer.filters = [filter]
        view.layer = layer
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
    }
}

class ContentViewModel: ObservableObject {

    var captureSession: AVCaptureSession!

    init() {
        captureSession = AVCaptureSession()
        
        captureSession.sessionPreset = .low
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                guard captureSession.canAddInput(input) == true else {
                    return
                }
                captureSession.addInput(input)
                
                guard !captureSession.isRunning else { return }
                captureSession.startRunning()
            }
            catch {
                print("Cannot find a capture device", error.localizedDescription)
            }
        }
    }

}



