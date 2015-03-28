//
//  Channel.swift
//  DVIPlayer
//
//  Created by JiangYi Zhang on 14/11/24.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit

class Channel: NSObject {
    var id: NSString!
    var title: NSString!
    var cate_id: NSString!
    var cate: NSString!
    
    
    init(dict: NSDictionary){
        super.init()
        // 取出来都是anyobject的，所以要进行数据类型转换
        self.id = dict["id"] as NSString
        self.title = dict["title"] as NSString
        self.cate_id = dict["cate_id"] as NSString
        self.cate = dict["cate"] as NSString
        
        
    }
}
