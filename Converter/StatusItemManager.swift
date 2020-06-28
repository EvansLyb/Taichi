//
//  StatusItemManager.swift
//  Converter
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Cocoa

class StatusItemManager: NSObject {

    // MARK: - Properties
    
    var statusItem: NSStatusItem?

    var popover: NSPopover?

    var converterVC: ConverterViewController?
    
    
    // MARK: - Init
    
    override init() {
        super.init()

        initStatusItem()
        initPopover()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        initStatusItem()
        initPopover()
    }
    
    
    
    // MARK: - Fileprivate Methods
    
    fileprivate func initStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let itemImageName = NSImage.Name(rawValue: "degrees")
        let itemImage = NSImage(named: itemImageName)
        itemImage?.isTemplate = true
        statusItem?.button?.image = itemImage
        
        statusItem?.button?.target = self
        statusItem?.button?.action = #selector(showConverterVC)
    }
 
    
    fileprivate func initPopover() {
        popover = NSPopover()
        popover?.behavior = .transient
    }
    
        
    @objc fileprivate func showConverterVC() {
        guard let popover = popover, let button = statusItem?.button else { return }

        if converterVC == nil {
            let storyboardName = NSStoryboard.Name(rawValue: "Main")
            let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
            guard let vc = storyboard.instantiateController(withIdentifier: .init("converterID")) as? ConverterViewController else { return }
            converterVC = vc
        }
        
        popover.contentViewController = converterVC
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
 
    
    
    // MARK: - Internal Methods

    func showAbout() {
        guard let popover = popover else { return }
        
        popover.contentViewController?.view.isHidden = true
        
        let storyboardName = NSStoryboard.Name(rawValue: "Main")
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init("aboutID")) as? AboutViewController else { return }

        popover.contentViewController = vc
    }
    
    
    func hideAbout() {
        guard let popover = popover else { return }
        popover.contentViewController?.view.isHidden = true
        popover.contentViewController?.dismiss(nil)
        showConverterVC()
        popover.contentViewController?.view.isHidden = false
    }
}
