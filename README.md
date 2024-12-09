
# **iOSBeerApp**

An iOS application that showcases breweries from the Open Brewery DB API. The app leverages SwiftUI for a modern user interface, Core Data for offline persistence, and follows clean architecture principles for maintainability and scalability.

---

## **App Purpose**

The purpose of the app is to allow users to explore a list of breweries fetched from a remote API, with offline capabilities. Users can view detailed information about each brewery and navigate to its location on Apple Maps. The app also supports pagination for fetching large datasets.

---

## **Features**

- Fetch brewery data from the [Open Brewery DB API](https://api.openbrewerydb.org/v1/breweries).
- Display a paginated list of breweries.
- View brewery details, including name, type, address, city, and website.
- Navigate to brewery locations in Apple Maps.
- Offline support with Core Data for persistence.
- Pull-to-refresh functionality to reload data.
- Pagination for efficient data fetching and display.
- Error handling for network and data issues.

---

## **App Architecture**

The app is built using the **MVVM + Use Cases** architectural pattern and adheres to clean architecture principles.

### **Modules and Responsibilities**

1. **UI Layer (SwiftUI)**:
   - `BeersScreen`:
     - Displays a list of breweries.
     - Handles user interactions like pull-to-refresh and pagination.
   - `BeerItemView`:
     - Shows individual brewery details and a button to open the location in Apple Maps.
     
2. **ViewModel Layer**:
   - `BeersViewModel`:
     - Manages the app state (`loading`, `loaded`, `error`).
     - Handles business logic for fetching breweries and managing pagination.

3. **Domain Layer**:
   - **Use Cases**:
     - `GetBeersUseCase`: Fetches a list of breweries from the repository.
     - `IsInternetConnectionAvailableUseCase`: Checks for internet connectivity.
   - **Entities**:
     - `Beer`: A domain model representing brewery data.

4. **Data Layer**:
   - **Repository**:
     - `BeersRepository`: Serves as the single source of truth, fetching data from local or remote sources.
   - **Data Sources**:
     - `OpenBreweryRemoteDataSource`: Fetches data from the Open Brewery DB API.
     - `CoreDataLocalDataSource`: Manages persistence with Core Data for offline support.

---

## **API Details**

- **Base URL**: `https://api.openbrewerydb.org/v1/breweries`
- **Endpoints**:
  - `GET /?page={page}&per_page=10`
    - Fetches a paginated list of breweries.

---

## **Core Data**

The app uses Core Data for offline data persistence:
- Entity: `BeerEntity`
- Attributes:
  - `id`, `name`, `breweryType`, `address1`, `city`, `stateProvince`, `postalCode`, `country`, `phone`, `websiteURL`, `latitude`, `longitude`.

### **Database Location**

The SQLite database file is stored in:
```
Library/Application Support/BeerModel.sqlite
```

---

## **Code Example**

### Fetch Beers
```swift
Task {
    let result = await getBeersUseCase.execute(page: 1)
    switch result {
    case .success(let beers):
        print("Fetched beers: \(beers)")
    case .failure(let error):
        print("Failed to fetch beers: \(error.localizedDescription)")
    }
}
```

### Display Beers in SwiftUI
```swift
struct BeersScreen: View {
    @StateObject var viewModel: BeersViewModel

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")
            case .loaded(let beers):
                List(beers) { beer in
                    BeerItemView(beer: beer)
                }
            case .error(let message):
                Text("Error: \(message)")
            }
        }
        .onAppear {
            viewModel.getBeers()
        }
    }
}
```

---

## **Running the App**

1. Clone the repository:
   ```bash
   git clone https://github.com/username/iOSBeerApp.git
   ```
2. Open the project in Xcode:
   ```bash
   open iOSBeerApp.xcodeproj
   ```
3. Run the app on a simulator or connected device.

---

## **Development Notes**

- **Offline Support**:
  - Data is fetched from Core Data when no internet connection is available.
- **Logs**:
  - The app uses `Logger` for detailed logging of operations, such as API calls and Core Data interactions.
- **Testing**:
  - Dependency injection is used to mock data sources for testing.

---

## **Future Enhancements**

- Add search functionality to filter breweries by name.
- Implement brewery favoriting for quick access.
- Include additional brewery details from the API.
- Support for dark mode.

---
