//
//  AppDelegate.swift
//  SwiftTraceOSX
//
//  Created by John Holdsworth on 13/06/2016.
//  Copyright © 2016 John Holdsworth. All rights reserved.
//

import Cocoa

public protocol P {
    var i: Int { get set }
    func x()
    func y() -> Float
    func z( _ d: Int, f: Double, s: String?, g: Float, h: Double, f1: Double, g1: Float, h1: Double, f2: Double, g2: Float, h2: Double, e: Int )
    func rect(r1: NSRect, r2: NSRect) -> NSRect
    func arr(a: [String], b: [Int]) -> [String]
    func c(c: @escaping (_ a: String) -> ()) -> (_ a: String) -> ()
}

open class TestClass: P {

    public var i = 999

    open func x() {
        print( "open func x() \(i)" )
    }

    open func y() -> Float {
        print( "open func y()" )
        return -9.0
    }

    open func z( _ d: Int, f: Double, s: String?, g: Float, h: Double, f1: Double, g1: Float, h1: Double, f2: Double, g2: Float, h2: Double, e: Int ) {
        print( "open func z( \(i) \(d) \(e) \(f) \(String(describing: s)) \(g) \(h) \(f1) \(g1) \(h1) \(f2) \(g2) \(h2) )" )
    }

    public func rect(r1: NSRect, r2: NSRect) -> NSRect {
        return r2
    }

    public func arr(a: [String], b: [Int]) -> [String] {
        return a
    }

    public func c(c: @escaping (_ a: String) -> ()) -> (_ a: String) -> () {
        return c
    }
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print(objc_classArray().count)

        // any inclusions or exlusiona need to come before trace enabled
        //SwiftTrace.include( "Swift.Optiona|TestClass" )

        class MyTracer: SwiftTrace.Swizzle {

            override func onEntry(stack: inout SwiftTrace.EntryStack) {
                print( ">> "+signature )
            }
        }

//        SwiftTrace.patchFactory = MyTracer.self

        type(of: self).traceBundle()
        ObjcTraceTester().a(44, i:45, b: 55, c: "66", o: self, s: Selector(("jjj:")))

        print(SwiftTrace.methodNames(ofClass: TestClass.self))

        var a: P = TestClass()
        a.i = 888
        print(a.i)
        a.x()
        print( a.y() )
        a.x()
        a.z( 88, f: 66, s: "$%^", g: 55, h: 44, f1: 66, g1: 55, h1: 44, f2: 66, g2: 55, h2: 44, e: 77 )
        print(a.arr(a: ["a", "b", "c"], b: [1, 2, 3]))
        print(a.c(c: { _ in }))
        print(SwiftTrace.invoke(target: a as AnyObject, methodName: "SwiftTwaceOSX.TestClass.rect(r1: __C.CGRect, r2: __C.CGRect) -> __C.CGRect", args: NSRect(x: 1111.0, y: 2222.0, width: 3333.0, height: 4444.0), NSRect(x: 11111.0, y: 22222.0, width: 33333.0, height: 44444.0)) as NSRect)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

