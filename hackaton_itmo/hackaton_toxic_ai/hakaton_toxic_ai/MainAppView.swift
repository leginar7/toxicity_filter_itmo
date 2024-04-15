import SwiftUI

struct MainAppView: View {
    @State var MainText = ""
    @State var ModifiedText = ""
    @State var ifReplace = true
    
    var body: some View {
        VStack {
            Text("Введите текст для проверки на токсичность")
                .font(.system(size: 25))
                .foregroundColor(.black)
            
            TextEditor(text: $MainText)
                        .frame(height: 150) // Задаем фиксированную высоту
                        .padding()
                        .border(Color.gray, width: 1) // Добавляем границу для наглядности
                        .padding()
            
            Text(ModifiedText)
                .frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 5) .stroke(.black, lineWidth: 0.5))
                .padding(.top, 10)
            
            Button(action: {
                if ifReplace{
                    sendRequest()
                    
                } else {
                    
                }
            }, label: {
                Text("Проверить")
                    .padding()
                    .cornerRadius(20)
                    .font(.system(size: 25))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .overlay(RoundedRectangle(cornerRadius: 10) .stroke(.black, lineWidth: 1))
                    .padding(.top, 20)
            })
            
            Spacer()
            
            Toggle("Включить замену текста", isOn: $ifReplace)
            
        }
        .padding()
    }
    
    func sendRequest() {
        guard let url = URL(string: "http://127.0.0.1:5000/process-text") else { return }
        
        let parameters = [
                    "text": MainText,
                    "delete": ifReplace
        ] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error: cannot create JSON from parameters")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            if let decodedResponse = try? JSONDecoder().decode(ResponseJSON.self, from: data) {
                DispatchQueue.main.async {
                    ModifiedText = decodedResponse.toxic
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct ResponseJSON: Codable {
    var toxic: String
}


#Preview {
    MainAppView()
}
