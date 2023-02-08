//
//  GPrintConnectViewController.swift
//  cmallcms
//
//  Created by vicoo on 2017/6/23.
//  Copyright © 2017年 vicoo. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SVProgressHUD

class GPrintConnectViewController: CBController {
    
    lazy var deviceInfo: DeviceInfo = { return DeviceInfo() }()
    
    var controlPeripheral: MyPeripheral?
    var connectedDeviceInfo: [DeviceInfo] = []
    var connectingList: [MyPeripheral] = []
    
//    var animationImageView: UIImageView?
    
    var devicesTableView: UITableView?
    
    var connectionStatus: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CMCColor.loginViewBackgroundColor
        
        devicesTableView = UITableView(frame: view.bounds, style: UITableViewStyle.grouped)
        view.addSubview(devicesTableView!)
        devicesTableView?.delegate = self
        devicesTableView?.dataSource = self
        
        // Do any additional setup after loading the view.
//        self.setScanImageView()
        self.setConnectionStatus(status: LE_STATUS_IDLE)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if connectedDeviceInfo.count <= 0 {
            //self.getuuid(uuid: "")
            
//            let serviceUUID = self.getuuid(uuid: "22222222223333333333111111111188")
//            let txUUID = self.getuuid(uuid: "22222222223333333333111111111100")
//            let rxUUID = self.getuuid(uuid: "22222222223333333333111111111133")
//            
//            let disUUID1 = self.getuuid(uuid: "aaaa")
//            let disUUID2 = self.getuuid(uuid: "cccc")
            
            self.configureTransparentServiceUUID(nil, txUUID: nil, rxUUID: nil)
            self.configureDeviceInformationServiceUUID(nil, uuid2: nil)
        }
        
        self.startScan()
    }
    
    func getuuid(uuid: String) -> String {
        let udata = NSMutableString()
        
        udata.setString(uuid)
        if udata.length == 32 {
            udata.insert("_", at: 20)
            udata.insert("_", at: 16)
            udata.insert("_", at: 12)
            udata.insert("_", at: 8)
        }
        return udata as String;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopScan()
//        self.devicesList.removeAllObjects()
//        self.devicesList = nil
    }

    ///
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
//    func setScanImageView() -> Void {
//        self.animationImageView = UIImageView(frame: CGRect(x: 0, y: 0, w: 130, h: 139))
//        view.addSubview(self.animationImageView!)
//        self.animationImageView?.image = UIImage.sd_animatedGIFNamed("icon_print_search")
//        
//        self.animationImageView?.center = view.center
//    }
    
    func setConnectionStatus(status: Int) {
        switch status {
        case LE_STATUS_IDLE:
            log.info("LE_STATUS_IDLE")
        case LE_STATUS_SCANNING:
            log.info("LE_STATUS_IDLE")
        default:
            log.info("default")
        }
    }
    
    override func startScan() {
        super.startScan()
        
        if connectingList.count > 0 {
            for (idx, item) in connectingList.enumerated() {
                let connectingPeripheral = item
                
                if connectingPeripheral.connectStaus == UInt8(MYPERIPHERAL_CONNECT_STATUS_CONNECTING) {
                    devicesList.add(connectingPeripheral)
                }
                else {
                    connectingList.remove(at: idx)
                }
            }
        }
        self.setConnectionStatus(status: LE_STATUS_SCANNING)
    }
    
    override func stopScan() {
        super.stopScan()
    }
    
    override func updateDiscoverPeripherals() {
        super.updateDiscoverPeripherals()
        self.devicesTableView?.reloadData()
    }
    
    override func updateMyPeripheral(forDisconnect myPeripheral: MyPeripheral!) {
        
        if myPeripheral == controlPeripheral {
            
        }
        
        for (idx, item) in connectedDeviceInfo.enumerated() {
            
            if item.myPeripheral == myPeripheral {
                connectedDeviceInfo.remove(at: idx)
                break
            }
        }
        
        for (idx, item) in connectingList.enumerated() {
            
            if item == myPeripheral {
                connectingList.remove(at: idx)
                break
            }
        }
        
        self.devicesTableView?.reloadData()
        
        if connectionStatus == LE_STATUS_SCANNING {
            self.stopScan()
            self.startScan()
            self.devicesTableView?.reloadData()
        }
    }
    
    override func updateMyPeripheral(forNewConnected myPeripheral: MyPeripheral!) {
        
        BLKWrite.instance().setPeripheral(myPeripheral)
        
        let tmpDeviceInfo = DeviceInfo()
        tmpDeviceInfo.myPeripheral = myPeripheral
        tmpDeviceInfo.myPeripheral.connectStaus =  myPeripheral.connectStaus
        
        var b = false
        for (idx, item) in connectedDeviceInfo.enumerated() {
            if item.myPeripheral == myPeripheral {
                b = true
                break
            }
        }
        if !b {
            connectedDeviceInfo.append(tmpDeviceInfo)
        }
        
        for (idx, item) in connectingList.enumerated() {
            if item == myPeripheral {
                connectingList.remove(at: idx)
                break
            }
        }
        
        for (idx, item) in devicesList.enumerated() {
            if (item as! MyPeripheral) == myPeripheral {
                devicesList.remove(idx)
                break
            }
        }
        self.devicesTableView?.reloadData()
    }
    
    func actionButtonCancelConnect(sender: UIButton) {
        func disconnectDevice() {
            let idx = sender.tag
            let tmpPeripheral = devicesList[idx] as! MyPeripheral
            tmpPeripheral.connectStaus = UInt8(MYPERIPHERAL_CONNECT_STATUS_IDLE)
            devicesList.replaceObject(at: idx, with: tmpPeripheral)
            
            for (idx, item) in connectingList.enumerated() {
                if item == tmpPeripheral {
                    connectingList.remove(at: idx)
                    break
                }
            }
            
            self.disconnectDevice(tmpPeripheral)
            self.devicesTableView?.reloadData()
        }
        
        let alert = UIAlertController(title: "提示", message: "断开连接", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (alertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (alertAction) in
            disconnectDevice()
        }))
        
        self.presentVC(alert)
    }
 
    func actionButtonDisconnect(sender: UIButton) {
        
        func disconnectDevice() {
            let idx = sender.tag
            let tmpDeviceInfo = connectedDeviceInfo[idx]
            self.disconnectDevice(tmpDeviceInfo.myPeripheral)
        }
        
        let alert = UIAlertController(title: "提示", message: "断开连接", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (alertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (alertAction) in
            disconnectDevice()
        }))
        
        self.presentVC(alert)
    }
}

extension GPrintConnectViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return connectedDeviceInfo.count
        case 1:
            return devicesList.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "connectedList")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "connectedList")
            }
            let tmpDeviceInfo = connectedDeviceInfo[indexPath.row]
            
            if let tmpAdvName = tmpDeviceInfo.myPeripheral.advName, tmpAdvName.length > 0  {
                cell?.textLabel?.text = tmpAdvName
            }
            else {
                cell?.textLabel?.text = "Unknow"
            }
            
            cell?.detailTextLabel?.text = "已连接"
            cell?.accessoryView = nil
            
            //actionButtonDisconnect
            
            let accessoryButton = UIButton(type: UIButtonType.custom)
            accessoryButton.setImage(UIImage(named:"icon_accessory"), for: UIControlState.normal)
            accessoryButton.addTarget(self,
                                      action: #selector(GPrintConnectViewController.actionButtonDisconnect(sender:)
                ),
                                      for: UIControlEvents.touchUpInside)
            
            accessoryButton.frame = CGRect(x: 0, y: 0, w: 40, h: 35)
            accessoryButton.tag = indexPath.row
            cell?.accessoryView = accessoryButton
            
            break
        case 1:
            
            cell = tableView.dequeueReusableCell(withIdentifier: "devicesList")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "devicesList")
            }
            
            let tmpPeripheral = devicesList[indexPath.row]
            if let tmpAdvName = (tmpPeripheral as! MyPeripheral).advName, tmpAdvName.length > 0  {
                cell?.textLabel?.text = tmpAdvName
            }
            else {
                cell?.textLabel?.text = "Unknow"
            }
            cell?.detailTextLabel?.text = "未连接"
            cell?.accessoryView = nil
            
            if let peripheral = tmpPeripheral as? MyPeripheral, peripheral.connectStaus == UInt8(MYPERIPHERAL_CONNECT_STATUS_CONNECTING) {
                
                let accessoryButton = UIButton(type: UIButtonType.custom)
                accessoryButton.setImage(UIImage(named:"icon_accessory"), for: UIControlState.normal)
                accessoryButton.addTarget(self,
                                          action: #selector(GPrintConnectViewController.actionButtonCancelConnect(sender:)
                    ),
                                          for: UIControlEvents.touchUpInside)
                
                accessoryButton.frame = CGRect(x: 0, y: 0, w: 40, h: 35)
                accessoryButton.tag = indexPath.row
                cell?.accessoryView = accessoryButton
            }
            
            break
            
        default:
            break
        }
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "已连接蓝牙设备"
        default:
            return "附件的蓝牙设备"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            deviceInfo = connectedDeviceInfo[indexPath.row]
            controlPeripheral = deviceInfo.myPeripheral
            self.stopScan()
            self.setConnectionStatus(status: LE_STATUS_IDLE)
        default:
            let count = devicesList.count
            if count != 0 && count > indexPath.row {
                let tmpPeripheral = devicesList[indexPath.row] as! MyPeripheral
                
                if tmpPeripheral.connectStaus != UInt8(MYPERIPHERAL_CONNECT_STATUS_IDLE) {
                    break
                }
                
               // SVProgressHUD.show(withStatus: "连接设备中...")
                
                self.connectDevice(tmpPeripheral)
                tmpPeripheral.connectStaus = UInt8(MYPERIPHERAL_CONNECT_STATUS_CONNECTING)
                devicesList.replaceObject(at: indexPath.row, with: tmpPeripheral)
                connectingList.append(tmpPeripheral)
                self.devicesTableView?.reloadData()
                
                SVProgressHUD.show(withStatus: "连接成功")
                SVProgressHUD.dismiss(withDelay: 1.0)
            }
        }
    }
}
