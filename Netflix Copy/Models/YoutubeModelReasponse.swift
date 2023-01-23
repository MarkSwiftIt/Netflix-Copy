//
//  YoutubeModelReasponse.swift
//  Netflix Copy
//
//  Created by Mark Goncharov on 23.01.2023.
//

import Foundation

struct YoutubeModelReasponse: Decodable {
    let items: [Video]
}

struct Video: Decodable {
    let id: IdVideo
}

struct IdVideo: Decodable {
    
    let kind: String
    let videoId: String
}
