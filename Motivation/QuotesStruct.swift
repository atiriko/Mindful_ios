//
//  QuotesStruct.swift
//  Motivation
//
//  Created by Atahan Sahlan on 01/10/2020.
//

import Foundation

struct QuoteData: Codable {
    let copyright: Copyright
    let baseurl: String
    let contents: Contents
    let success: Success
}

// MARK: - Contents
struct Contents: Codable {
    let quotes: [Qquote]
}

// MARK: - Quote
struct Qquote: Codable {
    let date, quote, author: String
    let background: String
    let length, language, id, category: String
    let permalink: String
    let title: String
    let tags: [String]
}

// MARK: - Copyright
struct Copyright: Codable {
    let year: Int
    let url: String
}

// MARK: - Success
struct Success: Codable {
    let total: Int
}
