//
//  Logger.swift
//  GetirTodo
//
//  Created by Yilmaz Edis (employee ID: y84185251) on 6.02.2022.
//

struct Logger {
    static func log(at line: UInt = #line,
                    from file: StaticString = #file,
                    what message: String,
                    about type: LogType) {

        let fileName = "\(file)".components(separatedBy:"/").last ?? ""
        print("Line: \(line), \(fileName): \(message) [.\(type)]")
    }

    static func log(at line: UInt = #line,
                    from file: StaticString = #file,
                    what message: String,
                    over error: Error) {
        let fileName = "\(file)".components(separatedBy:"/").last ?? ""
        print("Line: \(line), \(fileName): \(message) - \(error) [.\(LogType.error)]")
    }
}
