import SwiftUI

struct SignupOtpView: View {
    @Binding var viewModel: IdControl
    @Binding var errorHandler: GlobalErrorHandler
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(PlistManager.shared.string(forKey: "signup_otp_guaidline1"))
                .modifier(SignupOtpGuaidLine())
                .padding(.bottom)
            
            Text("\(viewModel.phone)\(PlistManager.shared.string(forKey: "signup_otp_guaidline2"))")
                .modifier(SignupOtpGuaidLineNumber())
                .padding(.bottom)
                .onChange(of: viewModel.otp) {
                    viewModel.OtpNumberLimit()
                    viewModel.OtpStatusTrue()
                }
            
            VStack(alignment: .leading){
                TextField("인증번호 입력", text: $viewModel.otp)
                    .modifier(SginupOtpFieldModifier(check: $viewModel.otpCheck))
                    .onChange(of: viewModel.otp) {
                        // 변경 사항 처리
                    }
                    .alignmentGuide(.leading) { d in d[.leading] } // TextField의 leading을 기준으로 정렬
                if viewModel.otpCheck != true {
                    Text("일치하지 않습니다.")
                        .modifier(SignupErrorMessageText(check: $viewModel.otpPermissionCheck))
                        .alignmentGuide(.leading) { d in d[.leading] } // TextField의 leading에 맞춰 정렬
                }
            }
            Spacer()
            Button {
                viewModel.SignUpOtpCheckButton()
            } label: {
                Text("\(PlistManager.shared.string(forKey: "signup_otp_access_button"))\(viewModel.timeRemaining)s")
                    .modifier(ActiveUnActiveButton(active: $viewModel.NumberPermissionCheck))
                
            }
            .padding([.horizontal, .bottom])
            .onChange(of: viewModel.timeRemaining){
                if viewModel.timeRemaining == 0 {
                    dismiss()
                }
            }
            .onChange(of: viewModel.otpCloseView) {
                if viewModel.otpCloseView == true{
                    dismiss()
                }
                
            }
        }
        .onDisappear{
            viewModel.otpCloseView = false
            viewModel.timeReset()
        }
        .padding()
        .normalToastView(toast: $viewModel.toast)
    }
}

struct SignupOtpView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandler = GlobalErrorHandler()
        let router = NavigationRouter()
        let viewModel = IdControl(router: router, errorHandler: errorHandler)

        SignupOtpView(viewModel: .constant(viewModel), errorHandler: .constant(errorHandler))
    }
}
