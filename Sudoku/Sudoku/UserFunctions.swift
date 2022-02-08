//
//  UserFunctions.swift
//  Sudoku
//
//  Created by 江上亮 on 2021/12/31.
//

import Foundation

// インスタンスを必要としないメソッドを定義します。
class UserFunctions{
    // 配列に初期値（""）を入れる
    static func MakeInitNums() -> [[String]]{
        var result: [[String]] = []
        
        for _ in 1...9{
            var tmp: [String] = []
            for _ in 1...9{
                tmp.append("")
            }
            result.append(tmp)
        }
        
        return result
    }
}
