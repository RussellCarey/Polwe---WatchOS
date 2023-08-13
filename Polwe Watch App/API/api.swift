//
//  api.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/12.
//

import Foundation

// DATA SHAPE
struct DataInfo: Decodable {
    let location: Location
    let current: CurrentInfo
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}

struct CurrentInfo: Codable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: WeatherCondition
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let vis_km: Double
    let vis_miles: Double
    let uv: Double
    let gust_mph: Double
    let gust_kph: Double
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
    let code: Int
}

enum APIServiceError: Error {
    case urlError      // Represents a URL formation error.
    case serverError   // Represents any server-related error...
}

class WeatherAPIService {
    func fetchData() async throws -> DataInfo {
        let apiKey: String = getVariable(name: "weatherAPI") ?? ""
        
        // API keys often require proper encoding to be included in URLs.
        guard let encodedApiKey = apiKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw APIServiceError.urlError
        }

        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(encodedApiKey)&q=auto:ip") else {
            throw APIServiceError.urlError
        }

        // Asynchronously fetch data from the URL.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Attempt to decode the fetched data into our DataInfo model.
        let dataInfo = try JSONDecoder().decode(DataInfo.self, from: data)
        
        // Return the data info.
        return dataInfo
    }

    
    // I was trying to use this as a method.
    // WeatherAPIService().fetchLocationData() -----> This was initialzed first see WeatherAPIService()
    static func getDummyData() -> DataInfo {
        return DataInfo(
            location: Location(
                name: "",
                region: "",
                country: "",
                lat: 0.0,
                lon: 0.0,
                tz_id: "",
                localtime_epoch: 0,
                localtime: ""
            ),
            current: CurrentInfo(
                last_updated_epoch: 0,
                last_updated: "",
                temp_c: 0.0,
                temp_f: 0.0,
                is_day: 0,
                condition: WeatherCondition(text: "", icon: "", code: 0),
                wind_mph: 0.0,
                wind_kph: 0.0,
                wind_degree: 0,
                wind_dir: "",
                pressure_mb: 0.0,
                pressure_in: 0.0,
                precip_mm: 0.0,
                precip_in: 0.0,
                humidity: 0,
                cloud: 0,
                feelslike_c: 0.0,
                feelslike_f: 0.0,
                vis_km: 0.0,
                vis_miles: 0.0,
                uv: 0.0,
                gust_mph: 0.0,
                gust_kph: 0.0
            )
        )
    }
}
