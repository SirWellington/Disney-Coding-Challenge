//
//  PugMeAPI.swift
//  DisneyCodingChallenge
//
//  Created by Wellington Moreno on 7/7/17.
//  Copyright © 2017 Disney, Inc. All rights reserved.
//

import Foundation

fileprivate let url = "https://pugme.herokuapp.com/bomb?count=50".asURL!

typealias PugCallback = ([URL]) -> Void

class PugMeAPI {
    
    
    //Load pugs from the API
    static func loadPugs(callback: @escaping PugCallback) {
        
        let endPrematurely = { callback([]) }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                
                LOG.error("Failed to load pugs from URL \(url) | \(error)")
                endPrematurely()
                return
            }
            
            guard let data = data else {
                LOG.error("Failed to retrieve data from URL: \(url)")
                endPrematurely()
                return
            }
            
            guard let rawJson = try? JSONSerialization.jsonObject(with: data, options: []) else {
                LOG.error("Failed to parse API response as JSON: \(data)")
                endPrematurely()
                return
            }
            
            guard let json = rawJson as? NSDictionary,
                  let pugUrls = json[Keys.pugs] as? NSArray else {
                    
                    LOG.error("Could not extract Pug URLs from Json | \(rawJson)")
                    endPrematurely()
                    return
            }
            
            
            let urls = pugUrls
                            .map{ "\($0)" }
                            .filter{ $0.notEmpty }
                            .map(self.replaceHTTPwithHTTPS)
                            .map(self.stripNumberDomain)
                            .filter {$0.endsWith(suffix: ".jpg") }
                            .flatMap{ URL(string: $0) }
            
            LOG.info("Finished loading \(urls.count)/\(pugUrls.count) pugs from API")
            
            callback(urls)
        
        }
        
        task.resume()
        
    }
    
    
    static func stripNumberDomain(url: String) -> String {
        
        let pattern = "https://\\d{2}\\."
        let with = "https://"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            LOG.error("Failed to create regex from pattern \(pattern)")
            return url
        }
        
        let range =  NSRange(location: 0, length: url.characters.count)
        
        let cleaned = regex.stringByReplacingMatches(in: url, options: .withTransparentBounds, range:range, withTemplate: with)
        
        return cleaned
    }
    
    static func replaceHTTPwithHTTPS(url: String) -> String {
        
        let pattern = "http://(.*)"
        let with = "https://$1"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            LOG.error("Failed to create regex from \(pattern)")
            return url
        }
        
        let range = NSRange(location: 0, length: url.characters.count)
        
        let cleaned = regex.stringByReplacingMatches(in: url, options: .withTransparentBounds, range: range, withTemplate: with)
        return cleaned
    }
}


fileprivate class Keys {
    
    static let pugs = "pugs"
}

fileprivate extension String {
    
    var asURL: URL? {
        return URL(string: self)
    }
    
    var notEmpty: Bool {
        return !isEmpty
    }
    
    func endsWith(suffix: String) -> Bool {
        return self.hasSuffix(suffix)
    }
    
    func doesNotEndWith(suffix: String) -> Bool {
        return !self.endsWith(suffix: suffix)
    }
}
