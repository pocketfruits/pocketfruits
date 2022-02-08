//
//  AVFoundationVM.swift
//  Sudoku
//
//  Created by 江上亮 on 2022/02/02.
//

import UIKit
import Combine
import AVFoundation

// カメラ映像のオブジェクト
class AVFoundationVM: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    // 撮影した画像
    @Published var image: UIImage?
    
    // プレビュー用レイヤー
    var previewLayer: CALayer!

    // 撮影開始フラグ
    private var _takePhoto:Bool = false
    
    // 入力（カメラ映像）をデータとして取り込み、出力データとして画面に表示するための管理セッション
    private let captureSession = AVCaptureSession()
    
    // 撮影デバイスの制御を行うオブジェクト
    private var capturepDevice: AVCaptureDevice!

    override init() {
        super.init()

        prepareCamera()
        beginSession()
    }

    // 写真撮影ボタンの処理
    func takePhoto() {
        _takePhoto = true
    }

    // カメラ起動時の設定（出力品質、デバイスとしてカメラの使用、手段としてビデオの使用、背面カメラの使用）
    private func prepareCamera() {
        // 出力の品質レベルを設定（高解像度の写真品質出力に適したキャプチャ設定）
        captureSession.sessionPreset = .photo

        // builtInWideAngleCamera]：内蔵広角カメラ。　AVMediaType.video：写真であってもvideoを指定。
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            capturepDevice = availableDevice
        }
    }

    private func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)

            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer

        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]

        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }

        captureSession.commitConfiguration()

        let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }

    //
    func startSession() {
        // 受信機が実行されているかどうかを確認
        if captureSession.isRunning { return }
        
        // 入力から出力へのデータのフローを開始する
        captureSession.startRunning()
    }

    func endSession() {
        if !captureSession.isRunning { return }
        captureSession.stopRunning()
    }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if _takePhoto {
            _takePhoto = false
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }

    private func getImageFromSampleBuffer (buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()

            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))

            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }

        return nil
    }
}
