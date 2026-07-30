//
//  GeocodeRequest.swift
//  LocationGeocodingPOC
//
//  Created by Mamadou Balde on 7/22/26.
//

import Foundation

/// The top-level payload structure used to send batch geocoding requests to a GIS mapping service.
struct GeocodeRequest: Codable {
    
    /// The collection of individual address rows included in the batch query.
    let records: [AddressRecord]
}

/// An individual container representing a single address record in a batch request.
struct AddressRecord: Codable {
    
    /// The specific geolocation fields and identity tracking token for the address.
    let attributes: AddressAttributes
}

/// The granular address fields mapped directly to the keys expected by the geocoding service.
struct AddressAttributes: Codable {
    
    /// A unique tracking identifier assigned to this specific address row.
    let objectId: Int
    
    /// The street name and building number (e.g., "123 Main St").
    let street: String
    
    /// The name of the city (e.g., "Albany").
    let city: String
    
    /// The abbreviated or full state name (e.g., "NY").
    let state: String
    
    /// The postal code matching the address (e.g., "12203").
    let zip: String
    
    enum CodingKeys: String, CodingKey {
        case objectId = "ObjectId"
        case street = "Street"
        case city = "City"
        case state = "State"
        case zip = "ZIP"
    }
    
    /// Overrides default encoding synthesis to lock property sequence serialization in place.
    ///
    /// Some legacy GIS servers require a strict, predictable field sequence inside
    /// the JSON request payload to parse batch lines successfully.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(objectId, forKey: .objectId)
        try container.encode(street, forKey: .street)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zip, forKey: .zip)
    }
}
