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
    var dhap: DHAP?
    
    var devices = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discovery = Discovery()
        dhap = DHAP()
        
        deviceTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDeviceInterface":
            if let row = deviceTableView.indexPathForSelectedRow?.row {
                let device = devices[row]
                
                dhap?.fetchDeviceInterface(device: device)
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if devices.count == 0 {
            self.deviceTableView.setEmptyMessage("No Devices Discovered.")
        } else {
            self.deviceTableView.restore()
        }
        
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        let device = devices[indexPath.row]
        
        cell.textLabel?.text = device.macAddress
        
        return cell
    }
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
//        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
