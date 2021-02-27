//
//  NotificationSheduleView.swift
//  Motivation
//
//  Created by Atahan Sahlan on 14/11/2020.
//

import SwiftUI

struct NotificationSheduleView: View {
   
    @State var startMinute: Int = 00
    @State var endMinute: Int = 00

    @AppStorage("reminderStartMinuteString", store: UserDefaults(suiteName: "group.Sahlan.Motivation")) var startMinuteString: String = "00"
    @AppStorage("reminderEndMinuteString", store: UserDefaults(suiteName: "group.Sahlan.Motivation")) var endMinuteString: String = "00"
    @AppStorage("reminderAmount", store: UserDefaults(suiteName: "group.Sahlan.Motivation")) var amount: Int = 10
    
    @AppStorage("reminderStartHourInt", store: UserDefaults(suiteName: "group.Sahlan.Motivation")) var startHour: Int = 10
    @AppStorage("reminderEndHourInt", store: UserDefaults(suiteName: "group.Sahlan.Motivation")) var endHour: Int = 22

    let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
 
    
    var body: some View {
        ZStack{
            //Rectangle().foregroundColor(Color(UIColor.lightGray)).cornerRadius(10).offset(x:15)
        VStack{
            HStack{
                Text("How Many?").offset(x:8)
                
                Stepper(value: $amount, in: 1...10, step: 1, onEditingChanged: { didChange in
                        // take some action or make a calculation
                })
                {
                        Text("\(amount)")
                }.frame(width: 165, height: 32, alignment: .trailing).offset(x:43)
               
//
            }
            HStack{
                Text("From?")
                
                Stepper("\(String(startHour)):\(startMinuteString)", onIncrement: {
                    
                    self.startMinute += 10
                    if startMinute  == 60{
                        startMinute = 0
                        startHour += 1
                        if startHour == 25{
                            startHour = 00
                        }
                    }
                    if startMinute == 0{
                        startMinuteString = "00"
                    }else{
                        
                    startMinuteString = String(startMinute)
                        
                    }

                    //userDefaults?.set(startMinuteString as String, forKey: "reminderStartMinuteString")
                    //userDefaults?.set(startHour as Int, forKey: "reminderStartHourInt")
                }, onDecrement: {
                    self.startMinute -= 10
                    if startMinute == -10{
                        startMinute = 50
                        startHour -= 1
                        if startHour == -1{
                            startHour = 23
                        }
                    }
                    if startMinute == 0{
                        startMinuteString = "00"
                    }else{
                    startMinuteString = String(startMinute)
                    }
                   // userDefaults?.set(startMinuteString as String, forKey: "reminderStartMinuteString")
                    //userDefaults?.set(startHour as Int, forKey: "reminderStartHourInt")

                }).frame(minWidth: 190, idealWidth: 190, maxWidth: 190, minHeight: 32, idealHeight: 32, maxHeight: 32, alignment: .center).offset(x:50)
  
            }
            HStack{
                Text("To?").frame(width: 50, height: 31, alignment: .leading)
                Stepper("\(String(endHour)):\(String(endMinuteString))", onIncrement: {
                    
                    self.endMinute += 10
                    if endMinute  == 60{
                        endMinute = 00
                        endHour += 1
                        if endHour == 24{
                            endHour = 00
                        }
                    }
                    if endMinute == 0{
                        endMinuteString = "00"
                    }else{
                        endMinuteString = String(endMinute)
                    }
                   // userDefaults?.set(endMinuteString as String, forKey: "reminderEndMinuteString")
                    //userDefaults?.set(endHour as Int, forKey: "reminderEndHourInt")
                }, onDecrement: {
                    self.endMinute -= 10
                    if endMinute == -10{
                        endMinute = 50
                        endHour -= 1
                        if endHour == -1{
                            endHour = 23
                        }
                    }
                    if endMinute == 0{
                        endMinuteString = "00"
                    }else{
                        endMinuteString = String(endMinute)
                    }
                   // userDefaults?.set(endMinuteString as String, forKey: "reminderEndMinuteString")
                   // userDefaults?.set(endHour as Int, forKey: "reminderEndHourInt")
                    
                }).frame(minWidth: 190, idealWidth: 190, maxWidth: 190, minHeight: 32, idealHeight: 32, maxHeight: 32, alignment: .center).offset(x:50)
            }
        }
        
            
        }
        
    }
   
}
func configureNotification(StartHour:Int, StartMinute:Int,EndHour:Int,EndMinute:Int, Title:String, Body:String){
    

    let center = UNUserNotificationCenter.current()

    let content = UNMutableNotificationContent()
    content.title = Title
    content.body = Body
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "Mindful"
    content.userInfo = [Title: Body] // You can retrieve this when displaying notification

    // Setup trigger time
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour:StartHour, minute: StartHour), repeats: false)

    // Create request
    let uniqueID = UUID().uuidString // Keep a record of this if necessary
    let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
    center.add(request)

}

struct NotificationSheduleView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSheduleView()
    }
}
//    var calendar = Calendar.current
//    calendar.timeZone = TimeZone.current
//    print(DateComponents(hour: Hour, minute: Minute))
//    print(Date())
//    let testDate = Date() + 5 // Set this to whatever date you need
//   let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: Hour, minute: Minute), repeats: false)
//    LocalNotificationManager.setNotification(6, of: .hours, repeats: false, title: "Hello", body: "local", userInfo: ["aps" : ["hello" : "world"]])
//
//    let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
//    center.add(request)
