# 🌤️ SimpleWeather

An iOS weather app built with **Swift 6** and **UIKit**, fully programmatic (no Storyboard). The app fetches current, hourly, and 5-day weather forecasts using the [WeatherAPI](https://www.weatherapi.com/) and displays it in a clean and user-friendly interface, inspired by Apple’s native Weather app.

## 📱 Features

- 🌍 **Geolocation support:** Requests location permission on launch. If permission is denied, defaults to Moscow.
- 🌤️ **Current weather:** Shows temperature and condition based on the user’s location.
- 🕓 **Hourly forecast:** Displays remaining hours of the current day and all hours of the next day.
- 📅 **7-day forecast:** Includes daily highs and lows, weather icons, and precipitation chance.
- ⚠️ **Error handling:** If data fails to load, shows an error message with a retry button.
- 💡 **Apple-style design:** Clean, readable, and modern UI with dynamic layout.

## 🧱 Architecture

The app is structured using the **MVVM (Model-View-ViewModel)** pattern for better separation of concerns and easier testing and maintenance.

## 📦 Tech Stack

- **Language:** Swift 6
- **UI Framework:** UIKit with Auto Layout (programmatic, no Storyboard)
- **Networking:** URLSession
- **Image Loading:** [Kingfisher](https://github.com/onevcat/Kingfisher)
- **Dependency Management:** Swift Package Manager (SPM)
- **Geolocation:** CoreLocation
- **Data Source:** [WeatherAPI](https://www.weatherapi.com/)

## ⚙️ Requirements

- **Xcode:** 15 or later
- **iOS:** 15.0+
- **API Key:** WeatherAPI (use your own API key)

## 🔐 Adding Your API Key

To use the WeatherAPI, you need to provide your API key.

You can do this in one of two ways:

1. **Add a `Config.plist` file** to your project bundle (do **not** commit it to version control):
   - Create a new `Config.plist` file.
   - Add a key named `WeatherAPIKey` and paste your API key as the value.

2. **Alternatively**, for testing or quick setup, you can directly insert your key into the `NetworkService` class by modifying the `apiKey` constant:

   ```swift
   private let apiKey = "your_api_key_here"