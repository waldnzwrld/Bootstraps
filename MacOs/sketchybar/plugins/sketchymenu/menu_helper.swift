// Reads and presses the frontmost app's menu bar via the Accessibility API.
//
//   menu_helper list [path]   one line per child: "<index>\t<enabled 0|1>\t<submenu 0|1>\t<title>"
//                             empty title = separator; no path = menu bar items
//   menu_helper press <path>  performs AXPress on the item at path
//
// path: "/"-separated child indices from the menu bar, e.g. "2/5".
// Exit codes: 1 = no frontmost app / bad path, 2 = Accessibility not granted.

import AppKit
import ApplicationServices

let attrs = [kAXTitleAttribute, kAXEnabledAttribute, kAXChildrenAttribute] as CFArray

func children(_ el: AXUIElement) -> [AXUIElement] {
  var value: AnyObject?
  guard AXUIElementCopyAttributeValue(el, kAXChildrenAttribute as CFString, &value) == .success else { return [] }
  return value as? [AXUIElement] ?? []
}

// A menu bar item or menu item holds its submenu as its single AXMenu child.
func submenu(_ el: AXUIElement) -> AXUIElement? {
  children(el).first
}

func resolve(_ root: AXUIElement, _ path: [Int]) -> AXUIElement? {
  var el = root
  for (depth, idx) in path.enumerated() {
    let container = depth == 0 ? el : submenu(el)
    guard let container, idx >= 0 else { return nil }
    let kids = children(container)
    guard idx < kids.count else { return nil }
    el = kids[idx]
  }
  return el
}

guard AXIsProcessTrusted() else { exit(2) }
guard let pid = NSWorkspace.shared.frontmostApplication?.processIdentifier else { exit(1) }

let app = AXUIElementCreateApplication(pid)
AXUIElementSetMessagingTimeout(app, 1.0)

var menuBarValue: AnyObject?
guard AXUIElementCopyAttributeValue(app, kAXMenuBarAttribute as CFString, &menuBarValue) == .success else { exit(1) }
let menuBar = menuBarValue as! AXUIElement

let args = CommandLine.arguments
let command = args.count > 1 ? args[1] : "list"
let path = (args.count > 2 ? args[2] : "").split(separator: "/").compactMap { Int($0) }

switch command {
case "list":
  guard let target = resolve(menuBar, path) else { exit(1) }
  guard let container = path.isEmpty ? target : submenu(target) else { exit(0) }
  var out = ""
  for (i, item) in children(container).enumerated() {
    var values: CFArray?
    AXUIElementCopyMultipleAttributeValues(item, attrs, AXCopyMultipleAttributeOptions(), &values)
    let v = values as? [AnyObject] ?? []
    let title = (v.count > 0 ? v[0] as? String : nil) ?? ""
    let enabled = (v.count > 1 ? v[1] as? Bool : nil) ?? true
    let hasSub = !((v.count > 2 ? v[2] as? [AXUIElement] : nil) ?? []).isEmpty
    out += "\(i)\t\(enabled ? 1 : 0)\t\(hasSub ? 1 : 0)\t\(title.replacingOccurrences(of: "\t", with: " "))\n"
  }
  FileHandle.standardOutput.write(out.data(using: .utf8)!)
case "press":
  guard !path.isEmpty, let target = resolve(menuBar, path) else { exit(1) }
  AXUIElementPerformAction(target, kAXPressAction as CFString)
default:
  exit(1)
}
