//
//  ContentView.swift
//  practice
//
//  Created by 江上亮 on 2021/12/30.
//

import SwiftUI

// 元ページ
struct ContentView: View {
    var body: some View {
        NavigationView {
            List(1..<20) { index in
                NavigationLink(destination: Text("\(index)番目のView")) {
                    Text("\(index)行目")
                }
            }
            .navigationTitle("NavigationView")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                /// ナビゲーションバー左
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                    }
                }
                
                /// ナビゲーションバー右１
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {}) {
                        Image(systemName: "trash")
                    }
                }
                
                /// ナビゲーションバー右２
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Cancel") {}
                }
                
                /// ボトムバー
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {}) {
                        Label("送信", systemImage: "paperplane")
                    }
                }
            }
        }
    }
}


// 元ページのプレビュー画面
struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}


// 遷移先ページ
struct NextPageView: View{
    var body: some View{
        Text("２ページ目")
    }
}
