//
//  FAQ.swift
//  MoneyPlant App
//
//  Created by admin15 on 21/12/24.
//

import Foundation

struct FAQ {
    let question: String
    let answer: String
    var isExpanded: Bool = false
    mutating func toggleExpanded() {
           isExpanded.toggle()
       }
    
}

// Define the FAQCategory structure
struct FAQCategory {
    let title: String
    var questions: [FAQ]
}

// Define initial FAQ data
let faqCategories: [FAQCategory] = [
    FAQCategory(title: "General", questions: [
        FAQ(question: "What is the purpose of the Money Plant app?", answer: "The app helps you visualize savings and track expenses."),
        FAQ(question: "Is the Money Plant app free to use?", answer: "Yes, the Money Plant app is completely free to use."),
        FAQ(question: "Can I use the Money Plant app offline?", answer: "No, the app requires an internet connection for syncing data.")
    ]),
    FAQCategory(title: "Expense", questions: [
        FAQ(question: "How do I add an expense?", answer: "Go to the expense section and tap 'Add'."),
        FAQ(question: "Can I edit or delete an expense?", answer: "Yes, long press the expense entry to see the edit and delete options."),
        FAQ(question: "How can I categorize my expenses?", answer: "When adding an expense, select the category dropdown to choose the appropriate category.")
    ]),
    FAQCategory(title: "Savings", questions: [
        FAQ(question: "How does the plant growth feature work?", answer: "The plant grows based on your daily savings goals being met."),
        FAQ(question: "Can I reset my plant's growth?", answer: "Yes, go to settings and select 'Reset Plant Growth' to restart.")
    ]),
    FAQCategory(title: "Tasks", questions: [
        FAQ(question: "What are daily tasks in the app?", answer: "Daily tasks are challenges designed to encourage saving money and staying on track."),
        FAQ(question: "How do I complete a daily task?", answer: "Tap on a task to view its details, then follow the instructions to complete it.")
    ]),
    FAQCategory(title: "Security", questions: [
        FAQ(question: "Is my financial data secure?", answer: "Yes, we use industry-standard encryption to protect your data."),
        FAQ(question: "Can I back up my data?", answer: "Yes, you can back up your data to the cloud from the settings menu."),
        FAQ(question: "What happens if I uninstall the app?", answer: "Your data will remain intact if you have enabled cloud backup.")
    ]),
    FAQCategory(title: "Account", questions: [
        FAQ(question: "How do I update my profile information?", answer: "Go to the Profile section and tap 'Edit' to update your details."),
        FAQ(question: "What should I do if I forget my password?", answer: "Tap 'Forgot Password' on the login screen to reset your password.")
    ]),
    FAQCategory(title: "Issues", questions: [
        FAQ(question: "Why is my plant not growing?", answer: "Ensure you are meeting your daily savings goals to see growth."),
        FAQ(question: "Why can't I add a new expense?", answer: "Check if all required fields are filled before saving an expense."),
        FAQ(question: "How do I report a bug or issue?", answer: "Go to the 'Contact Us' section and send us the details of the issue.")
    ])
]
