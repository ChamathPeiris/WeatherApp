//
//  LoadingView.swift
//  WeatherApp
//
//  Created by Chamath Peiris on 2022-05-20.
//

import SwiftUI

//https://www.youtube.com/watch?v=ajmd8hk6OEI&list=PLBn01m5Vbs4A5W_LGcsTXNhRcFpi3SJle&index=5
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
