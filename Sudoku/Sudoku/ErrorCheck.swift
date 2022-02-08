//
//  CheckNums.swift
//  Sudoku
//
//  Created by 江上亮 on 2022/01/02.
//

import Foundation

class ErrorCheck{
    // エラーメッセージ
    private var NOTNUMBER: String           = "数字以外は入力できません"
    private var RANGE1TO9: String           = "１～９の１桁以外の数字は使用できません。"
    private var LESSTHAN17: String          = "最低１７個入力してください。"
    private var SAMENUMBERIN1LINE: String   = "同一行に同じ数字を入力することはできません。"
    private var SAMENUMBERIN1COLUMN: String = "同一列に同じ数字を入力することはできません。"
    private var SAMENUMBERINBox: String    = "3✖︎3の同一枠内に同じ数字を入力することはできません。"
    
    
    // 全てのチェックを行います
    public func CheckAll(nums: [[String]]) -> (Bool, String){
        if(IsNums(nums: nums)){ return (isError: true, errorMessage: NOTNUMBER) }
        if(IsOneNumber(nums: nums)){ return (isError: true, errorMessage: RANGE1TO9) }
        if(IsOver17(nums: nums)){ return (isError: true, errorMessage: LESSTHAN17) }
        if(IsSameNumberInLine(nums: nums)){ return (isError: true, errorMessage: SAMENUMBERIN1LINE) }
        if(IsSameNumberInColumn(nums: nums)){ return (isError: true, errorMessage: SAMENUMBERIN1COLUMN) }
        if(IsSameNumberInBox(nums: nums)){ return (isError: true, errorMessage: SAMENUMBERINBox) }
        return (isError: false, errorMessage: "")
    }
    
    // 入力値が数字のみかを確認します。
    public func IsNums(nums: [[String]]) -> Bool{
        for i in 0..<nums.count{
            for j in 0..<nums[i].count{
                if(nums[i][j].isEmpty){
                    continue
                }
                
                // 文字列数字を整数型に変換できるか確認
                if let _ = Int(nums[i][j]){}
                else{
                    return true
                }
            }
        }
        
        return false
    }
    
    // １桁の数字であることを確認
    public func IsOneNumber(nums: [[String]]) -> Bool{
        for i in 0..<nums.count{
            for j in 0..<nums[i].count{
                if(nums[i][j].isEmpty){
                    continue
                }
                
                if(nums[i][j] == "0"){
                    return true
                }
                
                if(nums[i][j].count != 1){
                    return true
                }
            }
        }
        
        return false
    }
    
    // 最低17個の入力があることを確認する
    public func IsOver17(nums: [[String]]) -> Bool{
        var tmp: Int = 0
        
        for i in 0..<nums.count{
            for j in 0..<nums[i].count{
                if(nums[i][j].isEmpty){
                    continue
                }
                
                tmp += 1
            }
        }
        
        if(tmp <= 16){
            return true
        }
        
        return false
    }
    
    // 同一行に同じ数字があるかを確認
    public func IsSameNumberInLine(nums: [[String]]) -> Bool{
        for i in 0..<nums.count{
            
            var tmp: [String] = []
            for j in 0..<nums[i].count{
                if(nums[i][j].isEmpty){
                    continue
                }
                
                // 各次元ごとに数字のみを配列に入れる。
                tmp.append(nums[i][j])
            }
            
            // １次元配列の中に重複した数字があるかを確認
            let originalNum: Int = tmp.count
            let orderedSet: Int = NSOrderedSet(array: tmp).count
            if(originalNum != orderedSet){
                return true
            }
        }
        
        return false
    }
    
    // 同一列に同じ数字があるかを確認
    public func IsSameNumberInColumn(nums: [[String]]) -> Bool{
        for i in 0..<nums.count{
            
            var tmp: [String] = []
            for j in 0..<nums[i].count{
                if(nums[j][i].isEmpty){
                    continue
                }
                
                // 各次元ごとに数字のみを配列に入れる。
                tmp.append(nums[j][i])
            }
            
            // １次元配列の中に重複した数字があるかを確認
            let originalNum: Int = tmp.count
            let orderedSet: Int = NSOrderedSet(array: tmp).count
            
            if(originalNum != orderedSet){
                return true
            }
        }
        
        return false
    }
    
    // 3✖︎3のボックス内に同じ数字がないことを確認する
    public func IsSameNumberInBox(nums: [[String]]) -> Bool{
        // 1〜３行、４〜６行、７〜９行のそれぞれでボックスを作成する。
        var tmp1: [String] = []
        var tmp2: [String] = []
        var tmp3: [String] = []
        
        for i in 0..<nums.count{
            if(i == 3 || i == 6){
                tmp1 = []
                tmp2 = []
                tmp3 = []
            }
            
            for j in 0..<nums[i].count{
                if(nums[i][j].isEmpty){
                    continue
                }
                
                if(j <= 2){
                    tmp1.append(nums[i][j])
                    continue
                }
                
                if(j <= 5){
                    tmp2.append(nums[i][j])
                    continue
                }
                
                tmp3.append(nums[i][j])
            }
            
            if(i == 2 || i == 5 || i == 8){
                var originalNum: Int = tmp1.count
                var orderedSet: Int = NSOrderedSet(array: tmp1).count
                if(originalNum != orderedSet){
                    return true
                }
                
                originalNum = tmp2.count
                orderedSet = NSOrderedSet(array: tmp2).count
                if(originalNum != orderedSet){
                    return true
                }
                
                originalNum = tmp3.count
                orderedSet = NSOrderedSet(array: tmp3).count
                if(originalNum != orderedSet){
                    return true
                }
            }
            
        }
        
        return false
    }
}
