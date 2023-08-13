//
//  RefreshView.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/13.
//

import SwiftUI

struct RefreshView: View {
    var fetchData: () async -> Void
    @State private var labelText: String = "Update data"
    
    
    // didSet -- This is a property observer. It observes changes to a property's value and allows you to run code in response.
    @State private var lastPressed: Date? {
        didSet {
            if let date = lastPressed {
                let timestamp = date.timeIntervalSince1970
                UserDefaults.standard.set(timestamp, forKey: "lastPressed")
            }
        }
    }
    
    @State private var timeRemaining: Int = 0
    let cooldown: TimeInterval = 60 * 60
    
    /* This is an initializer for a struct or class. It takes a single parameter named fetchData, which is an async function. The @escaping keyword indicates that this function might be called after the initializer returns, i.e., it might "escape" the current scope. */
    init(fetchData: @escaping () async -> Void) {
        // This line assigns the passed fetchData function to the struct's or class's property.
        self.fetchData = fetchData
        // Checks for last pressed in local storage, if there will
        // TimeInterval is a double but for seconds
        if let timestamp = UserDefaults.standard.value(forKey: "lastPressed") as? TimeInterval {
            _lastPressed = State(initialValue: Date(timeIntervalSince1970: timestamp))
        }
    }
    
    func shouldAllowPress() -> Bool {
        // The guard statement checks if lastPressed has a value
        guard let last = lastPressed else { return true }
        // checks if the elapsed time since the last press is greater than or equal to cooldown
        return Date().timeIntervalSince(last) >= cooldown
    }
    
    var body: some View {
        VStack{
            Spacer()
            Button {
                if shouldAllowPress() {
                    Task {
                        await fetchData()
                    }
                    lastPressed = Date()
                } else {
                    labelText = "Please wait one minute"
                    // This is simulating an async task like JavaScript's setTimeout
                    // The deadline parameter specifies when the task should be
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        labelText = "Update data"
                    }
                }
            } label: {
                Text(labelText)
            }
            Spacer()
            
        }
    }
}

struct RefreshView_Previews: PreviewProvider {
    static func temporaryFunctionForPreview() {
        print("Temporary function executed!")
    }
    
    static var previews: some View {
        RefreshView(fetchData: temporaryFunctionForPreview)
    }
}
