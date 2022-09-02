//
//  QuickFilter.swift
//  MultiPay
//
//  Created by  on 08/09/2016.
//  Copyright © 2016 . All rights reserved.
//

import Foundation

class LookUpTableItem: BaseModel {
    
    var key: Int?
    var value: String?
    
    init(key: Int?, value: String?) {
        
        if key != nil {
            
            self.key = key!
        }
        
        if value != nil {
            
            self.value = value!
        }
        
        
    }
    
    class func createItem(_ data: [[String : AnyObject]]?) -> [LookUpTableItem]{
        
        var list : [LookUpTableItem] = [LookUpTableItem]()
        
        if let result = data {
            
            for item in result {
                // LoggerHelper.logger.debug(item["Key"])
                //LoggerHelper.logger.debug(item["Value"])
                list.append(LookUpTableItem(key: Int(item["Key"] as! String) , value: item["Value"] as? String))
                
            }
            
        }
        
        return list
        
    }
    
}


class LookUpTable: BaseModel {
    
    var key: String?
    var value : String?
    var isMutiSelectable = false
    var visibleInFilterScreen = false
    var detail: [LookUpTableItem] = [LookUpTableItem]()
    
    
    init(key: String? , value: String?, isMutiSelectable: Bool?, visibleInFilterScreen: Bool?, detail: [LookUpTableItem]) {
        
        if key != nil {
            self.key = key!
        }
        
        if value != nil {
            self.value = value!
        }
        
        if isMutiSelectable != nil {
            self.isMutiSelectable = isMutiSelectable!
        }
        
        if visibleInFilterScreen != nil{
            
            self.visibleInFilterScreen = visibleInFilterScreen!
        }
        
        self.detail = detail
        
    }
    
    
    class func createWithDictionary(_ data: [[String : AnyObject]]?) -> [String : LookUpTable]{
        
        var filterItemList : [String : LookUpTable] = [String : LookUpTable]()
        
        if let result = data{
            
            for item in result{
                
                let list = LookUpTableItem.createItem(item["Details"] as? [[String : AnyObject]])
                
                
                filterItemList[item["Key"] as! String] = LookUpTable(key: item["Key"] as? String, value: item["Value"] as? String, isMutiSelectable: item["IsMultiSelectable"] as? Bool, visibleInFilterScreen: item["VisibleInFilterScreen"] as? Bool,  detail: list)
                
                
            }
            
        }
        
        return filterItemList
        
    }
    
}


class LookUp {
    
    class var sharedInstance: LookUp {
        struct Static {
            static let instance = LookUp()
        }
        return Static.instance
    }
    
    var lookUpTable : [String : LookUpTable] = [String : LookUpTable]()
    
    
    
    func getLookUpTable() -> [String : LookUpTable]{
        
        return lookUpTable
        
    }
    
    func getLookUpFilters() -> [LookUpTable]{
        
        var filters: [LookUpTable] = [LookUpTable]()
        
        for item in lookUpTable.values {
            
            filters.append(item)
            
        }
        
        return filters
        
    }
    
    func getItemWithKeys(_ tableKey:String, ItemKeys:[Int]) ->[LookUpTableItem]{
        
        var list : [LookUpTableItem] = [LookUpTableItem]()
        
        if let table = lookUpTable[tableKey]{
            
            list = table.detail.filter({ (item) -> Bool in
                
                if let key = item.key{
                    
                    return ItemKeys.contains(key)
                    
                }
                
                return false
            })
        }
        
        return list
        
    }
    
    
}



