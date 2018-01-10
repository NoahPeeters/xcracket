//
//  main.swift
//  xcracket
//
//  Created by Noah Peeters on 10.01.18.
//  Copyright © 2018 Peeters. All rights reserved.
//

import Foundation

guard CommandLine.arguments.count == 2 else {
    print("xcracket: Wrong usage")
    exit(1)
}

let process = Process()
process.launchPath = "/usr/local/bin/raco"
process.arguments = ["exe", CommandLine.arguments[1]]

let pipe = Pipe()
process.standardError = pipe
process.launch()

guard let input = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) else {
    print("xcracket: Invalid Input")
    exit(1)
}

let regexPattern = " *(.*?\\.rkt):(\\d+):(\\d+): (.*)\n * context"
let regex = try! NSRegularExpression(pattern: regexPattern, options: .dotMatchesLineSeparators)
let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..<input.endIndex, in: input))



for match in matches {
    let fileName = input[Range(match.range(at: 1), in: input)!]
    let row = input[Range(match.range(at: 2), in: input)!]
    let column = input[Range(match.range(at: 3), in: input)!]
    let message = input[Range(match.range(at: 4), in: input)!]
    print("\(fileName):\(row):\(column): \(message.replacingOccurrences(of: "\n", with: ""))")
}

if matches.count != 0 {
    exit(1)
}
