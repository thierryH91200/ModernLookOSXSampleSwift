//
//  MLCalendarView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 20/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

protocol MLCalendarViewDelegate: NSObjectProtocol {
    func didSelectDate(_ selectedDate: Date)
}

final class MLCalendarView: NSViewController {
    
    @IBOutlet weak var calendarTitle: NSTextField!
    
    var backgroundColor = NSColor.white
    var textColor = NSColor.black
    var selectionColor = NSColor.red
    var todayMarkerColor = NSColor.green
    var dayMarkerColor = NSColor.darkGray
    
    weak var delegate: MLCalendarViewDelegate?
    var date =  Date()
    var selectedDate = Date()
    
    static let shared = MLCalendarView()
    
    var dayLabels: [NSTextField] = []
    var dayCells : Matrix<MLCalendarCell>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        dayLabels = [NSTextField]()
        for i in 1..<8 {
            let day = "day\(i)"
            let textField = view(byID: day) as? NSTextField
            if let textField = textField {
                dayLabels.append(textField)
            }
        }
        
        let cell = "c1"
        let button = view(byID: cell) as? MLCalendarCell
        button?.target = self
        button?.action = #selector(self.cellClicked(_:))
        
        dayCells = Matrix(rows: 6, columns: 7, defaultValue:button!)
        
        for row in 0..<6 {
            for col in 0..<7 {
                let i = (row * 7) + col + 1
                print(i)

                let cell = "c\(i)"
                let button = view(byID: cell) as? MLCalendarCell
                button?.target = self
                button?.action = #selector(self.cellClicked(_:))
                button?.owner = self

                if let button = button {
                    dayCells?[row, col] = button
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        var days = dateFormatter.shortStandaloneWeekdaySymbols
        for i in 0..<(days?.count ?? 0) {
            let day = days?[i].uppercased()
            let col = colforDay( day: i + 1)
            let textField = dayLabels[col]
            textField.stringValue = day!
        }
        
        //    self.date = [NSDate date];
        let bv = view as? MLCalendarBackground
        bv?.backgroundColor = backgroundColor
        layoutCalendar()
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = NSColor.white
        textColor = NSColor.black
        selectionColor = NSColor.red
        todayMarkerColor = NSColor.green
        dayMarkerColor = NSColor.darkGray
        
        let cell = "c1"
        let button = view(byID: cell) as? MLCalendarCell
        button?.target = self
        button?.action = #selector(self.cellClicked(_:))
        
        dayCells = Matrix(rows: 10, columns: 10,defaultValue:button!)
        date = Date()
    }
    
    
    func view(byID id: String?) -> Any? {
        for subview in view.subviews where subview.identifier?.rawValue == id {
            return subview
        }
        return nil
    }
    
    func setDate(_ date: Date?) {
        self.date = toUTC(date)!
        layoutCalendar()
        var cal = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            cal.timeZone = time
        }
        
        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
        let components = cal.dateComponents(unitFlags, from: self.date)
        let month = components.month!
        let year: Int = components.year!
        
        let dateFormatter = DateFormatter()
        let monthName = dateFormatter.standaloneMonthSymbols[month - 1]
        let budgetDateSummary = String(format: "%@, %ld", monthName, year)
        calendarTitle.stringValue = budgetDateSummary
    }
    
    func toUTC(_ date: Date?) -> Date? {
        var cal = Calendar.current
        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
        var components: DateComponents? = nil
        if let date = date {
            components = cal.dateComponents(unitFlags, from: date)
        }
        if let time = TimeZone(abbreviation: "UTC") {
            cal.timeZone = time
        }
        if let components = components {
            return cal.date(from: components)
        }
        return nil
    }
    
    func setSelectedDate(_ selectedDate: Date?) {
        self.selectedDate = toUTC(selectedDate)!
        for row in 0..<6 {
            for col in 0..<7 {
                let cell: MLCalendarCell? = dayCells?[row, col]
                let selected = isSameDate(cell?.representedDate, date: self.selectedDate)
                cell?.isSelected = selected
            }
        }
        
    }
    
    @objc func cellClicked(_ sender: MLCalendarCell?) {
        for row in 0..<6 {
            for col in 0..<7 {
                let cell = dayCells?[row, col]
                cell?.isSelected = false
            }
        }
        let cell = sender
        cell?.isSelected = true
        selectedDate = (cell?.representedDate!)!
        delegate?.didSelectDate(selectedDate)
    }
    
    func monthDay(_ day: Int) -> Date? {
        var calendar = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = time
        }
        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: date)
        var comps = DateComponents()
        comps.day = day
        comps.year = components.year
        comps.month = components.month
        return calendar.date(from: comps)
    }
    
    func lastDayOfTheMonth() -> Int {
        var calendar = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = time
        }
        let daysRange = calendar.range(of: Calendar.Component.day, in: .month, for: date)
        return daysRange!.upperBound - 1
    }
    
    func colforDay( day: Int) -> Int {
        var calendar = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = time
        }
        
        var idx = day - calendar.firstWeekday
        if idx < 0 {
            idx = 7 + idx
        }
        return idx
    }
    
    func dd(_ d: Date?) -> String? {
        var cal = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            cal.timeZone = time
        }
        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
        var cpt: DateComponents? = nil
        if let d = d {
            cpt = cal.dateComponents(unitFlags, from: d)
        }
        return String(format: "%ld-%ld-%ld", cpt?.year ?? 0, cpt?.month ?? 0, cpt?.day ?? 0)
    }
    
    func layoutCalendar() {
//        guard view  != nil else { return }
        for row in 0..<6 {
            for col in 0..<7 {
                let cell = dayCells?[row, col]
                cell?.representedDate = nil
                cell?.isSelected = false
            }
        }
        
        var cal = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            cal.timeZone = time
        }
        
        let unitFlags = Set<Calendar.Component>([.weekday])
        var components = cal.dateComponents(unitFlags, from: monthDay(1)!)
        let firstDay = components.weekday!
        let lastDay = lastDayOfTheMonth()
        var colFirstDay = colforDay( day: firstDay)
        var day = 1
        
        for row in 0..<6 {
            for col in colFirstDay..<7 {
                if day <= lastDay {
                    
                    let cell = dayCells?[row, col]
                    let date = monthDay(day)
                    cell?.setRepresentedDate( date )
                    let selected = isSameDate(date, date: selectedDate)
                    cell?.setSelected( selected)
                    day += 1
                }
            }
            colFirstDay = 0
        }
    }
    
    func stepMonth(_ dm: Int) {
        var calendar = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = time
        }
        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
        var components: DateComponents = calendar.dateComponents(unitFlags, from: date)
        
        var month = components.month! + dm
        var year = components.year!
        if month > 12 {
            month = 1
            year += 1
        }
        if month < 1 {
            month = 12
            year -= 1
        }
        components.year = year
        components.month = month
        self.setDate( calendar.date(from: components)!)
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        stepMonth(1)
        view.needsDisplay = true
    }
    
    @IBAction func prevMonth(_ sender: Any) {
        stepMonth(-1)
    }
    
    func isSameDate(_ d1: Date?, date d2: Date?) -> Bool {
        guard d1 != nil && d2 != nil else { return false }
        var cal = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            cal.timeZone = time
        }
        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
        var components: DateComponents? = nil
        if let d1 = d1 {
            components = cal.dateComponents(unitFlags, from: d1)
        }
        let ry = components?.year
        let rm = components?.month
        let rd = components?.day
        if let d2 = d2 {
            components = cal.dateComponents(unitFlags, from: d2)
        }
        let ty = components?.year
        let tm = components?.month
        let td = components?.day
        return ry == ty && rm == tm && rd == td
    }
    
}

struct Matrix<T> {
    let rows: Int, columns: Int
    var grid: [T]
    init(rows: Int, columns: Int,defaultValue: T) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: defaultValue, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
