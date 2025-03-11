//
//  APIManager.swift
//  SavingTransactions
//
//  Created by admin86 on 10/03/25.
//


import Foundation

struct APIManager {
    static let shared = APIManager()
    
    private let apiKey = "AIzaSyBNOqGQhDsCxdnAJk3AsmN39VJCM0A3y44"
    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

    func processReceiptText(receiptText: String, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let prompt = """
        Extract the following details from the receipt text for each item purchased:
        - Item Name
        - Date & time(if available)
        - Price
        - Quantity
        - Category (choose the most appropriate from: Food, Groceries, Coffee/Tea, Snacks, Clothing, Shoes, Accessories, Electronics, Gifts, Education, Movies, Subscriptions, Books, Gas/Fuel, Car Insurance, Home Insurance, Health Insurance, Life Insurance, Haircuts, Cosmetics, Gym, Pharmacy, Pizza, Game, Phone, Beauty, Sports, Social, Transportation, Car, Travel, Health, Pets, Repairs, Housing, Rent, Vegetables, Fruits, Salary, Investments, Bonus, Freelance, Others)
        - type (Expense or Income)

        Return only a JSON response with the structure:
        {
          "transactions": [
            {
              "itemName": "Example Item",
              "date": "YYYY-MM-DD HH:MM:SS",
              "price": 9.99,
              "quantity": 2,
              "category": "Groceries",
              "type": "Expense"
            }
          ]
        }

        If the item does not belong to any of the predefined categories, then categorize that item by yourself with category name, icon (appropriate emoji), and type (expense or income).
        Receipt text: \"\(receiptText)\"
        """

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "Failed to encode request data", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                // Convert API response to a string for debugging
                let responseString = String(data: data, encoding: .utf8) ?? "Invalid response"
                print("📩 API Response:\n\(responseString)")

                let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let candidates = responseJSON?["candidates"] as? [[String: Any]],
                   let firstCandidate = candidates.first,
                   let content = firstCandidate["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {

                    // ✅ Remove Markdown formatting (backticks) from response
                    let cleanJSON = text.replacingOccurrences(of: "```json", with: "")
                                        .replacingOccurrences(of: "```", with: "")
                                        .trimmingCharacters(in: .whitespacesAndNewlines)

                    print("📝 Cleaned JSON Text:\n\(cleanJSON)") // Debug print

                    if let jsonData = cleanJSON.data(using: .utf8) {
                        let transactionsResponse = try JSONDecoder().decode(GeminiResponse.self, from: jsonData)
                        let transactions = transactionsResponse.transactions.map { $0.toTransaction() }
                        completion(.success(transactions))
                    } else {
                        completion(.failure(NSError(domain: "Failed to convert cleaned text to data", code: 0, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid API response format", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

// MARK: - Response Model
struct GeminiResponse: Codable {
    let transactions: [GeminiTransaction]
}

struct GeminiTransaction: Codable {
    let itemName: String
    let date: String?
    let price: Double
    let quantity: Int
    let category: String
    let type: String
    
    func toTransaction() -> Transaction {
        let context = PersistenceController.shared.context
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = price * Double(quantity)
        transaction.date = parseDate(date)
        transaction.paidTo = itemName

        let categoryEntity = PersistenceController.shared.fetchOrCreateCategory(name: category, type: type)
        transaction.category = categoryEntity
        transaction.type = categoryEntity.type
        
        return transaction
    }
}



// MARK: - Date Parsing Helper
func parseDate(_ dateString: String?) -> Date {
    guard let dateString = dateString else { return Date() }
    
    let formats = ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd", "MM/dd/yyyy", "dd/MM/yyyy"]
    let dateFormatter = DateFormatter()
    
    for format in formats {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
    }
    
    return Date()
}
