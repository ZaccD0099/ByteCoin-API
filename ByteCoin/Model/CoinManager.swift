
import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coin: CoinModel)
    func didGetError(_ error: Error)
}

struct CoinManager {

    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "?apikey=A9D6BE9E-B84F-4920-ACAA-7B7C7EC76845"
    
    
    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(_ currency: String) {
        
        let urlString = "\(baseURL)/\(currency)/USD\(apiKey)"
        
        // 1. create url
        
        if let url = URL(string: urlString) {
            
            // 2. Create url Session
            
            let session = URLSession(configuration: .default)
            
            // 3. Create task
            
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {

                    if let coin = self.parseJSON(safeData) {
                        delegate?.didUpdateCoin(coin)
                    }
                }
            })
            
            // 4. start task
            
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            
            let coin = CoinModel(rate: rate)
            return coin

        } catch {
            delegate?.didGetError(error)
            return nil
        }
    }
    
    

    
}
