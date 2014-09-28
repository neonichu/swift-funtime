//
//  AppDelegate.swift
//  TableThisForNow
//
//  Created by Boris Bügling on 28/09/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

import ObjectiveC.runtime
import UIKit

class ModelObject : NSObject {
    var foo : String
    var bar : NSDate

    init(foo : String, bar : NSDate) {
        self.foo = foo
        self.bar = bar
    }
}

class TableViewCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DynamicDataSource : NSObject, UITableViewDataSource {
    let modelObject : ModelObject
    let properties : UnsafeMutablePointer<objc_property_t>
    var propertyCount : UInt32 = 0

    init(modelObject : ModelObject) {
        self.modelObject = modelObject
        self.properties = class_copyPropertyList(modelObject.dynamicType, &propertyCount)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier(NSStringFromClass(modelObject.dynamicType),
            forIndexPath: indexPath) as UITableViewCell
        let property = properties[indexPath.row]

        cell.textLabel!.text = NSString(CString: property_getName(property),
            encoding: NSUTF8StringEncoding)
        cell.detailTextLabel!.text = modelObject.valueForKey(cell.textLabel!.text).description

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(propertyCount)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var dataSource : DynamicDataSource?
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {

            var modelObject = ModelObject(foo: "Hello World",
                bar: NSDate(timeIntervalSinceNow: 10000))

            dataSource = DynamicDataSource(modelObject: modelObject)

            var rootVC = UITableViewController()
            rootVC.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
            rootVC.tableView.dataSource = dataSource
            rootVC.tableView.registerClass(TableViewCell.classForCoder(),
                forCellReuseIdentifier: NSStringFromClass(modelObject.dynamicType))

            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.rootViewController = rootVC
            self.window!.makeKeyAndVisible()
            
            return true
    }

}

