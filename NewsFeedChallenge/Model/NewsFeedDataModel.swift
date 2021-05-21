//
//  NewsFeedDataModel.swift
//  NewsFeedChallenge
//
//  Created by Kunal Chhabra on 19/05/21.
//

import Foundation


struct NewsFeedData: Decodable {
    
    var status : String?
    var feed : DataFeed
    var items : [DataItems]
}

struct DataFeed: Decodable {
    
    var url : String?
    var title : String?
    var link :  String?
    var author : String?
    var description : String?
    var image : String?
    
}

struct DataItems: Decodable {
    
    var title : String?
    var pubDate : String?
    var link : String?
    var guid : String?
    var author : String?
    var thumbnail : String?
    var description : String?
    var content : String?
    var enclosure : EnclosureData
    var categories : [String]?
    
}

struct EnclosureData: Decodable {
    
    var link : String?
    var type : String?
    var thumbnail : String?
}
