//
//  ApiManager.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-04.
//

import Foundation

class ApiManager {
    
    private var dataTask: URLSessionDataTask?
    func getPostsData(completion: @escaping (Result<[PostsData], Error>) -> Void) {
        
        let popularMoviesURL = APIConstant.postsURL + "posts"
        
        guard let url = URL(string: popularMoviesURL) else {return}
    
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
           
        if let error = error {
            completion(.failure(error))
            print("DataTask error: \(error.localizedDescription)")
            return
        }
            
        guard let response = response as? HTTPURLResponse else {
              
            print("Empty Response")
            return
        }
        print("Response status code: \(response.statusCode)")
            
        guard let data = data else {
            print("Empty Data")
            return
        }
            
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([PostsData].self, from: data)
            
            DispatchQueue.main.async {
                completion(.success(jsonData))
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    dataTask?.resume()
}
func getPostsDetailsData(completion: @escaping (Result<[PostsDetailsData], Error>) -> Void) {
            
    let usersURL = APIConstant.usersURL

    guard let url = URL(string: usersURL) else {return}
     
    dataTask = URLSession.shared.dataTask(with: url) {(data, response, error) in
       
    if let error = error {
        completion(.failure(error))
        print("DataTask error: \(error.localizedDescription)")
        return
    }
         
    guard let response = response as? HTTPURLResponse else {
        print("Empty Response")
        return
    }
    print("Response status code: \(response.statusCode)")
                
    guard let data = data else {
        print("Empty Data")
        return
    }
                
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([PostsDetailsData].self, from: data)
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
