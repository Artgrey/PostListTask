//
//  PostsDetailsData.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-20.
//

import Foundation

struct PostsDetailsData: Decodable {
    let name: String?
    let id: Int64?
    let email: String?
    let address: AddressDetailsData?
    let phone: String?
    let company: CompanyDetailsData?
    let website: String?
    let username: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case email = "email"
        case address = "address"
        case phone = "phone"
        case company = "company"
        case website = "website"
        case username = "username"
    }
}
struct CompanyDetailsData: Decodable {
    
    let catchPhrase: String?
    let bs: String?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case catchPhrase = "catchPhrase"
        case bs = "bs"
        case name = "name"
    }
}
struct AddressDetailsData: Decodable {
    let street: String?
    let city: String?
    let suite: String?
    let zipcode: String?
    let geo: GeoDetailsData?
    
    private enum CodingKeys: String, CodingKey {
        case street = "street"
        case city = "city"
        case suite = "suite"
        case zipcode = "zipcode"
        case geo = "geo"
    }
}
struct GeoDetailsData: Decodable {
    let lat: String?
    let lng: String?
   
    private enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}
