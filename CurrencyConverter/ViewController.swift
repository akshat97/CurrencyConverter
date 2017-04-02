//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Akshat Khanna on 3/31/17.
//  Copyright © 2017 Akshat Khanna. All rights reserved.
//

//  Cuurency Converter app that uses "fixer.io" API and displays values of USD 1 in various currencies
//
//  Used "SwiftyJSON.swift" to handle the JSON API.
//      source: https://github.com/SwiftyJSON/SwiftyJSON/blob/master/Source/SwiftyJSON.swift
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //array to store currency values and symbols from API
    var Array = [String]()
    
    //constant for API's URL
    
    let baseURL = "http://api.fixer.io/latest?base=USD"
    
    //story board connections to the table, button and spinner
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /*
     Calls getJSON.
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        getJSON()
    }
    
    /*
     Sets the number of rows of the table according to the number of currencies in Array
     
     - returns: size of Array to set the number of rows of the table
     */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Array.count
    }
    
    /*
     Stops the spinner if it is spinning. Creates a reusable cell and
     updates its label with Strings in Array.
     
     - returns: Cell to be inserted in the rows of the table
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        activityIndicator.stopAnimating()
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        Cell.textLabel?.text = (Array[indexPath.row])
        
        return Cell
    }
    
    /*
     Empties out the array. Calls the fixer.io API, gets the data and converts it to JSON. Adds the data
     to Array and reloads the table.
     */
    func getJSON()
    {
        let url = NSURL(string: baseURL)
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
        
            if error == nil
            {
                self.Array = [String]()
                
                let swiftyJSON = JSON(data: data!)
                let currency_rates = swiftyJSON["rates"]
                
                //extracts the currency values and symbols from the dictionary "rates" in the API
                //and adds it to the array in that sequence
                for(key, value) in currency_rates
                {
                    self.Array.append(value.stringValue + " " + key)
                }
                
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
            
            else
            {
                self.Array.append("There was an error")
            }
        }
        
        task.resume()
    }
    
    /*
     Starts the spinner if refreshButton button is pressed. Calls viewDidLoad() to refresh the table
     (currency values).
     */
    @IBAction func refreshButton(_ sender: Any)
    {
        activityIndicator.startAnimating()
        viewDidLoad()
    }
}
