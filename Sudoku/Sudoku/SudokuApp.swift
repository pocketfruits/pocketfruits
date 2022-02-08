//
//  SudokuApp.swift
//  Sudoku
//
//  Created by 江上亮 on 2021/11/28.
//

import SwiftUI

@main
struct SudokuApp: App {
    // アプリ起動時に初期化するのに必要
    @UIApplicationDelegateAdaptor(SetValuesBeforeAppStart.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TopView()
        }
    }
}


// アプリ起動時に共有したい変数を定義
class SetValuesBeforeAppStart: NSObject, UIApplicationDelegate, ObservableObject {
    // 枠の上のボタンとメッセージの表示領域の高さ
    @Published var messageAreaHeight: CGFloat = CGFloat(((floor(UIScreen.main.bounds.width / 90) * 10) * 4) - 20)
    
    // 枠１つのサイズ
    @Published var borderSize: CGFloat = CGFloat(floor(UIScreen.main.bounds.width / 90) * 10)
    
    // 画像の座標(Geometryreaderで割り出してもいいけど、アプリを読み込んだ時点で算出する方がいちいち計算しなくてもいい。)
    @Published var picturePositionX: CGFloat = CGFloat(UIScreen.main.bounds.width - CGFloat(floor(UIScreen.main.bounds.width / 90) * 10) * 9) / 2
    @Published var picturePositionY: CGFloat = CGFloat(((floor(UIScreen.main.bounds.width / 90) * 10) * 4) - 20)
    @Published var pictureHeightWidth: CGFloat = CGFloat(floor(UIScreen.main.bounds.width / 90) * 10) * 9
    
    // 画像解析画面のみで使用する変数
    @Published var currentStateForTopView: String = "解析前"
    @Published var errorMessageForTopView: String = ""
    
    // 手入力画面のみで使用する変数
    @Published var currentStateForInputView: String    = "解析前"
    @Published var errorMessageForInputView: String    = ""
    @Published var currentNumsForInputView: [[String]] = UserFunctions.MakeInitNums()
    @Published var initNumsForInputView: [[String]]    = UserFunctions.MakeInitNums()
    
    // 解析処理オブジェクト
    @Published var errorCheck: ErrorCheck = ErrorCheck()
    @Published var analyze: Analyze       = Analyze()
}
