//
//  ContentView.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/12.
//

import SwiftUI

struct ContentView: View {
    @State private var weatherData = WeatherAPIService.getDummyData()
    @State private var isError = false
    @State private var isLoading = true
    @State private var selectedPage = 0
    @State private var updateCount = 0;
    
    // Get users weather data based on loc.
    func fetchUpdateWeatherData() async {
        do {
            self.weatherData = try await WeatherAPIService().fetchData()
            print(weatherData)
            self.isLoading = false
        } catch {
            self.isError = true
            self.isLoading = false
        }
    }
    
    // This will hold our timer
    var refreshTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            // Using a Task to run async function
            Task {
                // If user keeps app open dont want lots of calls. Limit to 5..
                updateCount += 1
                guard updateCount > 5 else { return stopTimer()}
                
                await fetchUpdateWeatherData()
            }
        }
    }
    
    init() {
        // Start the timer when the view is initialized
        // "I know a value is there, but I don't want to give it a name because I'm not going to use it."
        _ = self.refreshTimer
    }
    
    // Stop the refresh timer.
    func stopTimer() {
        refreshTimer.invalidate()
    }
    
    /* The $ prefix is Swift's way of referring to a Binding of a @State property. When you prefix a @State variable with $, you're creating a two-way binding to the underlying value. This means that if the value changes in the UI (e.g., the user swipes to a different tab), the value of selectedPage will update. */
    
    /* Each view within the TabView is given a unique tag. This tag associates a specific value with a view. When the selectedPage state variable matches a tag, that view is presented. */
    
    var body: some View {
        TabView(selection: $selectedPage) {
            ValueView(data: weatherData, dataType: .pollution)
                .id(UUID())
                .tag(0)
            ValueView(data: weatherData, dataType: .temperature)
                .id(UUID())
                .tag(1)
            ValueView(data: weatherData, dataType: .humidity)
                .id(UUID())
                .tag(2)
            ValueView(data: weatherData, dataType: .wind)
                .id(UUID())
                .tag(3)
            
        }
        .task {
            await fetchUpdateWeatherData()
        }
        .onDisappear(perform: stopTimer)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
