//
//  api.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/12.
//

import Foundation

// DATA SHAPE
struct DataInfo: Decodable {
    let city: String
    let state: String
    let country: String
    let location: LocationData
    let current: CurrentInfo
}

struct LocationData: Codable {
    let city: String
    let state: String
    let country: String
    let current: CurrentInfo
}

struct CurrentInfo: Codable {
    let pollution: Pollution
    let weather: Weather
}

struct Pollution: Codable {
    let ts: String
    let aqius: Int
    let mainus: String
    let aqicn: Int
    let maincn: String
}

struct Weather: Codable {
    let ts: String
    let tp: Int
    let pr: Int
    let hu: Int
    let ws: Double
    let wd: Int
    let ic: String
}

// DATA MODEL representing the structure of the API's response for the location data.
struct LocationApiResponse: Codable {
    let status: String
    let data: LocationData
}

enum APIServiceError: Error {
    case urlError      // Represents a URL formation error.
    case serverError   // Represents any server-related error.
}

class WeatherAPIService {
    func fetchData() async throws -> LocationData {
        // Attempt to create a URL for the API endpoint.
        guard let url = URL(string: "https://api.airvisual.com/v2/nearest_city?key=3d6c568b-776a-4977-aa54-4bfdff20b4e0") else {
            throw APIServiceError.urlError
        }

        // Asynchronously fetch data from the URL.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Attempt to decode the fetched data into our LocationApiResponse model.
        let locationApiResponse = try JSONDecoder().decode(LocationApiResponse.self, from: data)
        
        // Return the location data.
        return locationApiResponse.data
    }
    
    // I was trying to use this as a method.
    // WeatherAPIService().fetchLocationData() -----> This was initialzed first see WeatherAPIService()
    static func getDummyData() -> LocationData {
        return LocationData(
            city: "",
            state: "",
            country: "",
            current: CurrentInfo(
                pollution: Pollution(ts: "", aqius: 0, mainus: "", aqicn: 0, maincn: ""),
                weather: Weather(ts: "", tp: 0, pr: 0, hu: 0, ws: 0.0, wd: 0, ic: "")
            )
        )
    }
}
