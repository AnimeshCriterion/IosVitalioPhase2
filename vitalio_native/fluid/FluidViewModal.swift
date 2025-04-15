//
//  FluidViewModal.swift
//  vitalio_native
//
//  Created by HID-18 on 15/04/25.
//

import Foundation
import SwiftUI

class FluidaViewModal  : ObservableObject {
    @Published var selectedGlassSize: Int = 150
    @Published var selectedDrink: String = "Water"
    @Published var containerImage: String = "beverage"
    @Published var imageOuter: String = "beverageoutline"
    @Published var imageOutLastLayer: String = ""
    @Published var fluidLevel: Int = 50

    let drinks: [(name: String, icon: String, containerImage: String, outerImage: String)] = [
        ("Water", "WaterBtn", "water", "wateroutline"),
        ("Juice", "JuiceBtn", "Juice", "juiceoutline"),
        ("Milk", "MilkBtn", "milk", "milkoutline"),
        ("Tea", "TeaBtn", "tea", "teaoutline"),
        ("Coffee", "CoffeeBtn", "coffee", "coffeeoutlin2"),
        ("Beverage", "BeverageBtn", "beverage", "beverageoutline")
    ]


    let glassSizes = [150, 250, 300, 400]
    
    
}
