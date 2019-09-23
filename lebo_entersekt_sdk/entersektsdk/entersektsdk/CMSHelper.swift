//
//  CMSHelper.swift
//  entersektsdk
//
//  Created by Lebo Morojele on 2019/09/18.
//  Copyright © 2019 Lebo Morojele. All rights reserved.
//

import Foundation

public class CMSHelper{
    public static let sharedInstance = CMSHelper()
    
    let baseUrl = "https://www.mocky.io/v2/5b7e8bc03000005c0084c210"
    public var cities:[City]?
    
    //As a developer, I would like to request a list of cities.
    public func getCities(completion: @escaping (_ cities:[City]?, _ error:String?) -> ()){
        refreshData { (cities, error) in
            completion(cities, error)
        }
    }
    
    //As a developer, I would like to request a particular city.
    public func getCity(city:Int, completion: @escaping (_ city:City?, _ error:String?) -> ()){
        getCities { (cities, error) in
            completion(cities?.first{$0.id == city}, error)
        }
    }
    
    //As a developer, I would like to request a list of malls in a city.
    public func getMallsInCity(city:Int, completion: @escaping (_ malls:[Mall]?, _ error:String?) -> ()){
        getCity(city: city) { (city, error) in
            completion(city?.malls, error)
        }
    }
    
    //As a developer, I would like to request a particular mall in a city.
    public func getMallInCity(city:Int, mall:Int, completion: @escaping (_ mall:Mall?, _ error:String?) -> ()){
        getCity(city: city) { (city, error) in
            completion(city?.malls?.first{$0.id == mall}, error)
        }
    }
    
    //As a developer, I would like to request a list of shops in a mall.
    public func shops(mall:Int, completion: @escaping (_ shops:[Shop]?, _ error:String?) -> ()){
        getCities { (cities, error) in
            let malls = cities?.compactMap{$0.malls}.flatMap{$0}
            let mall = malls?.first{$0.id == mall}
            completion(mall?.shops, error)
        }
    }
    
    //As a developer, I would like to request a particular shop in a mall.
    public func getShopInMall(shop:Int, mall:Int, completion: @escaping (_ shop:Shop?, _ error:String?) -> ()){
        shops(mall: mall) { (shops, error) in
            let shop = shops?.first{$0.id == shop}
            completion(shop, error)
        }
    }
    
    //Bonus: As a developer, I would like to request a list of shops in a city.
    public func getShopsInCity(city:Int, completion: @escaping (_ shops:[Shop]?, _ error:String?) -> ()){
        getCity(city: city) { (city, error) in
            let shops = city?.malls?.compactMap{$0.shops}.flatMap{$0}
            completion(shops ,error)
        }
    }
    
    //Bonus: As a developer, I would like to request the last valid data when offline.
    public func refreshCitiesUsingCache() -> [City]?{
        return cities
    }
    
    private func refreshData(completion: @escaping (_ cities:[City]?, _ error:String?) -> ()){
        processRequest(responseValue: MockCityResponse.self) { [weak self] (response, error) in
            self?.cities = response?.cities
            completion(response?.cities, error)
        }
    }
    
    private func processRequest<D: Decodable>(responseValue:D.Type, completion: @escaping (D?, String?) -> Void){
        guard let url = URL(string: baseUrl) else {return}
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let responseData = data else {
                    completion(nil, "No response data found")
                    return
                }
                guard error == nil else {
                    completion(nil, error?.localizedDescription ?? "An error occurred")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do{
                    let decoded:D = try decoder.decode(responseValue, from: responseData)
                    completion(decoded, nil)
                }catch{
                    completion(nil, "Failed to decode response: \(error.localizedDescription)")
                }
            }
            
            }.resume()
    }
}
