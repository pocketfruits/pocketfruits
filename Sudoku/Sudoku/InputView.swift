//
//  InputView.swift
//  Sudoku
//
//  Created by 江上亮 on 2021/12/30.
//

import SwiftUI
import Combine

struct InputView: View {
    // アプリ起動時に初期化した値を取得するのに使用するオブジェクト
    @EnvironmentObject var setValuesBeforeAppStart: SetValuesBeforeAppStart
    
    // 戻るボタンを作成するのに必要。（戻るボタンを作成する必要がなければ不要な処理）
    @Environment(\.presentationMode) var presentation
   
    // 入力する時にすでに入っている数字をバックアップしておく
    @State var backupNum: String = ""
    
    var body: some View {
        // spacingはビュー間の隙間を無くすのに必要
        VStack(spacing: 0){
            VStack(spacing: 0){
                HStack{
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Image(systemName: "camera")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(5)
                    }.padding(5)
                    
                    Spacer()
                }
                    
                Spacer()
                        
                HStack(){
                    Spacer()
                    Text(setValuesBeforeAppStart.currentStateForInputView)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                Spacer()
                
                Text(setValuesBeforeAppStart.errorMessageForInputView)
                    .foregroundColor(.red)
                        
                Spacer()
            }.background(Color.white)
                    
            VStack(alignment: .center, spacing: 0){
                ForEach(0..<setValuesBeforeAppStart.currentNumsForInputView.count){ i in
                    HStack(alignment: .center, spacing: 0){
                        ForEach(0..<setValuesBeforeAppStart.currentNumsForInputView[i].count){ j in
                            TextField("", text: $setValuesBeforeAppStart.currentNumsForInputView[i][j], onEditingChanged: { start in
                                if start{
                                    self.backupNum = setValuesBeforeAppStart.currentNumsForInputView[i][j]
                                }})
                                .keyboardType(.numberPad)
                                .frame(width: 40, height: 40)
                                .border(.black)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .font(.system(size: 30))
                                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.0))
                                // 1文字しか入力できないようにする
                                .onReceive(Just(setValuesBeforeAppStart.currentNumsForInputView[i][j]), perform: { _ in
                                    if 1 < setValuesBeforeAppStart.currentNumsForInputView[i][j].count {
                                        setValuesBeforeAppStart.currentNumsForInputView[i][j] = String(setValuesBeforeAppStart.currentNumsForInputView[i][j].prefix(1))
                                    }
                                    
                                    // 0が入力されたら元々入っていた数字を入力することで０を入力できなくする。
                                    if let _ = setValuesBeforeAppStart.currentNumsForInputView[i][j].firstIndex(of: "0") {
                                        setValuesBeforeAppStart.currentNumsForInputView[i][j] = self.backupNum
                                    }
                                })
                        }
                    }
                }
            }
                    
            VStack(spacing: 0){
                Spacer()
                        
                HStack(){
                    Spacer()
                    
                    // リセットボタン
                    Button(action: {
                        setValuesBeforeAppStart.currentStateForInputView = "解析前"
                        setValuesBeforeAppStart.errorMessageForInputView = ""
                        setValuesBeforeAppStart.currentNumsForInputView = setValuesBeforeAppStart.initNumsForInputView
                    }){
                        Text("リセット")
                            .fontWeight(.semibold)
                            .frame(width: 100, height: 40)
                            .foregroundColor(Color(.white))
                            .background(Color(.black))
                            .cornerRadius(24)
                    }
                    
                    Spacer()
                    
                    // 解析開始ボタン
                    Button(action: {
                        setValuesBeforeAppStart.currentStateForInputView = "解析中"
                        setValuesBeforeAppStart.errorMessageForInputView = ""
                        
                        // 入力値チェック
                        var isCheck: (Bool, String) = (isError: false, errorMessage: "")
                        isCheck = setValuesBeforeAppStart.errorCheck.CheckAll(nums: setValuesBeforeAppStart.currentNumsForInputView)
                        if(isCheck.0){
                            setValuesBeforeAppStart.errorMessageForInputView = isCheck.1
                            return
                        }
                        
                        // 解析開始　解析結果を画面に反映
                        setValuesBeforeAppStart.currentNumsForInputView = setValuesBeforeAppStart.analyze.StartAnalyze(stringGrid: setValuesBeforeAppStart.currentNumsForInputView)
                        
                        setValuesBeforeAppStart.currentStateForInputView = "解析終了"
                    }){
                        Text("解析開始")
                            .fontWeight(.semibold)
                            .frame(width: 100, height: 40)
                            .foregroundColor(Color(.white))
                            .background(Color(.blue))
                            .cornerRadius(24)
                    }
                    Spacer()
                }
                        
                Spacer()
                Spacer()
            }.background(Color.white)
        }.background(Color.white)
        // 画面をタップしてキーボードを隠す処理
        .onTapGesture{UIApplication.shared.endEditing()}
        // 戻るボタンを非表示
        .navigationBarBackButtonHidden(true)
        // 戻るボタンの表示領域を非表示
        .navigationBarHidden(true)
    }
}

// プレビュー画面
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
            // 初期化時に設定した値のクラスをここでセットしないとプレビューエラーになる。（起動は出来る）
            .environmentObject(SetValuesBeforeAppStart())
    }
}
