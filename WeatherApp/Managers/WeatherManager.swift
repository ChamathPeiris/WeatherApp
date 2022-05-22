//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-18.
//

import Foundation

enum WeatherUnit: String, Equatable {
    case metric = "metric"
    case imperial = "imperial"
}

//https://github.com/stephdiep/WeatherApp/tree/main/WeatherApp
class WeatherManager: ObservableObject {
    
    //base urls for current location and one call
    let currentWeatherBaseURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=\(API.key)"
    let oneCallBaseURL: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=\(API.key)"
    
    // default latitude and longitude
    private let defaultLat = 0.0
    private let defaultLon = 0.0
    
    @Published var weather: WeatherModel?
    @Published var OCweather: OneCallWeatherModel?
    private var unit: WeatherUnit = .metric
    
    //function for fetch current location
    func fetchForCurrentLocation(lat: Double, lon: Double) async {
        let url = "\(currentWeatherBaseURL)&lat=\(lat ?? defaultLat)&lon=\(lon ?? defaultLon)&units=metric"
        print(url)
        
        await requestWeather(url: url)
    }
    
    //function for fetch city
    func fetchForCity(string: String, unit: WeatherUnit) async {
        self.unit = unit
        let url = "\(currentWeatherBaseURL)&q=\(string)&units=\(unit.rawValue)"
        print(url)

        await requestWeather(url: url)
    }
    
    //function for get five days forecast
    func getFiveDayForecast(lat: Double, lon: Double, unit: WeatherUnit) async {
        self.unit = unit
        let url = "\(oneCallBaseURL)&lat=\(lat ?? defaultLat)&lon=\(lon ?? defaultLon)&units=\(unit.rawValue)"
        await requestForecast(url: url)
        
    }
    
    //function for request forecast weather information
    func requestForecast(url: String) async {
           guard let url = URL(string: url) else { return }
           do {
               let (data, _) = try await URLSession.shared.data(from: url) // Defining a session using a URL for requests
               let weather =  try JSONDecoder().decode(OneCallWeather.self, from: data) // Converting a JSON response into Swift Objects
               DispatchQueue.main.async {
                   let forecasts = weather.daily.map { daily in
                       OCWeatherDisplay(dt: daily.dt.unixToDate()!,
                                        temp: self.unit == .metric ? "\(daily.temp.day)°C" : "\(daily.temp.day)°F",
                                        pressure: daily.pressure,
                                        humidity: daily.humidity,
                                        clouds: daily.clouds,
                                        wind_speed: self.unit == .metric ? "\(daily.wind_speed) m/s" : "\(daily.wind_speed) mi/h",
                                        weather: daily.weather.first!,
                                        icon: self.getIcon(id: daily.weather.first!.id))
                   }
                   
                   let first = weather.hourly.first!
                   let current = OCWeatherDisplayHourly(dt: first.dt.unixToDate(date: .complete, time: .shortened)!,
                                                        temp: self.unit == .metric ? "\(first.temp)°C" : "\(first.temp)°F",
                                                        weather: first.weather.first!,
                                                        icon: self.getIcon(id: first.weather.first!.id),
                                                        hour: first.dt.unixToDate()!.get(.hour))
                   var hourly = weather.hourly.map { hourly in
                       OCWeatherDisplayHourly(dt: hourly.dt.unixToDate(date: .omitted, time: .shortened)!,
                                              temp: self.unit == .metric ? "\(hourly.temp)°C" : "\(hourly.temp)°F",
                                              weather: hourly.weather.first!,
                                              icon: self.getIcon(id: hourly.weather.first!.id),
                                              hour: hourly.dt.unixToDate()!.get(.hour))
                   }
                   
                   hourly = hourly.filter({ item in
                       return item.hour % 3 == 0
                   })
                   
                   self.OCweather = OneCallWeatherModel(forecast: forecasts,
                                                 hourlyForecasts: hourly,
                                                 current: current)
               }
           } catch {
               print("OCError: ",error.localizedDescription)
           }
       }
    
    
    //function for icon list
    func getIcon(id: Int) -> String {
            switch id {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
            }
        }
    
    //function for request current weather information
    func requestWeather(url: String) async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // Defining a session using a URL for requests
            let weather =  try JSONDecoder().decode(WeatherData.self, from: data) // Converting a JSON response into Swift Objects
            DispatchQueue.main.async {
                self.weather = WeatherModel(id: weather.weather.first?.id ?? 0,
                                            name: weather.name,
                                            temperature: weather.main.temp,
                                            description: weather.weather.first?.description ?? "",
                                            humidity: weather.main.humidity,
                                            pressure: weather.main.pressure,
                                            windSpeed: weather.wind.speed,
                                            direction: weather.wind.deg,
                                            cloudPercentage: weather.clouds.all,
                                            unit: self.unit)
            }
            print(weather)
            
        } catch {
            publish()
            print(error.localizedDescription)
        }
        
    }

    enum Error: LocalizedError {
        case titleEmpty

        var errorDescription: String? {
            switch self {
            case .titleEmpty:
                return "Location Error"
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .titleEmpty:
                return "Location can be non-existent or include non-alphabetic entries. Please check the location again."
            }
        }
    }

    @Published var title: String = ""
    @Published var error: Swift.Error?

    func publish() {
        error = Error.titleEmpty
    }
  
}
