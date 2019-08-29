//
//  ViewController.swift
//  DHAP
//
//  Created by aidengaripoli on 08/29/2019.
//  Copyright (c) 2019 aidengaripoli. All rights reserved.
//

import UIKit
import DHAP

class ViewController: UIViewController {

    @IBOutlet var deviceTableView: UITableView!
    
    var discovery: Discovery?
    
    var devices = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discovery = Discovery()
        
        deviceTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewDevice(_ sender: Any) {
        print("Add New Device")
    }

    @IBAction func refreshDeviceList(_ sender: Any) {
        print("Refresh Device List")
        
        discovery?.discover({ (result) in
            switch result {
            case .foundDevices(let devices):
                print("Devices: \(devices)")
                self.devices = devices
                DispatchQueue.main.async {
                    self.deviceTableView.reloadData()
                }
            case .noDevicesFound:
                print("No Devices Found.")
            case .failure(let error):
                print(error)
            }
        })
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        cell.textLabel?.text = devices[indexPath.row]
        
        return cell
    }
    
}
