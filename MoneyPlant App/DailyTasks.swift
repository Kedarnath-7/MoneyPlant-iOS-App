//
//  DailyTasks.swift
//  MoneyPlant App
//
//  Created by admin86 on 16/12/24.
//

import UIKit

struct DailyTask{
    var date: String
    var targetAmount: String
    var taskProgress: UIImage
}

var dailyTasks: [DailyTask] = [DailyTask(date: "Today", targetAmount: "100", taskProgress: UIImage(systemName: "checkmark.circle")!), DailyTask(date: "Yesterday", targetAmount: "150", taskProgress: UIImage(systemName: "checkmark.circle")!), DailyTask(date: "Dec 15 2024", targetAmount: "170", taskProgress: UIImage(systemName: "checkmark.circle")!), DailyTask(date: "Dec 14 2024", targetAmount: "140", taskProgress: UIImage(systemName: "checkmark.circle")!), DailyTask(date: "Dec 13 2024", targetAmount: "100", taskProgress: UIImage(systemName: "checkmark.circle")!), DailyTask(date: "Dec 12 2024", targetAmount: "80", taskProgress: UIImage(systemName: "checkmark.circle")!), DailyTask(date: "Dec 11 2024", targetAmount: "120", taskProgress: UIImage(systemName: "checkmark.circle")!)]
