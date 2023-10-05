//
//  KioskHomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 25/09/23.
//

import Foundation
import CardStack
import SwiftUI
//
//struct Person: Identifiable {
//  let id = UUID()
//  let name: String
//  let image: UIImage
//  let distance: Int = { .random(in: 1..<20) }()
//
//  static let mock: [Person] = [
//    Person(name: "Niall Miller", image: UIImage(named: "SplashLogo")!),
//    Person(name: "Sammy Smart", image: UIImage(named: "SplashLogo")!),
//    Person(name: "Edie Bain", image: UIImage(named: "SplashLogo")!),
//    Person(name: "Gia Velez", image: UIImage(named: "SplashLogo")!),
//    Person(name: "Harri Devine", image: UIImage(named: "SplashLogo")!),
//  ]
//}
//
//struct CardView: View {
//  let person: Person
//
//  var body: some View {
//    GeometryReader { geo in
//      VStack {
////        Image(uiImage: self.person.image)
////          .resizable()
////          .aspectRatio(contentMode: .fill)
////          .frame(height: geo.size.width)
////          .clipped()
//        Text(self.person.name)
//        HStack {
//          Text(self.person.name)
//          Spacer()
//          Text("\(self.person.distance) km away")
//            .font(.footnote)
//            .foregroundColor(.secondary)
//        }
//        .padding()
//      }
//      .background(Color.white)
//      .cornerRadius(12)
//      .shadow(radius: 4)
//    }
//  }
//}
//
//struct CardViewWithThumbs: View {
//  let person: Person
//  let direction: LeftRight?
//
//  var body: some View {
//    ZStack(alignment: .topTrailing) {
//      ZStack(alignment: .topLeading) {
//        CardView(person: person)
//        Image(systemName: "checkmark.circle")
//          .resizable()
//          .foregroundColor(Color.green)
//          .opacity(direction == .right ? 1 : 0)
//          .frame(width: 100, height: 100)
//          .padding()
//      }
//
//      Image(systemName: "xmark.circle.fill")
//        .resizable()
//        .foregroundColor(Color.red)
//        .opacity(direction == .left ? 1 : 0)
//        .frame(width: 100, height: 100)
//        .padding()
//    }
//    .animation(.default)
//  }
//}
//
//struct Basic: View {
//  @State var data: [Person] = Person.mock
//
//  var body: some View {
//    CardStack(
//      direction: LeftRight.direction,
//      data: data,
//      onSwipe: { card, direction in
//        print("Swiped \(card.name) to \(direction)")
//      },
//      content: { person, _, _ in
//        CardView(person: person)
//      }
//    )
//    .padding()
//    .scaledToFit()
//    .frame(alignment: .center)
//    .navigationBarTitle("Basic", displayMode: .inline)
//  }
//}
//
//struct Thumbs: View {
//  @State var data: [Person] = Person.mock
//
//  var body: some View {
//    CardStack(
//      direction: LeftRight.direction,
//      data: data,
//      onSwipe: { card, direction in
//        print("Swiped \(card.name) to \(direction)")
//      },
//      content: { person, direction, _ in
//        CardViewWithThumbs(person: person, direction: direction)
//      }
//    )
//    .padding()
//    .scaledToFit()
//    .frame(alignment: .center)
//    .navigationBarTitle("Thumbs", displayMode: .inline)
//  }
//}
//
//struct AddingCards: View {
//  @State var data: [Person] = Array(Person.mock.prefix(2))
//
//  var body: some View {
//    CardStack(
//      direction: LeftRight.direction,
//      data: data,
//      onSwipe: { _, _ in
//        self.data.append(Person.mock.randomElement()!)
//      },
//      content: { person, _, _ in
//        CardView(person: person)
//      }
//    )
//    .padding()
//    .scaledToFit()
//    .frame(alignment: .center)
//    .navigationBarTitle("Adding cards", displayMode: .inline)
//  }
//}
//
//struct ReloadCards: View {
//  @State var reloadToken = UUID()
//  @State var data: [Person] = Person.mock.shuffled()
//
//  var body: some View {
//    CardStack(
//      direction: LeftRight.direction,
//      data: data,
//      onSwipe: { card, direction in
//        print("Swiped \(card.name) to \(direction)")
//      },
//      content: { person, _, _ in
//        CardView(person: person)
//      }
//    )
//    .id(reloadToken)
//    .padding()
//    .scaledToFit()
//    .frame(alignment: .center)
//    .navigationBarTitle("Reload cards", displayMode: .inline)
//    .navigationBarItems(
//      trailing:
//        Button(action: {
//          self.reloadToken = UUID()
//          self.data = Person.mock.shuffled()
//        }) {
//          Text("Reload")
//        }
//    )
//  }
//}
//
//struct CustomDirection: View {
//  enum MyDirection {
//    case up, down
//
//    static func direction(degrees: Double) -> Self? {
//      switch degrees {
//      case 315..<360, 0..<45: return .up
//      case 135..<225: return .down
//      default: return nil
//      }
//    }
//  }
//
//  @State var data: [Person] = Person.mock
//
//  var body: some View {
//    CardStack(
//      direction: MyDirection.direction,
//      data: data,
//      onSwipe: { card, direction in
//        print("Swiped \(card.name) to \(direction)")
//      },
//      content: { person, _, _ in
//        CardView(person: person)
//      }
//    )
//    .padding()
//    .scaledToFit()
//    .frame(alignment: .center)
//    .navigationBarTitle("Custom direction", displayMode: .inline)
//  }
//}
//
//struct CustomConfiguration: View {
//  @State var data: [Person] = Person.mock
//
//  var body: some View {
//    CardStack(
//      direction: LeftRight.direction,
//      data: data,
//      onSwipe: { card, direction in
//        print("Swiped \(card.name) to \(direction)")
//      },
//      content: { person, _, _ in
//        CardView(person: person)
//      }
//    )
//    .environment(
//      \.cardStackConfiguration,
//      CardStackConfiguration(
//        maxVisibleCards: 3,
//        swipeThreshold: 0.1,
//        cardOffset: 40,
//        cardScale: 0.2,
//        animation: .linear
//      )
//    )
//    .padding()
//    .scaledToFit()
//    .frame(alignment: .center)
//    .navigationBarTitle("Custom configuration", displayMode: .inline)
//  }
//}

//struct KioskHomeView: View {
//    
//    @EnvironmentObject var viewModel: KioskViewModel
//    @Environment(\.presentationMode) var presentationMode
//    @State var isPresented = false
//    @StateObject var bleController = BLEController()
//    @State var data: [Person] = Person.mock
//
//  var body: some View {
//      
//        CardStack(
//          direction: LeftRight.direction,
//          data: data,
//          onSwipe: { card, direction in
//            print("Swiped \(card.name) to \(direction)")
//          },
//          content: { person, direction, _ in
//            CardViewWithThumbs(person: person, direction: direction)
//          }
//        )
//        .padding()
//        .scaledToFill()
//        .frame(alignment: .center)
//        .navigationBarTitle("Welcome to Kiosk", displayMode: .inline)
//        .environmentObject(bleController)
//      
//  }
//}

struct KioskHomeView_Previews: PreviewProvider {
  static var previews: some View {
      KioskHomeView()
  }
}

struct KioskHomeView: View {
    @State var isConnected = false // play sound on connection
    @State private var alertItem: AlertItem?
    let buttonArray = ["pencil", "folder", "tray"]

    @State var showOptionsToChangeMode = false
    var body: some View {
        ZStack {
            ShoWorksBackground()
            
        VStack{
            HStack{
                Spacer().frame(height:10)
                Image("laser")
                    .renderingMode(.template)
                    .resizable().aspectRatio(contentMode:
                            .fit).frame(height:45)
                    .foregroundColor(isConnected ? .green : .red)
                    .padding(.trailing,15)
                    .padding(.top,-10)
                    .scaleEffect(x: -1, y: 1)
                    .hoverEffect(.lift)
                    .onAppear {
                        let baseAnimation = Animation.easeInOut(duration: 5)
                        
                        withAnimation(baseAnimation) {
                            self.isConnected = !self.isConnected
                        }
                    }
                    .onTapGesture {
                        //                        if (!self.isConnected) {
                        showInvalidAlertMessage()
                        //                        }
                    }
                
                Image("gear")
                    .renderingMode(.template)
                    .resizable().aspectRatio(contentMode:
                            .fit).frame(height:25)
                    .foregroundColor(.white)
                    .padding(.trailing,15)
                    .padding(.top,-10)
                    .hoverEffect(.lift)
                    .onTapGesture {
                        showOptionsToChangeMode = true
                    }
            }
//            .background(Circle()
//                .trim(from: 0.25, to: 1.0)
//                .rotation(.degrees(-90))
//                .stroke(Color.white ,style: StrokeStyle(lineWidth: 3, lineCap: .square, dash: [5,3], dashPhase: 10))
//                .background(Circle().foregroundColor(Color.aCreamColor))
//                .frame(width: 250, height: 200)
//                .padding(.trailing,-35)
//                .padding(.top,-75)
//                 .frame(maxWidth: .infinity, alignment: .trailing))
            ZStack{
                ForEach(CardModel.data) { card in
                    CardView(card: card).padding(20)
                    .hoverEffect(.lift)
                }.frame(width: 400, height: 450)
//                FloatingMenu.init(buttonArray: buttonArray, onClick: { buttonObject in
//                                   print("\(buttonObject) Clicked")
//                   })
//                .padding(.trailing,20)
//                .padding(.bottom,20)
            }.zIndex(1.0)
                .padding(.leading,100)
                .padding(.trailing,100)
                .padding(.bottom,100)
                .padding(.top,-50)
         
        }.actionSheet(isPresented: $showOptionsToChangeMode) {
            ActionSheet(title: Text("showorks".localized()), message: Text("Choose one of the three modes, default is search mode.."), buttons: [
                .default(Text("Search")) { UserSettings.shared.selectedMode = 0 },
                .default(Text("Check-in")) { UserSettings.shared.selectedMode = 1 },
                .default(Text("Judge")) { UserSettings.shared.selectedMode = 2 },
                .cancel()
            ])
        }
    }
        .alert(item: self.$alertItem, content: { a in
            a.asAlert()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    
    func showInvalidAlertMessage(){
        self.alertItem = AlertItem(type: .dismiss(title: "showorks".localized(), message: "connect_laser".localized(), dismissText: "ok".localized(), dismissAction: {
            // Do something here
        }))
    }
    
    }

struct FloatingMenu: View {
    let buttonArray: [String]
    let onClick: (String)->()
    @State var showButtons = false
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                if showButtons {
                    ForEach(buttonArray, id: \.self) { buttonImage in
                        Button(action: {
                            onClick(buttonImage)
                        }, label: {
                            Image(systemName: buttonImage)
                                .foregroundColor(.white)
                                .font(.body)
                        }).padding(.all, 10)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .padding(.all, 10)
                        .transition(.move(edge: .trailing))
                    }
                }
                Button(action: {
                    withAnimation {
                        showButtons.toggle()
                    }
                }, label: {
                    Image(systemName: showButtons ? "minus" : "plus")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 60, height: 60)
                })
                .background(Color.blue)
                .clipShape(Circle())
                .padding(.all, 10)
            }
        }.padding(.all, 10)
    }
}


struct CardView: View {
    @State var card: CardModel
    @EnvironmentObject var viewModel: KioskViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var isPresented = false
    @StateObject var bleController = BLEController()

    let cardGradient = Gradient(colors: [Color.white.opacity(1), Color.white.opacity(1)])
    var body: some View {
        ZStack(alignment: .topLeading){
            
            
            LinearGradient(gradient: cardGradient,
                           startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading) {
                Text(card.exhibitorName).foregroundColor(.black).font(.heleveticNeueBold(size: 38))
                    .frame(width: 500)
                    .frame(alignment: .center)
                    .hoverEffect(.lift)
                
                Divider().frame(width: 500).background(.black).frame(alignment: .center)

                VStack(alignment: .leading){
                    HStack {
                        Text("Department").foregroundColor(.aTextGrayColorSheetProperties).font(.heleveticNeueMedium(size: 24))
                            .hoverEffect(.lift)
                        Spacer()
                        Text(card.departmentName).foregroundColor(.black).font(.heleveticNeueBold(size: 22))
                            .hoverEffect(.lift)
                    }.padding(.top,25)
                    .padding(.bottom,25)
                    HStack {
                        Text("Entry Number").foregroundColor(.aTextGrayColorSheetProperties).font(.heleveticNeueMedium(size: 24))
                            .hoverEffect(.lift)
                        Spacer()
                        Text(String(card.entryNumber)).foregroundColor(.black).font(.heleveticNeueBold(size: 22))
                            .hoverEffect(.lift)
                    }.padding(.bottom,25)
                    HStack {
                        Text("WEN").foregroundColor(.aTextGrayColorSheetProperties).font(.heleveticNeueMedium(size: 24))
                            .hoverEffect(.lift)
                        Spacer()
                        Text(String(card.wenNumber)).foregroundColor(.black).font(.heleveticNeueBold(size: 22))
                            .hoverEffect(.lift)
                    }.padding(.bottom,25)
                    HStack {
                        Text("Club").foregroundColor(.aTextGrayColorSheetProperties).font(.heleveticNeueMedium(size: 24))
                            .hoverEffect(.lift)
                        Spacer()
                        Text(String(card.clubName)).foregroundColor(.black).font(.heleveticNeueBold(size: 22))
                            .hoverEffect(.lift)
                    }
                    
                }
            }
            .padding()
            .foregroundColor(.black)
            
            HStack {
                Image("rightswipe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                    .opacity(Double(card.x/10 - 1))
                Spacer()
                Image("leftswipe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                    .opacity(Double(card.x/10 * -1 - 1))
            }
        }
        .cornerRadius(12)
        
        .offset(x: card.x, y: card.y)
        .rotationEffect(.init(degrees: card.degree))
        .gesture(
        DragGesture()
            .onChanged { value in
                withAnimation(.default) {
                    card.x = value.translation.width
                    card.y = value.translation.height
                    card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                }
            }
            .onEnded { value in
                withAnimation(.interpolatingSpring(mass:1.0, stiffness:50, damping: 8, initialVelocity: 0)) {
                    switch value.translation.width {
                        case 0...600:
                            card.x = 0; card.degree = 0; card.y=0
                    case let x where x > 300:
                        card.x=1000; card.degree = 12
                    case (-500)...(-1):
                        card.x = 0; card.degree = 0; card.y = 0;
                    case let x where x < -500:
                        card.x = -1000; card.degree = -12
                    default: card.x=0; card.y = 0
                    }
                }
            }
        )
    }
}
