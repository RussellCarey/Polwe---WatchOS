//
//  WeatherView.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/13.
//

import SwiftUI

// NOT NEEDED AS THERE ARE NO IMAGES FROM THE API!?!!?!?!
struct WeatherView: View {
    @State var weatherImage: String;
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: weatherImage),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 300, maxHeight: 300)
                },
                placeholder: {
                    ProgressView()
                }
            )
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weatherImage: "https://picsum.photos/300/300.jpg")
    }
}
