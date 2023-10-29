//
//  Color+Extension.swift
//
//
//  Created by Cengizhan Tomak on 10.10.2023.
//

import SwiftUI

public struct Title {
    var Text: String
    var SystemImage: String?
    
    public init(Text: String, SystemImage: String? = nil) {
        self.Text = Text
        self.SystemImage = SystemImage
    }
}

public struct TextFieldText {
    var Placeholder: String
    var Text: Binding<String>
    
    public init(Placeholder: String, Text: Binding<String>) {
        self.Placeholder = Placeholder
        self.Text = Text
    }
}

public struct LabelButton {
    var Text: String
    var SystemImage: String
    var Binding: Binding<Bool>
    var Action: (() -> Void)
    
    public init(Text: String, SystemImage: String, Binding: Binding<Bool>, Action: @escaping () -> Void) {
        self.Text = Text
        self.SystemImage = SystemImage
        self.Binding = Binding
        self.Action = Action
    }
}

public struct AlertButton {
    var Text: String
    var Action: (() -> Void)
    
    public init(Text: String, Action: @escaping () -> Void) {
        self.Text = Text
        self.Action = Action
    }
}

struct NoEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

public struct CustomAlert: View {
    @Binding var IsPresented: Bool
    @FocusState private var IsTextFieldFocused: Bool
    let Title: Title
    let Message: String?
    var TextFieldText: TextFieldText?
    var LabelLeft: LabelButton?
    var LabelRight: LabelButton?
    var ButtonLeft: AlertButton
    var ButtonRight: AlertButton
    
    public init(
        IsPresented: Binding<Bool>,
        Title: Title,
        Message: String? = nil,
        TextField: TextFieldText? = nil,
        LabelLeft: LabelButton? = nil,
        LabelRight: LabelButton? = nil,
        ButtonLeft: AlertButton,
        ButtonRight: AlertButton
    ) {
        self._IsPresented = IsPresented
        self.Title = Title
        self.Message = Message
        self.TextFieldText = TextField
        self.LabelLeft = LabelLeft
        self.LabelRight = LabelRight
        self.ButtonLeft = ButtonLeft
        self.ButtonRight = ButtonRight
    }
    
    public var body: some View {
        ZStack {
            if IsPresented {
                Color.black
                    .opacity(0.68)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    // MARK: - Title - SystemImage?(Optional)
                    HStack {
                        Text(Title.Text)
                            .font(.system(size: 25, weight: .medium))
                        
                        Spacer()
                        
                        if let ImageSystemName = Title.SystemImage {
                            Image(systemName: ImageSystemName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 30)
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: 341, height: 85)
                    .foregroundStyle(.primary)
                    
                    // MARK: - Message? (Optional)
                    if let MessageText = Message {
                        Text(MessageText)
                            .font(.system(size: 17))
                            .multilineTextAlignment(.center)
                            .frame(width: 341, height: 69, alignment: .top)
                    }
                    
                    // MARK: - TextField? (Optional)
                    if let TextFieldParams = TextFieldText {
                        VStack(alignment: .leading) {
                            Text("NAME")
                                .foregroundColor(.primary.opacity(0.5))
                                .font(.system(size: 10, weight: .bold))
                                .padding(.top, 9)
                            
                            Spacer()
                            
                            TextField(TextFieldParams.Placeholder, text: TextFieldParams.Text)
                                .focused($IsTextFieldFocused)
                                .font(.system(size: 20))
                                .padding(.bottom, 17)
                        }
                        .padding(.horizontal)
                        .frame(width: 341, height: 69)
                        .background(Color.TextFieldColor)
                    }
                    
                    // MARK: - Label? (Optional)
                    if LabelLeft != nil || LabelRight != nil {
                        HStack {
                            if let LabelLeft = LabelLeft {
                                Button {
                                    LabelLeft.Action()
                                } label: {
                                    Label(LabelLeft.Text, systemImage: LabelLeft.SystemImage)
                                        .padding(.horizontal)
                                        .foregroundColor(LabelLeft.Binding.wrappedValue ? .red : .primary.opacity(0.5))
                                }
                                .buttonStyle(NoEffectButtonStyle())
                            }
                            
                            if let LabelRight = LabelRight {
                                Button {
                                    LabelRight.Action()
                                } label: {
                                    Label(LabelRight.Text, systemImage: LabelRight.SystemImage)
                                        .foregroundColor(LabelRight.Binding.wrappedValue ? .red : .primary.opacity(0.5))
                                }
                                .buttonStyle(NoEffectButtonStyle())
                            }
                            
                            Spacer()
                        }
                        .frame(width: 341, height: 80)
                    }
                    
                    // MARK: - Buttons
                    HStack(spacing: 0) {
                        // Left Button
                        Button {
                            ButtonLeft.Action()
                            IsPresented = false
                        } label: {
                            Text(ButtonLeft.Text)
                                .font(.system(size: 17))
                                .foregroundColor(.primary.opacity(0.8))
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        .background(Color.CancelButtonColor.opacity(0.8))
                        
                        // Right Button (RedColor)
                        Button {
                            ButtonRight.Action()
                            IsPresented = false
                        } label: {
                            Text(ButtonRight.Text)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        .background(TextFieldText?.Text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty ?? false ? Color.secondary : Color.RedButtonColor.opacity(0.8))
                        .disabled(TextFieldText?.Text.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty ?? false)
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
        .animation(.default, value: IsPresented)
        .onChange(of: IsPresented) { NewValue in
            if NewValue {
                IsTextFieldFocused = true
            } else {
                IsTextFieldFocused = false
            }
        }
    }
}

struct CustomAlertModifier: ViewModifier {
    @Binding var IsPresented: Bool
    let Title: Title
    let Message: String?
    var TextFieldText: TextFieldText?
    var LabelLeft: LabelButton?
    var LabelRight: LabelButton?
    var ButtonLeft: AlertButton
    var ButtonRight: AlertButton
    
    func body(content: Content) -> some View {
        content
            .overlay(
                CustomAlert(
                    IsPresented: $IsPresented,
                    Title: Title,
                    Message: Message,
                    TextField: TextFieldText,
                    LabelLeft: LabelLeft,
                    LabelRight: LabelRight,
                    ButtonLeft: ButtonLeft,
                    ButtonRight: ButtonRight
                )
            )
    }
}

extension View {
    public func CustomAlertView(IsPresented: Binding<Bool>,
                                Title: Title,
                                Message: String? = nil,
                                TextField: TextFieldText? = nil,
                                LabelLeft: LabelButton? = nil,
                                LabelRight: LabelButton? = nil,
                                ButtonLeft: AlertButton,
                                ButtonRight: AlertButton) -> some View {
        self.modifier(
            CustomAlertModifier(
                IsPresented: IsPresented,
                Title: Title,
                Message: Message,
                TextFieldText: TextField,
                LabelLeft: LabelLeft,
                LabelRight: LabelRight,
                ButtonLeft: ButtonLeft,
                ButtonRight: ButtonRight
            )
        )
    }
}
