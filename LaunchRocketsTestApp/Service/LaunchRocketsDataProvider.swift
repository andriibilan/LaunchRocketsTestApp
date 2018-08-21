//
//  DownloadDataFromApi.swift
//  LaunchRocketsTestApp
//
//  Created by Andrii Bilan on 8/20/18.
//  Copyright © 2018 Andrii Bilan. All rights reserved.
//

import Foundation

class LaunchRocketsDataProvider {
    
    enum Constants: String {
        case url = "https://launchlibrary.net/1.3/launch/next/50"
    }
    var launchItems = [LaunchItem]()
    
    func fetchData(complition: @escaping (_ data: [LaunchItem]?, _ success: Bool, _ error: Error?)->()) {
        let url = URL(string: Constants.url.rawValue)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let task = session.dataTask(with: request ) { (data, response, error) in
            guard error == nil else {
                complition(nil,false,error)
                return 
            }
            guard let data = data else {
                complition(nil,false,error)
                return
            }
            self.parsingJSON(data: data)
            DispatchQueue.main.async {
                complition(self.launchItems, true, nil)
            }
        }
        task.resume()
    }
}

private extension LaunchRocketsDataProvider {
    func parsingJSON(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let launches = json["launches"] as? [[String: Any]] {
                    for launch in launches {
                        let item = LaunchItem()
                        if let name = launch["name"] as? String {
                            item.name = name
                        }
                        if let start = launch["windowstart"] as? String {
                            item.start = start
                        }
                        if let missions = launch["missions"] as? [[String: Any]] {
                            for mission in missions {
                                if let description = mission["description"] as? String {
                                    item.description = description
                                }
                            }
                        }
                        if let location = launch["location"] as? [String: Any] {
                            let locationLaunch = Location()
                            if let name = location["name"] as? String {
                                locationLaunch.name = name
                            }
                            item.location = locationLaunch
                        }
                        if let rocket = launch["rocket"] as? [String: Any]  {
                            if let imageURL = rocket["imageURL"] as? String {
                                item.photo = URL(string: imageURL)
                            }
                            if let agencies = rocket["agencies"] as? [[String: Any]] {
                                let agenty = Agency()
                                for agency in agencies {
                                    if let agencyName = agency["name"] as? String {
                                        agenty.name = agencyName
                                    }
                                    if let agencyAbberv = agency["abbrev"] as? String {
                                        agenty.abbreviation = agencyAbberv
                                    }
                                    if let countryCode = agency["countryCode"] as? String {
                                        agenty.countryCode = countryCode
                                    }
                                }
                                item.agency = agenty
                            }
                        }
                        launchItems.append(item)
                    }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
    }
}
