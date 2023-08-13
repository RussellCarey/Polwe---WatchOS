//
//  ValueView.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/13.
//

import Foundation
import SwiftUI

enum DataType {
    case pollution
    case temperature
    case humidity
    case wind //ms
}

struct ValueView: View {
    @State var data: LocationData
    let dataType: DataType
    let numberRectangles: Int = 30
    
    func getMaxValue() -> Double {
        switch dataType {
        case .pollution:
            return 500.0
        case .temperature:
            return 60.0
        case .humidity:
            return 100.0
        case .wind:
            return 50.0
        }
    }
    
    func getTitle() -> String {
        switch dataType {
        case .pollution:
            return "Pollution"
        case .temperature:
            return "Temp"
        case .humidity:
            return "Humidity"
        case .wind:
            return "Wind"
        }
    }
    
    func getNotchColor(value: Double) -> Color {
        switch dataType {
        case .pollution:
            switch value {
            case 0..<150:
                return Color.green
            case 150..<300:
                return Color.orange
            case 300..<501:
                return Color.red
            default:
                return Color.green
            }
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
        case .humidity:
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
        }
    }
    
    func windDirectionFrom(degree: Int) -> String {
        switch degree {
        case 338...360:
            fallthrough
        case 0..<23:
            return "N"
        case 23..<68:
            return "NE"
        case 68..<113:
            return "E"
        case 113..<158:
            return "SE"
        case 158..<203:
            return "S"
        case 203..<248:
            return "SW"
        case 248..<293:
            return "W"
        case 293..<338:
            return "NW"
        default:
            return "Unknown Direction"
        }
    }
    
    func getValueText() -> String{
        switch dataType {
        case .pollution:
            return "\(data.current.pollution.aqius) / \(data.current.pollution.mainus)"
        case .temperature:
            return "\(data.current.weather.tp)°c"
        case .humidity:
            return "\(data.current.weather.hu)%"
        case .wind:
            return "\(data.current.weather.ws)ms / \(windDirectionFrom(degree: data.current.weather.wd))"
        }
    }
    
    func value() -> Double{
        switch dataType {
        case .pollution:
            return Double(data.current.pollution.aqius)
        case .temperature:
            return Double(data.current.weather.tp)
        case .humidity:
            return Double(data.current.weather.hu)
        case .wind:
            return Double(data.current.weather.ws)
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                Text(getTitle())
                    .font(.system(size: 30))
                Text("\(data.city)")
                    .font(.system(size: 22))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
            
            HStack {
                Text(getValueText())
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        } // VStack
    }
}

struct ValueView_Previews: PreviewProvider {
    static var previews: some View {
        ValueView(data: WeatherAPIService.getDummyData(), dataType: .pollution)
    }
}
