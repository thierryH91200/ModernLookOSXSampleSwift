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
    
    var backgroundColor = NSColor.textBackgroundColor
    var textColor = NSColor.labelColor
    var selectionColor = NSColor.red
    var todayMarkerColor = NSColor.green
    var dayMarkerColor = NSColor.darkGray
    
    weak var delegate: MLCalendarViewDelegate?
    
    static let shared = MLCalendarView()
    
    var dayLabels: [NSTextField] = []
    var dayCells : Matrix<MLCalendarCell>?
    
    var _date =  Date()
    var date : Date {
        
        get { return _date }
        set {
            _date = toUTC(newValue)!
            layoutCalendar()
            var calendar = Calendar.current
            if let time = TimeZone(abbreviation: "UTC") {
                calendar.timeZone = time
            }
            
            let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
            let components = calendar.dateComponents(unitFlags, from: self._date )
            let month = components.month!
            let year = components.year!
            
            let dateFormatter = DateFormatter()
            let monthName = dateFormatter.standaloneMonthSymbols[month - 1]
            let budgetDateSummary = String(format: "%@, %ld", monthName, year)
            calendarTitle.stringValue = budgetDateSummary
        }
    }
    var _selectedDate = Date()
    var selectedDate : Date? {
        
        get { return _selectedDate }
        set {
            _selectedDate = toUTC(newValue)!
            for row in 0..<6 {
                for col in 0..<7 {
                    let cell = dayCells?[row, col]
                    
                    let isSelected = isSameDate(cell?.representedDate, date: newValue)
                    cell?.isSelected = isSelected
                }
            }
        }
    }
    
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
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        let days = dateFormatter.shortStandaloneWeekdaySymbols
        
        for i in 0..<(days?.count ?? 0) {
            let day = days?[i].uppercased()
            let col = colforDay( day: i + 1)
            let textField = dayLabels[col]
            textField.stringValue = day!
        }
        
        let bv = view as? MLCalendarBackground
        bv?.backgroundColor = backgroundColor
        layoutCalendar()
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = NSColor.windowBackgroundColor
        textColor = .labelColor
        selectionColor = .red
        todayMarkerColor = .green
        dayMarkerColor = .darkGray
        
        let cell = "c1"
        let button = view(byID: cell) as? MLCalendarCell
        button?.target = self
        button?.action = #selector(self.cellClicked(_:))
        
        date = Date()
    }
    
    func view(byID id: String) -> Any? {
        
        if let subview = view.subviews.first(where: { $0.identifier?.rawValue == id }) {
            return subview
        }
        return nil
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
    
    @objc func cellClicked(_ sender: MLCalendarCell?) {
        guard sender?._representedDate != nil else { return }
        for row in 0..<6 {
            for col in 0..<7 {
                let cell = dayCells?[row, col]
                cell?.isSelected = false
            }
        }
        let cell = sender
        cell?.isSelected = true
        selectedDate = (cell?.representedDate!)!
        delegate?.didSelectDate(selectedDate!)
    }
    
    func monthDay(_ day: Int) -> Date? {
        var calendar = Calendar.current
//        calendar.timeZone = .current

        if let time = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = time
        }

        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: date)
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.year = components.year
        dateComponents.month = components.month
        return calendar.date(from: dateComponents)
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
        
        var index = day - calendar.firstWeekday
        if index < 0 {
            index = 7 + index
        }
        return index
    }
    
    //    func dd(_ date: Date) -> String {
    //
    //        var cal = Calendar.current
    //        if let time = TimeZone(abbreviation: "UTC") {
    //            cal.timeZone = time
    //        }
    //        let unitFlags: Set<Calendar.Component>  = [.day, .year, .month]
    //        let  cpt = cal.dateComponents(unitFlags, from: date)
    //
    //        return String(format: "%ld-%ld-%ld", cpt.year!, cpt.month!, cpt.day!)
    //    }
    
    func layoutCalendar() {
        
        for row in 0..<6 {
            for col in 0..<7 {
                let cell = dayCells?[row, col]
                cell?.representedDate = nil
                cell?.isSelected = false
                
                cell?.row = row
                cell?.col = col
            }
        }
        
        var calendar = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = time
        }
        
        let unitFlags = Set<Calendar.Component>([.weekday])
        let components = calendar.dateComponents(unitFlags, from: monthDay(1)!)
        print(components)
        let firstDay = components.weekday!
        let lastDay = lastDayOfTheMonth()
        var colFirstDay = colforDay( day: firstDay)
        var day = 1
        
        for row in 0..<6 {
            for col in colFirstDay..<7 {
                if day <= lastDay {
                    
                    let cell = dayCells?[row, col]
                    let date = monthDay(day)
                    cell?.representedDate = date
                    let isSelected = isSameDate(date, date: selectedDate)
                    cell?.isSelected = isSelected
                    
                    cell?.row = row
                    cell?.col = col
                }
                day += 1
                
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
        var components = calendar.dateComponents(unitFlags, from: date)
        
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
        self.date = calendar.date(from: components)!
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        stepMonth(1)
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
