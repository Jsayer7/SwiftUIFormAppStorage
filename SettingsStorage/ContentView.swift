//
//  ContentView.swift
//  SettingsStorage
//
//  Created by James Sayer on 5/12/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("username") private var username: String = ""
    @AppStorage("unitOfMeasurement") private var measurement: String = "Feet"
    @AppStorage("favoriteNumber") private var favoriteNumber: Double = 0
    @AppStorage("favoriteColor") private var favoriteColor: Color = .white
    
    @State private var shouldShowSaveAlert = false
    
    let measurements = [
        "Feet",
        "Meters"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                
                Section("Text Entry") {
                    TextField("Username", text: $username)
                    Text("Current Username: \(username)")
                }

                Section("Slider") {
                    VStack {
                        HStack {
                            Text("0")
                            Slider(value: $favoriteNumber, in: 0...100, step: 1)
                            Text("100")
                        }
                        Text("Favorite Number: \(Int(favoriteNumber))")
                    }
                }
                
                Section("Pickers") {
                    Picker("Unit of Measurement", selection: $measurement) {
                        ForEach(measurements, id:\.self) {
                            Text($0)
                        }
                    }
                    ColorPicker("Favorite Color", selection: $favoriteColor)
                }
                
                Section("Buttons") {
                    Button("Save Settings") {
                        self.shouldShowSaveAlert.toggle()
                    }
                }
            }
            .navigationTitle("Form with AppStorage")
        }
        // Needed as the default behavior does not save to AppStorage until the fields editing state is ended
        .onChange(of: $username.wrappedValue) { name in
            self.$username.wrappedValue = name
        }
        .alert(Text("Confirm Save"), isPresented: $shouldShowSaveAlert) {
            Button("Yes", role: .cancel) {}
            Button("No", role: .destructive) {}
        } message: {
            Text("This isn't even needed, since all these settings use two-way bindings to UserDefaults.")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Color needs to conform to RawRepresentable to be used with AppStorage and Picker

extension Color: RawRepresentable {
    
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }
        
        do {
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        } catch {
            self = .black
        }
    }
    
    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}


