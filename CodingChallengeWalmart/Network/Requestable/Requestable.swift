//
//  Requestable.swift
//  CodingChallengeWalmart
//
//  Created by Dustin Pavy on 8/23/23.
//

import Foundation

protocol Requestable{
    var baseURL:String{get}
    var path:String{get}
    var type:String{get}
    var header:[String:String]{get}
    var params:[String:String]{get}
    
    func createURLRequest() -> URLRequest?
}

extension Requestable{
    var baseURL:String{
        return Endpoint.baseURL
    }
    var type:String{
        return ""
    }
    var header:[String:String]{
        return [:]
    }
    var params:[String:String]{
        return [:]
    }
    
    func createURLRequest() -> URLRequest?{
        guard baseURL.count > 0, path.count > 0 else {return nil}
        
        var urlComponents = URLComponents(string: baseURL + path)
        var queryItems: [URLQueryItem] = []
        
        for(key,value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else{return nil}
        return URLRequest(url: url)
    }
}

struct CountryRequest: Requestable{
    var path: String
}
