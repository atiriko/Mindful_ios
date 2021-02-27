//
//  Motivation_Widget.swift
//  Motivation Widget
//
//  Created by Atahan Sahlan on 01/10/2020.
//

import WidgetKit
import SwiftUI
import Intents
import FirebaseDatabase
import Firebase

let userDefaults = UserDefaults(suiteName: "group.Sahlan.Motivation")
let image = UIImage(named: "image.jpg")
var backgroundColor =  UIColor(red: 0.117647, green: 0.0196078, blue: 0, alpha: 1)

var textColor = UIColor(Color.white)
var r: Float = 0
var g: Float = 0
var b: Float = 0
var rt: Float = 0
var gt: Float = 0
var bt: Float = 0

//func getcolor(){
//    image!.getColors { colors in
//        color = colors?.background
//}
//}

struct Provider: IntentTimelineProvider {
    //"group.Sahlan.Motivation")) var username: String = "Anonymous"
    
    func placeholder(in context: Context) -> SimpleEntry {
        
        
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "bilmiom", author: "bilmiom", textColor: textColor, backgroundColor: backgroundColor, font: "Montserrat-ExtraBold")
        
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(date: Date(), configuration: configuration, text: "Quote", author: "Author", textColor: .white, backgroundColor: .black, font:"Montserrat-ExtraBold")
        
        completion(entry)
    }

    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        var entries: [SimpleEntry] = []
        

      //  let QuoteImageData = userDefaults!.object(forKey: "QuoteImage")
        let quoteText = userDefaults!.string(forKey: "QuoteText")
        let quoteAuthor = userDefaults!.string(forKey: "QuoteAuthor")
        
        let quoteTexts = userDefaults!.array(forKey: "widgetQuoteTexts")
        let quoteAuthors = userDefaults!.array(forKey: "widgetQuoteAuthors")
        let font = userDefaults?.string(forKey: "FavoriteFont")

  
        
        getPreferedColorsFromUserDefaults()
        let textColor = UIColor(red: CGFloat(rt), green: CGFloat(gt), blue: CGFloat(bt), alpha: 1)
        let backgroundColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1)
        
    
        let currentDate = Date()
        
        if quoteTexts != nil{
            
            
            for hourOffset in 0 ..< quoteTexts!.count - 1 {
                

                let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset*15, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, configuration: configuration, text: quoteTexts![hourOffset] as! String , author: quoteAuthors![hourOffset] as! String,  textColor: textColor, backgroundColor: backgroundColor, font: font ?? "Montserrat-ExtraBold")
                entries.append(entry)
                
                
            }
        }else{
            
                
                
                
                let entryDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, text: quoteText ?? "unknown" , author: quoteAuthor ?? "unknown", textColor: textColor, backgroundColor: backgroundColor, font: "Montserrat-ExtraBold")
                entries.append(entry)
                
                
            
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
    
    //        let timeline = Timeline(entries: entries, policy: .after(futureDate))
    //        completion(timeline)
    //entries.append(entry)
    
    
}
func getPreferedColorsFromUserDefaults(){
    r = userDefaults?.float(forKey: "ColorR") ?? 0
    g = userDefaults?.float(forKey: "ColorG") ?? 0
    b = userDefaults?.float(forKey: "ColorB") ?? 0
    
    rt = userDefaults?.float(forKey: "TextColorR") ?? 1
    gt = userDefaults?.float(forKey: "TextColorG") ?? 1
    bt = userDefaults?.float(forKey: "TextColorB") ?? 1
    
    if(r == rt){
        rt = 1-rt
    }
    if(g == gt){
        gt = 1-gt
    }
    if(b == bt){
        bt = 1-bt
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let configuration: ConfigurationIntent
    let text: String
    let author: String
   // let image: UIImage
    let textColor: UIColor
    let backgroundColor: UIColor
    let font: String
    
}

struct Motivation_WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(Color(entry.backgroundColor))
            //Image(uiImage: entry.image).blur(radius: 3.0).scaledToFit()
            QuoteView(entry: entry)
            //                .background(
            //                Image(uiImage: entry.image)
            //                    .resizable()
            //                    .scaledToFill().blur(radius: 3.0)
            //            )
        }
        
    }
}
struct QuoteView: View {
    var entry: SimpleEntry
    var body: some View{
        VStack(alignment: .center ,spacing: 5){
            
            Text(entry.text).minimumScaleFactor(0.4).font(.custom(entry.font, size: 16)).foregroundColor(Color(entry.textColor))
            
            Text(entry.author).frame(maxWidth: .infinity, alignment: .trailing).minimumScaleFactor(0.3).font(.custom(entry.font, size: 10)).foregroundColor(Color(entry.textColor))
            
            
        }.padding()
        
        
    }
}

@main
struct Motivation_Widget: Widget {
    let kind: String = "Motivation_Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Motivation_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mindful")
        .description("A New You!")
    }
}

struct Motivation_Widget_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Motivation_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "Ideas are these disembodied life forms, they don't have a form, but they have a will. All they want is to be made manifest. If you can manage to open up your consciousness to an idea of living in a world of abundance, then you can believe that, constantly, ideas are trying to find human collaborators.", author: "Eliabeth Taylor" , textColor: textColor, backgroundColor: backgroundColor, font: "Montserrat-ExtraBold"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        Motivation_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "Ideas are these disembodied life forms, they don't have a form, but they have a will. All they want is to be made manifest. If you can manage to open up your consciousness to an idea of living in a world of abundance, then you can believe that, constantly, ideas are trying to find human collaborators.", author: "Eliabeth Taylor", textColor: textColor, backgroundColor: backgroundColor, font: "Montserrat-ExtraBold"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        Motivation_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "Ideas are these disembodied life forms, they don't have a form, but they have a will. All they want is to be made manifest. If you can manage to open up your consciousness to an idea of living in a world of abundance, then you can believe that, constantly, ideas are trying to find human collaborators.", author: "Eliabeth Taylor",  textColor: textColor, backgroundColor: backgroundColor, font: "Montserrat-ExtraBold"))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
