//
//  ContentView.swift
//  Sudoku
//
//  Created by 江上亮 on 2021/11/28.
//

import AVFoundation
import SwiftUI

struct TopView: View {
    // アプリ起動時に初期化した値を取得するのに使用するオブジェクト
    @EnvironmentObject var setValuesBeforeAppStart: SetValuesBeforeAppStart
    
    // カメラ画像設定オブジェクト
    @ObservedObject private var avFoundationVM = AVFoundationVM()
    
    // 左上の画像座標
    @State var leftTopXPoint: CGFloat = 0
    @State var leftTopYPoint: CGFloat = 0
    
    // 右下の画像座標
    @State var rightBottomXPoint: CGFloat = 0
    @State var rightBottomYPoint: CGFloat = 0
    
    // 右下の画像座標
    @State var rightBottomXYPoint: CGFloat = 0

    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                // 画像がない時の処理
                if avFoundationVM.image == nil {
                    // カメラ画面
                    CameraView
                    
                // 撮影画像がある時の処理
                } else {
                    // 撮影画像画面
                    PhotoView
                }
            }.background(Color.white)
        }
    }
    
    // カメラ映像
    var CameraView: some View {
        ZStack(){
            // カメラ画像表示
            CALayerView(caLayer: avFoundationVM.previewLayer)
            
            // spacingはビュー間の隙間を無くすのに必要
            VStack(spacing: 0){
                VStack(spacing: 0){
                    HStack(){
                        NavigationLink(destination: InputView()){
                            Image(systemName: "hand.point.up.left")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(10)
                        }
                        // ナビゲーションを表示させないことで上部の余白を削除する。
                        .navigationBarHidden(true)
                        // 移動後の画面の崩れを抑えるのに必要
                        .navigationBarTitleDisplayMode(.inline)
                    
                        Spacer()
                    }
                    Spacer()
            
                    HStack(alignment: .center){
                        Text("枠に合わせて撮影して下さい。")
                            .foregroundColor(.black)
                    }
                    
                    /*
                    // テスト（後で削除してね。）
                    HStack(alignment: .center){
                        Text(String(Float(setValuesBeforeAppStart.picturePositionX))).foregroundColor(.black)
                        Text(String(Float(setValuesBeforeAppStart.picturePositionY))).foregroundColor(.black)
                        Text(String(Float(setValuesBeforeAppStart.pictureHeightWidth))).foregroundColor(.black)
                    }
                     */
                    
                    Spacer()
                }
                .background(Color.white)
                .frame(height: setValuesBeforeAppStart.messageAreaHeight)
                
                SudokuBorder
            
                VStack(spacing: 0){
                    HStack(){
                        Spacer()
                    
                        // 写真を撮る
                        Button(action: {
                            setValuesBeforeAppStart.currentStateForTopView = "解析中"
                            self.avFoundationVM.takePhoto()
                            setValuesBeforeAppStart.currentStateForTopView = "解析終了"
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        .padding(30)
                    
                        Spacer()
                    }
                }.background(Color.white)
            
            }.onAppear {
                // カメラ起動の開始時間をセット
                self.avFoundationVM.startSession()
            }.onDisappear {
                // カメラ停止の時間をセット
                self.avFoundationVM.endSession()
            }
        }
    }
    
    // 撮影画像画面
    var PhotoView: some View {
        ZStack(){
            // 先ほど撮影した画像を表示
            Image(uiImage: avFoundationVM.image!)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
            
            // spacingはビュー間の隙間を無くすのに必要
            VStack(spacing: 0){
                VStack(spacing: 0){
                    Spacer()
                    
                    HStack(){
                        Spacer()
                        
                        Text("うまく撮影できているか確認して下さい。")
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                
                    Spacer()
                }
                .background(Color.white)
                .frame(height: setValuesBeforeAppStart.messageAreaHeight)
                
                SudokuBorder
            
                VStack(spacing: 0){
                    HStack(){
                        Spacer()
                        
                        // 再撮影ボタン
                        Button(action: {
                            self.avFoundationVM.image = nil
                        }){
                            Text("再撮影")
                                .fontWeight(.semibold)
                                .frame(width: 100, height: 80)
                                .foregroundColor(Color(.white))
                                .background(Color(.black))
                                .cornerRadius(24)
                        }.padding(30)
                    
                        Spacer()
                        
                        // 解析開始ボタン
                        Button(action: {
                            guard let img = self.avFoundationVM.image else { return }
                            let clipRect = CGRect(x: 0, y: 400, width: 360, height: 360)
                            let cripImageRef = img.cgImage!.cropping(to: clipRect)
                            
                            let uiImage2 = UIImage(cgImage: cripImageRef!, scale: 1.0, orientation: UIImage.Orientation.right)
                            
                            self.avFoundationVM.image = uiImage2
                        }){
                            Text("解析開始")
                                .fontWeight(.semibold)
                                .frame(width: 100, height: 80)
                                .foregroundColor(Color(.white))
                                .background(Color(.blue))
                                .cornerRadius(24)
                        }.padding(30)
                        
                        Spacer()
                    }
                }.background(Color.white)
            }
            // 戻るボタンの表示領域を非表示(必要)
            .navigationBarHidden(true)
        }
    }
    
    // 数独の枠線を描画
    var SudokuBorder: some View {
        VStack(alignment: .center, spacing: 0){
            ForEach(0..<9){ i in
                HStack(alignment: .center, spacing: 0){
                    ForEach(0..<9){ j in
                        Text("")
                            .frame(width: setValuesBeforeAppStart.borderSize, height: setValuesBeforeAppStart.borderSize)
                            .border(.red, width: 0.5)
                            .foregroundColor(.black)
                                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.0))
                    }
                }
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



// プレビュー
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
        // 初期化時に設定した値のクラスをここでセットしないとプレビューエラーになる。（起動は出来る）
        .environmentObject(SetValuesBeforeAppStart())
    }
}

// 画面をタップしたらキーボードを隠す処理
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
