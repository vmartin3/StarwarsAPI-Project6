//
//  ApiClient.swift
//  Project6_Starwars_API
//
//  Created by Vernon G Martin on 2/14/17.
//  Copyright © 2017 Treehouse Island, Inc. All rights reserved.
//

import Foundation

public let VERNnetworkingErrorDomain = "com.vernon.Starwars.networkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedErrorResponse: Int = 20

typealias JSON = [String:AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void
typealias JSONTask = NSURLSessionDataTask

//Was getting the data succesful or not
enum APIResult<T> {
    case Success(T)
    case Failure(NSError)
}

protocol APIClient {
    var configuration: NSURLSessionConfiguration {get}
    var session: NSURLSession {get}
    //Creates a JSON Task from the URL Request which is used in fetch method to make a downlaod
    func JSONTaskWithRequest(request: NSURLRequest, completion: (JSONTaskCompletion)) -> JSONTask
    
    //Getting Data from specified URL and converts it from JSON to a generic type
    func fetch<T: JSONDecodable>(request: NSURLRequest, parse: (JSON) -> T?, completion: (APIResult<T>) -> Void)
}

protocol Endpoint {
    var baseURL: NSURL { get }
    var path: String { get }
    var request: NSURLRequest { get }
}

//Holds API Dictionary Values
protocol JSONDecodable {
    init?(JSON: [String : AnyObject], type: EntityOptions)
}

//Holds Top Level Array of Dictionaries from the API
protocol JSONDecodableTopLevel {
    init?(JSON: [[String : AnyObject]])
}


//Creating data task with a request then converting resulting data into a JSON response and returing the task
extension APIClient{
    func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask {
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard let HTTPResponse = response as? NSHTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                
                let error = NSError(domain: VERNnetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : AnyObject]
                        completion(json, HTTPResponse, nil)
                        print("Succes: Did get starwars object as JSON from API \n")
                        //print(data)
                        
                    } catch let error as NSError {
                        print("Fail: Didn't get starwars object as JSON from API")
                        completion(nil, HTTPResponse, error)
                    }
                default: print("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
                }
            }
        }
        
        return task
    }

    
    //Getting JSON Object and creating instance of the model
    //Stores APIResult value as success or error
    func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult<T> -> Void) {
        
        let task = JSONTaskWithRequest(request) { json, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                guard let json = json else {
                    if let error = error {
                        completion(.Failure(error))
                    } else {
                        // TODO: Implement Error Handling
                    }
                    return
                }
                
                if let value = parse(json) {
                    completion(.Success(value))
                    print("Succesfully Parsed the JSON Data \(value)")
                } else {
                    let error = NSError(domain: VERNnetworkingErrorDomain, code: UnexpectedErrorResponse, userInfo: nil)
                    completion(.Failure(error))
                   //print("Error Connecting \(error) \n Request URL:\(request) -- \(json)")
                }
            }
        }
        
        task.resume()
    }
    
}
