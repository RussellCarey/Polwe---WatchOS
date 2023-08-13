//
//  ValueView.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/13.
//

import Foundation
import SwiftUI

enum DataType {
    case weather
    case temperature
    case humidity
    case wind //ms
    case uv
    case cloud
}

struct ValueView: View {
    @State var data: DataInfo
    @State var showBars: Bool = true
    let dataType: DataType
    let numberRectangles: Int = 30
    
    func getMaxValue() -> Double {
        switch dataType {
        case .weather:
            return 0
        case .temperature:
            return 60.0
        case .humidity:
            return 100.0
        case .wind:
            return 50.0
        case .uv:
            return 15.0
        case .cloud:
            return 100.0
        }
    }
    
    func getTitle() -> String {
        switch dataType {
        case .temperature:
            return "Temp"
        case .humidity:
            return "Humidity"
        case .wind:
            return "Wind"
        case .weather:
            return "Weather"
        case .uv:
            return "UV Level"
        case .cloud:
            return "Cloud Cover"
        }
    }
    
    func getNotchColor(value: Double) -> Color {
        switch dataType {
        case .temperature:
            switch value {
            case 0..<20:
                return Color.green
            case 20..<40:
                return Color.orange
            case 40..<61:
                return Color.red
            default:
                return Color.green
            }
        case .humidity, .cloud:
            switch value {
            case 0..<20:
                return Color.green
            case 20..<66:
                return Color.orange
            case 66..<101:
                return Color.red
            default:
                return Color.green
            }
        case .wind:
            switch value {
            case 0..<15:
                return Color.green
            case 20..<30:
                return Color.orange
            case 40..<51:
                return Color.red
            default:
                return Color.green
            }
        case .uv:
            switch value {
            case 0..<5:
                return Color.green
            case 5..<10:
                return Color.orange
            case 10..<16:
                return Color.red
            default:
                return Color.green
            }
        case .weather:
            return Color.green
        }
        
    }
    
    func getValueText() -> String{
        switch dataType {
        case .temperature:
            return "\(data.current.temp_c)°c"
        case .humidity:
            return "\(data.current.humidity)%"
        case .wind:
            return "\(data.current.wind_mph)ms / \(data.current.wind_dir)"
        case .weather:
            return "\(data.current.condition.text)"
        case .uv:
            return "\(data.current.uv). \(uvDescription(value: data.current.uv))"
        case .cloud:
            return "\(data.current.cloud)%"
        }
    }
    
    func value() -> Double{
        switch dataType {
        case .temperature:
            return Double(data.current.temp_c)
        case .humidity:
            return Double(data.current.humidity)
        case .wind:
            return Double(data.current.wind_mph)
        case .uv:
            return Double(data.current.uv)
        case .weather:
            return 0.0
        case .cloud:
            return Double(data.current.cloud)
        }
    }
    
    func uvDescription(value: Double) -> String {
        switch value {
        case 0...2:
            return "Low"
        case 3...5:
            return "Moderate"
        case 6...7:
            return "High"
        case 8...10:
            return "Very High"
        case 11...:
            return "Extreme"
        default:
            return "Invalid UV Index"
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(getTitle())
                    .font(.system(size: 30))
                Text("\(data.location.name)")
                    .font(.system(size: 22))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if (showBars) {
                Spacer()
                HStack {
                    ForEach(1...numberRectangles, id: \.self) { i in
                        let amountPerRect = getMaxValue() / Double(numberRectangles)
                        let currentValue = Double(i) * amountPerRect
                        let valueToCheck = value()
                        let color = currentValue > valueToCheck ? Color.white : getNotchColor(value: value())
                        
                        Rectangle()
                            .fill(color)
                            .frame(width: 1, height: 40)
                        Spacer()
                    }
                }
                .frame(alignment: .leading)
                .padding(.horizontal, 5)
                Spacer()
            }
            
            Spacer()
    
            
            HStack {
                Text(getValueText())
                    .font(.system(size: showBars ? 16 : 22))
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } // VStack
    }
}

struct ValueView_Previews: PreviewProvider {
    static var previews: some View {
        ValueView(data: WeatherAPIService.getDummyData(), dataType: .wind)
    }
}
