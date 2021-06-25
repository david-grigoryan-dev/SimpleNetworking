//
//  URLSession.swift
//  SimpleNetworking
//
//  Created by Davit Grigoryan on 6/25/21.
//

import Foundation

public extension URLSession {
    
    @discardableResult
    func execute<T: Decodable>(url: String,
                               parameters: HTTPParameters = nil,
                               headers: HTTPHeaders = nil,
                               body: Data? = nil,
                               method: HTTPMethod = .get,
                               _ completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(from: url, parameters: parameters, headers: headers, body: body, method: method)
            
            #if DEBUG
            //request.log()
            #endif
            
            let task = dataTask(with: request) { (data, response, error) in
                
                #if DEBUG
                //(response as? HTTPURLResponse)?.log(data: data, error: error)
                #endif
                
                if let response = response as? HTTPURLResponse, let unwrappedData = data {
                    
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        do {
                            let result = try JSONDecoder().decode(T.self, from: unwrappedData)
                            completion(Result.success(result))
                        } catch {
                            completion(Result.failure(HTTPNetworkError.noData))
                        }
                    case .failure:
                        completion(Result.failure(HTTPNetworkError.decodingFailed))
                    }
                }
            }
            task.resume()
            
            return task
        } catch {
            completion(Result.failure(HTTPNetworkError.badRequest))
            return nil
        }
    }
}

extension URLRequest {
    
    func log(){
        
        if CommandLine.arguments.contains("-disable-network-log") {
            return
        }
        
        let urlString = url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)
        
        let method = httpMethod != nil ? "\(httpMethod ?? "")" : ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"
        
        var requestLog = "\n>>================= REQUEST =================>>\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key, value) in allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = httpBody {
            requestLog += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
        }
        
        requestLog += "\n>>===========================================>>\n";
        print(requestLog)
    }
}

extension HTTPURLResponse {
    
    func log(data: Data?, error: Error?) {
        
        if CommandLine.arguments.contains("-disable-network-log") {
            return
        }
        
        let urlString = url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        
        var responseLog = "\n<<================= RESPONSE =================<<\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }
        
        let statusColorSign = (statusCode >= 200 && statusCode < 300) ? "🟢" : "🔴"
        responseLog += "HTTP \(statusColorSign) \(statusCode) \(path)?\(query)\n"
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        for (key, value) in allHeaderFields {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data {
            responseLog += "\n\(body.prettyPrintedJSONString ?? "")\n"
        }
        if error != nil {
            responseLog += "\n 🔺 Error: \(error?.localizedDescription ?? "")\n"
        }
        
        responseLog += "<<===========================================<<\n";
        print(responseLog)
    }
}

public extension Data {
    
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        
        return prettyPrintedString
    }
}
