//
//  Analyze.swift
//  Sudoku
//
//  Created by 江上亮 on 2022/01/04.
//

import Foundation

class Analyze{
    // 巻き戻し回数
    private var backtracks: Int = 0
    
    // マスの値
    private var grid: [[Int]] = []
    
    // 解析処理開始（カメラと手入力両方の画面で使用する処理）
    public func StartAnalyze(stringGrid: [[String]]) -> [[String]]{
        self.grid = ChangeString2Int(stringGrid: stringGrid)
        self.Solver()
        return self.ChangeInt2String(intGrid: self.grid)
    }
    
    // 解析処理
    private func Solver() -> Bool{
        let isDone: (isDone: Bool, y: Int, x: Int) = self.FindNextCell(grid: self.grid)
        
        if(isDone.isDone){
            return true
        }
        
        for value in 1...9{
            // 指定の値が、行・列・ブロックの中に含まれるかを確認
            if(self.IsValid(y: isDone.y, x: isDone.x, value: value)){
                // とりあえず使用できる数字を入力
                self.grid[isDone.y][isDone.x] = value
                
                // 次へ（引数のyとxは不要。）
                if Solver(){
                    return true
                }
                    
                self.backtracks += 1
                
                // 元の配列を入れ直す。
                self.grid[isDone.y][isDone.x] = 0
            }
        }
        
        return false
    }
    
    // まだ決まっていないマスのインデックス(i, j)を返すメソッド
    private func FindNextCell(grid: [[Int]]) -> (isDone: Bool, y: Int, x: Int){
        var result: (isDone: Bool, y: Int, x: Int) = (isDone: true, y: -1, x: -1)
        
        for i in 0...8{
            for j in 0...8{
                if(grid[i][j] == 0){
                    result = (isDone: false, y: i, x: j)
                    return result
                }
            }
        }
        
        return result
    }
    
    
    // 縦・横。ブロックで指定の値が利用出来るかを確認
    private func IsValid(y: Int, x: Int, value: Int) -> Bool{
        // 指定行の配列に指定の値があるかを確認(Bool)
        let isRow: Bool = self.grid[y].contains(value)
        
        // 指定列の配列に指定の値があるかをチェック(Bool)
        var isColumn: Bool = false
        for i in self.grid{
            if(i[x] == value){
                isColumn = true
                break
            }
        }
        
        // 整数除算(0,1,2は0。　3,4,5は3。　6,7,8は6)
        let blockX: Int = Int(floor(Float(x) / 3)) * 3
        let blockY: Int = Int(floor(Float(y) / 3)) * 3
        
        // 指定ブロックの配列に指定の値があるかを確認(Bool)
        var isBlock: Bool = false
        for i in 0..<3{
            for j in 0..<3{
                if(self.grid[blockY + i][blockX + j] == value){
                    isBlock = true
                    break
                }
            }
        }
        
        // 行・列・ボックスのどれかに指定の値が使用されていたらfalseを返す
        if(isRow || isColumn || isBlock){
            return false
        }
        
        return true
    }
    
    
    // 文字列型数字を整数型数字に変換します。　また、空白を0に変換します。
    private func ChangeString2Int(stringGrid: [[String]]) -> [[Int]]{
        var result: [[Int]] = []
        
        for i in 0...8{
            var tmp: [Int] = []
            for j in 0...8{
                if(stringGrid[i][j] == ""){
                    tmp.append(0)
                }
                
                if let intNum = Int(stringGrid[i][j]){
                    tmp.append(intNum)
                }
            }
            result.append(tmp)
        }
        
        return result
    }
    
    
    // 整数配列を文字列配列に変換
    private func ChangeInt2String(intGrid: [[Int]]) -> [[String]]{
        var result: [[String]] = []
        
        for i in 0...8{
            var tmp: [String] = []
            for j in 0...8{
                if intGrid[i][j] == 0{
                    tmp.append("")
                    continue
                }
                
                tmp.append(String(intGrid[i][j]))
            }
            result.append(tmp)
        }
        
        return result
    }
}
