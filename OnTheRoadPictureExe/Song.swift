//
//  Song.swift
//  DVIPlayer
//
//  Created by JiangYi Zhang on 14/11/24.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit

class Song: NSObject, NSCoding {
    var id: NSInteger!
    var songName: NSString!
    var artistName: NSString!
    var albumName: NSString!
    var songPicSmall: NSString!
    var songPicbig: NSString!
    var songPicRadio: NSString!
    var lrcLink: NSString!
    var songLink: NSString!
    var showLink: NSString!
    
    func refreshSong(dict: NSDictionary){
        
        self.songName = dict["songName"] as NSString
        self.artistName = dict["artistName"] as NSString
        self.albumName = dict["albumName"] as NSString
        self.songPicSmall = dict["songPicSmall"] as NSString
        self.songPicbig = dict["songPicBig"] as NSString
        self.songPicRadio = dict["songPicRadio"] as NSString
        self.lrcLink = dict["lrcLink"] as NSString
        self.songLink = dict["songLink"] as NSString
        self.showLink = dict["showLink"] as NSString
        
    }
    
    override init() {
            }
    
    
    // 编码
    func  encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.id, forKey: "id")
        aCoder.encodeObject(self.songName, forKey: "songName")
        aCoder.encodeObject(self.artistName, forKey: "artistName")
        aCoder.encodeObject(self.albumName, forKey: "albumName")
        aCoder.encodeObject(self.songPicSmall, forKey: "songPicSmall")
        aCoder.encodeObject(self.songPicbig, forKey: "songPicbig")
        aCoder.encodeObject(self.songPicRadio, forKey: "songPicRadio")
        aCoder.encodeObject(self.lrcLink, forKey: "lrcLink")
        aCoder.encodeObject(self.songLink, forKey: "songLink")
        aCoder.encodeObject(self.showLink, forKey: "showLink")
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.songName = aDecoder.decodeObjectForKey("songName") as NSString
        self.artistName = aDecoder.decodeObjectForKey("artistName") as NSString
        self.albumName = aDecoder.decodeObjectForKey("albumName") as NSString
        self.songPicbig = aDecoder.decodeObjectForKey("songPicbig") as NSString
        self.songPicSmall = aDecoder.decodeObjectForKey("songPicSmall") as NSString
        self.songPicRadio = aDecoder.decodeObjectForKey("songPicRadio") as NSString
        self.lrcLink = aDecoder.decodeObjectForKey("lrcLink") as NSString
        self.showLink = aDecoder.decodeObjectForKey("showLink") as NSString
        self.songLink = aDecoder.decodeObjectForKey("songLink") as NSString
    }
    
}
