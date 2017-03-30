//
//  DemoURL.swift
//  Cassini
//
//  Created by Ju on 2017/3/30.
//  Copyright © 2017年 Ju. All rights reserved.
//

import Foundation

struct DemoURL
{
    static let stanford = URL(string: "http://stanford.edu/about/images/intro_about.jpg")
    static var NASA: Dictionary<String,URL> = {
//        let NASAURLStrings = [
//            "Cassini" : "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
//            "Earth" : "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
//            "Saturn" : "http://www.nasa.gov/sites/default/files/saturn_collage.jpg"
//        ]
        
        // The original image can not be access
        let NASAURLStrings = [
            "Cassini" : "http://img.zcool.cn/community/03320dd554c75c700000158fce17209.jpg",
            "Earth" : "http://img17.3lian.com/d/file/201703/13/2e15043111f9553e003c5aa891a10741.jpg",
            "Saturn" : "http://img06.tooopen.com/images/20161010/tooopen_sy_181352973287.jpg"
        ]
        
        var urls = Dictionary<String,URL>()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
