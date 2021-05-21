//
//  FetchDataService.swift
//  NewsFeedChallenge
//
//  Created by Kunal Chhabra on 19/05/21.
//

import Foundation

class FetchDataService
{
    //MARK: - properties - 
    private var dataTask: URLSessionDataTask?
    
    func getNewsFeedData(completion: @escaping (Result<NewsFeedData, Error>) -> Void){
        
        let newsFeedURL = "https://api.rss2json.com/v1/api.json?rss_url=http://www.abc.net.au/news/feed/51120/rss.xml"
        guard let url = URL(string: newsFeedURL)
        else
        {
            return
            
        }
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(NewsFeedData.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
