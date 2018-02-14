//
//  ViewController.swift
//  EasyQR
//
//  Created by Jonathan Duarte on 11/02/2018.
//  Copyright © 2018 Jonathan Duarte. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubview(toFront: image)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    
        if metadataObjects.count > 0 {
            let object = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if object.type == AVMetadataObject.ObjectType.qr {
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                    UIPasteboard.general.string = object.stringValue
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

