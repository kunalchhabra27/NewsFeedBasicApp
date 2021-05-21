//
//  NewsFeedViewModel.swift
//  NewsFeedChallenge
//
//  Created by Kunal Chhabra on 21/05/21.
//

import Foundation

class NewsFeedViewModel {
    
    //MARK: - properties - 
    private var fetchDataService = FetchDataService()
    private var newsItems = [DataItems]()
    
    func fetchNewsFeedData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        fetchDataService.getNewsFeedData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.newsItems = listOf.items
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if newsItems.count != 0 {
            return newsItems.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> DataItems {
        return newsItems[indexPath.row]
    }
}
