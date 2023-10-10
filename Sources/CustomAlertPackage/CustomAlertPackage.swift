//
//  Color+Extension.swift
//
//
//  Created by Cengizhan Tomak on 10.10.2023.
//

import SwiftUI

public struct TextFieldParams {
    var Placeholder: String
    var Text: Binding<String>
    
    public init(Placeholder: String, Text: Binding<String>) {
        self.Placeholder = Placeholder
        self.Text = Text
    }
}

struct CustomAlert: View {
    @Binding var IsPresented: Bool
    @State private var isLabelLeftButtonClicked: Bool = false
    @State private var isLabelRightButtonClicked: Bool = false
    let Title: String
    let ImageSystemName: String?
    let Message: String?
    var TextFieldParams: TextFieldParams?
    @Binding var isLeftButtonRed: Bool?
    let LabelLeftButton: (() -> Void)?
    @Binding var isRightButtonRed: Bool?
    let LabelRightButton: (() -> Void)?
    let LeftButton: () -> Void
    let LeftButtonText: String
    let RightButton: () -> Void
    let RightButtonText: String
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Title - SystemImage?(Optional)
            HStack {
                Text(Title)
                    .font(.system(size: 25, weight: .medium))
                
                Spacer()
                
                if let ImageSystemName = ImageSystemName {
                    Image(systemName: ImageSystemName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 30)
                }
            }
            .padding(.horizontal)
            .frame(width: 341, height: 85)
            .foregroundStyle(.primary)
            
            // Message? (Optional)
            if let MessageText = Message {
                Text(MessageText)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    .frame(width: 341, height: 69, alignment: .top)
            }
            
            // TextField? (Optional)
            if let TextFieldParams = TextFieldParams {
                VStack(alignment: .leading) {
                    Text("NAME")
                        .foregroundColor(.primary.opacity(0.5))
                        .font(.system(size: 10, weight: .bold))
                        .padding(.top, 9)
                    
                    Spacer()
                    
                    TextField(TextFieldParams.Placeholder, text: TextFieldParams.Text)
                        .font(.system(size: 20))
                        .padding(.bottom, 17)
                }
                .padding(.horizontal)
                .frame(width: 341, height: 69)
                .background(Color.TextFieldColor)
            }
            
            if let ActionLeft = LabelLeftButton, let ActionRight = LabelRightButton {
                HStack {
                    //                if let Action = LabelLeftButton {
                    Button {
                        //                        isLabelLeftButtonClicked.toggle()
                        ActionLeft()
                    } label: {
                        Label("Add Favorite", systemImage: "heart")
                            .padding(.horizontal)
                            .foregroundColor(isLeftButtonRed ?? false ? .red : .primary.opacity(0.5))
                    }
                    //                }
                    
                    //                if let Action = LabelRightButton {
                    Button {
                        //                        isLabelRightButtonClicked.toggle()
                        ActionRight()
                    } label: {
                        Label("Pin", systemImage: "pin")
                            .foregroundColor(isRightButtonRed ?? false ? .red : .primary.opacity(0.5))
                    }
                    //                }
                    
                    Spacer()
                }
                .frame(width: 341, height: 80)
            }
            
            // Buttons
            HStack(spacing: 0) {
                // Left Button
                Button(role: .cancel) {
                    LeftButton()
                    IsPresented = false
                } label: {
                    Text(LeftButtonText)
                        .font(.system(size: 17))
                        .foregroundColor(.primary.opacity(0.8))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .background(Color.CancelButtonColor.opacity(0.8))
                
                // Right Button (RedColor)
                Button(role: .destructive) {
                    RightButton()
                    IsPresented = false
                } label: {
                    Text(RightButtonText)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .background(TextFieldParams?.Text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty ?? false ? Color.secondary : Color.RedButtonColor.opacity(0.8))
                .disabled(TextFieldParams?.Text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty ?? false)
            }
            .frame(width: 341, height: 63)
        }
        .frame(width: 341)
        .background(Color.AlertColor)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .inset(by: -0.5)
                .stroke(Color.BorderColor, lineWidth: 1)
        )
    }
}

extension View {
    public func CustomAlert(IsPresented: Binding<Bool>,
                            Title: String,
                            ImageSystemName: String? = nil,
                            Message: String? = nil,
                            TextField: TextFieldParams? = nil,
                            isLeftButtonRed: Binding<Bool?>? = nil,
                            LabelLeftButton: (() -> Void)? = nil,
                            isRightButtonRed: Binding<Bool?>? = nil,
                            LabelRightButton: (() -> Void)? = nil,
                            LeftButton: @escaping () -> Void,
                            LeftButtonText: String,
                            RightButton: @escaping () -> Void,
                            RightButtonText: String) -> some View {
        self.modifier(
            CustomAlertModifier(
                IsPresented: IsPresented,
                Title: Title,
                ImageSystemName: ImageSystemName,
                Message: Message,
                TextFieldParams: TextField,
                isLeftButtonRed: isLeftButtonRed ?? .constant(false),
                LabelLeftButton: LabelLeftButton,
                isRightButtonRed: isRightButtonRed ?? .constant(false),
                LabelRightButton: LabelRightButton,
                LeftButton: LeftButton,
                LeftButtonText: LeftButtonText,
                RightButton: RightButton,
                RightButtonText: RightButtonText
            )
        )
    }
}

struct CustomAlertModifier: ViewModifier {
    @Binding var IsPresented: Bool
    let Title: String
    let ImageSystemName: String?
    let Message: String?
    var TextFieldParams: TextFieldParams?
    @Binding var isLeftButtonRed: Bool?
    let LabelLeftButton: (() -> Void)?
    @Binding var isRightButtonRed: Bool?
    let LabelRightButton: (() -> Void)?
    let LeftButton: () -> Void
    let LeftButtonText: String
    let RightButton: () -> Void
    let RightButtonText: String
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                if IsPresented {
                    Color.black
                        .opacity(0.68)
                        .edgesIgnoringSafeArea(.all)
                    
                    CustomAlert(
                        IsPresented: $IsPresented,
                        Title: Title,
                        ImageSystemName: ImageSystemName,
                        Message: Message,
                        TextFieldParams: TextFieldParams,
                        isLeftButtonRed: $isLeftButtonRed,
                        LabelLeftButton: LabelLeftButton,
                        isRightButtonRed: $isRightButtonRed,
                        LabelRightButton: LabelRightButton,
                        LeftButton: LeftButton,
                        LeftButtonText: LeftButtonText,
                        RightButton: RightButton,
                        RightButtonText: RightButtonText
                    )
                }
            }
            .animation(.spring, value: IsPresented)
    }
}
