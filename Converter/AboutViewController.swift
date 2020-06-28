//
//  AboutViewController.swift
//  Converter
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Cocoa
import HotKey
import Carbon
import AVFoundation

class AboutViewController: NSViewController {
    
    @IBOutlet weak var clearButton: NSButton!
    @IBOutlet weak var shortcutButton: NSButton!
    
    var listening = false {
        didSet {
            if listening {
                DispatchQueue.main.async {
                    [weak self] in self? .shortcutButton.highlight(true)
                }
            } else {
                DispatchQueue.main.async {
                    [weak self] in self? .shortcutButton.highlight(false)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 检查json
        if Storage.fileExists("globalKeybind.json", in: .documents) {
            let globalKeybinds = Storage.retrieve("globalKeybind.json", from: .documents, as: GlobalKeybindPreferences.self)
            updateKeybindButton(globalKeybinds)
            updateClearButton(globalKeybinds)
            activeGlobalHotkey(globalKeybinds)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        if listening {
            updateGlobalShortcut(event)
        }
    }
    
    
    @IBAction func dismissAbout(_ sender: Any) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate, let itemManager = appDelegate.statusItemManager else { return }
        itemManager.hideAbout()
    }
    
    @IBAction func register(_ sender: Any) {
        unregister(nil)
        listening = true
    }
    
    @IBAction func unregister(_ sender: Any?) {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hotKey = nil
        shortcutButton.title = ""
        
        // 删除json
        Storage.remove("globalKeybind.json", from: .documents)
    }
    
    func updateGlobalShortcut(_ event: NSEvent) {
        listening = false
        
        if let characters = event.charactersIgnoringModifiers {
            let newGlobalKeybind = GlobalKeybindPreferences.init(
                function: event.modifierFlags.contains(.function),
                control: event.modifierFlags.contains(.control),
                command: event.modifierFlags.contains(.command),
                shift: event.modifierFlags.contains(.shift),
                option: event.modifierFlags.contains(.option),
                capsLock: event.modifierFlags.contains(.capsLock),
                carbonFlags: event.modifierFlags.carbonFlags,
                characters: characters,
                keyCode: UInt32(event.keyCode)
            )
            
            // 存储json
            Storage.store(newGlobalKeybind, to: .documents, as: "globalKeybind.json")
            
            updateKeybindButton(newGlobalKeybind)
            clearButton.isEnabled = true
            activeGlobalHotkey(newGlobalKeybind)
        }
    }
    
    func activeGlobalHotkey(_ globalKeybindPreference: GlobalKeybindPreferences) {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hotKey = HotKey(
            keyCombo: KeyCombo(
                carbonKeyCode:  globalKeybindPreference.keyCode,
                carbonModifiers: globalKeybindPreference.carbonFlags
            )
        )
    }
    
    func updateKeybindButton(_ globalKeybindPreference: GlobalKeybindPreferences) {
        shortcutButton.title = globalKeybindPreference.description
    }
    
    func updateClearButton(_ globalKeybindPreference: GlobalKeybindPreferences?) {
        if globalKeybindPreference != nil {
            clearButton.isEnabled = true
        } else {
            clearButton.isEnabled = false
        }
    }
}
