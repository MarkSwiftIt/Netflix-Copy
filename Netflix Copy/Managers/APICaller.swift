//
//  APICaller.swift
//  Netflix Copy
//
//  Created by Mark Goncharov on 23.01.2023.
//

import Foundation

struct Constants {
    
    static let API_KEY = "3e33dbba360d7c7a2130c7e94e798b26"
    static let baseUrl = "https://api.themoviedb.org/3"
    static let youtubeAPI_KEY = "AIzaSyB8ZQM1AiQvefeC9fGMWngMpKYIdgj0Ja0"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum ApiError: Error {
    case failedTogetData
}

class APICaller {
    
    static let shared = APICaller()

    func getTrandingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
    
        guard let url = URL(string: "\(Constants.baseUrl)/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }

    func getTrandingTV(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {

        guard let url = URL(string: "\(Constants.baseUrl)/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }
    
    func getSearchTitle(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseUrl)/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }
    
    func getYoutubeTrailer(with query: String, completion: @escaping (Result<Video, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.youtubeAPI_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(YoutubeModelReasponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(ApiError.failedTogetData))
            }
        }.resume()
    }
}


