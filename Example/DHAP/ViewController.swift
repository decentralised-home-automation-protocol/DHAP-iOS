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
    
    var dhap: DHAP?
    
    var devices = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dhap = DHAP()
        
        deviceTableView.dataSource = self
        deviceTableView.delegate = self
        
        findDevices()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        findDevices()
//    }

    @IBAction func refreshDeviceList(_ sender: Any) {
        findDevices()
    }
    
    private func findDevices() {
        showFetchingIndicatorAlert()
        dhap?.discoverDevices { (result) in
            self.dismissFetchingIndicatorAlert()
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
        }
    }
    
    private func showFetchingIndicatorAlert() {
        let alert = UIAlertController(title: nil, message: "Discovering...", preferredStyle: .alert)
        
        let fetchingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        fetchingIndicator.hidesWhenStopped = true
        fetchingIndicator.style = UIActivityIndicatorView.Style.gray
        fetchingIndicator.startAnimating()
        
        alert.view.addSubview(fetchingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    private func dismissFetchingIndicatorAlert() {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "showDeviceInterface":
//            if let row = deviceTableView.indexPathForSelectedRow?.row {
//                let device = devices[row]
//
//                dhap?.fetchDeviceInterface(device: device)
//            }
//        default:
//            preconditionFailure("Unexpected segue identifier.")
//        }
//    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        cell.selectionStyle = .none
        
        let device = devices[indexPath.row]
        
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.location
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceViewController = DeviceViewController()
        let device = devices[indexPath.row]
        
        dhap?.fetchDeviceInterface(device: device) { (interface) in
            DispatchQueue.main.async {
                deviceViewController.deviceInterface = interface
                deviceViewController.device = device

                self.navigationController?.pushViewController(deviceViewController, animated: true)
            }
        }
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
