//
//  CALayerView.swift
//  Sudoku
//
//  Created by 江上亮 on 2022/02/02.
//

import SwiftUI

// カメラの表示画面のオブジェクトを作成
struct CALayerView: UIViewControllerRepresentable {
    // CALayerはタッチイベントを受け取ることができないが、描画を素早く行える。
    var caLayer: CALayer

    // ビューコントローラオブジェクトを作成（）
    func makeUIViewController(context: UIViewControllerRepresentableContext<CALayerView>) -> UIViewController {
        // ビューを管理するUIViewControllerのオブジェクトを作成
        let viewController = UIViewController()

        // caLayerをviewControllerのリストに追加します。
        viewController.view.layer.addSublayer(caLayer)
        
        // フレームサイズの設定
        caLayer.frame = viewController.view.layer.frame

        return viewController
    }

    // 指定されたViewControllerの状態を更新します。
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}
