//
//  DetailsViewModel.swift
//  AmadeusTask
//
//  Created by Arturas Krivenkis on 2021-07-14.
//

import Foundation

class DetailsViewModel {
    
    let details: Details?
    
    let phone: String?
    let email: String?
    let id: Int64
    let address: String?
    let name: String?
    let company: String?
    let geoLat: String?
    let geoLng: String?
    init(details: Details?) {
        
        self.details = details
        
        self.name = details?.name
        self.phone = details?.phone
        self.id = details?.id ?? 0
        self.email = details?.email
         
        self.address = "\(details?.address?.street ?? ""), \(details?.address?.suite ?? ""), \(details?.address?.city ?? ""), \(details?.address?.zipcode ?? "")"
        self.company =  details?.company?.name
        self.geoLat = details?.address?.geo?.lat
        self.geoLng = details?.address?.geo?.lng
    }
}
