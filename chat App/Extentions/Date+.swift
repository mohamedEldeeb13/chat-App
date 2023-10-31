//
//  Date+.swift
//  chat App
//
//  Created by Mohamed Abd Elhakam on 28/10/2023.
//

import Foundation

extension Date{
    
    func longDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func MSGTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, to date: Date) -> Float{
        let currentCalender = Calendar.current
        guard let end = currentCalender.ordinality(of: comp, in: .era, for: date) else {return 0}
        guard let start = currentCalender.ordinality(of: comp, in: .era, for: self) else {return 0}
        return Float(end - start)
    }

}
