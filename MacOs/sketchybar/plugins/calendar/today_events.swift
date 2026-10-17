// Prints today's calendar events, one per line: "<time>\t<title>".
// Exits 2 when calendar access is denied.
import EventKit
import Foundation

let store = EKEventStore()
let sem = DispatchSemaphore(value: 0)
var granted = false
store.requestFullAccessToEvents { ok, _ in granted = ok; sem.signal() }
sem.wait()
guard granted else { exit(2) }

let cal = Calendar.current
let start = cal.startOfDay(for: Date())
let end = cal.date(byAdding: .day, value: 1, to: start)!
let events = store.events(matching: store.predicateForEvents(withStart: start, end: end, calendars: nil))
  .sorted { $0.startDate < $1.startDate }

let fmt = DateFormatter()
fmt.dateFormat = "HH:mm"
for e in events {
  let time = e.isAllDay ? "All day" : "\(fmt.string(from: e.startDate))–\(fmt.string(from: e.endDate))"
  print("\(time)\t\(e.title ?? "(No title)")")
}
