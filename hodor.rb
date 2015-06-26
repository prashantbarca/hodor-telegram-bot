require 'rest_client'
while 1
    x = ""
    File.open "offset","r" do |a|
        x = x+ a.read
    end
    response = RestClient.get "https://api.telegram.org/#{ENV['TELEGRAM_API']}/getUpdates", {:params => {"offset" => x.to_i+1}}
    updates = JSON.parse(response)["result"]
    updates.each do |update|
        u = update
        if u["message"]["text"] && u["message"]["text"].length<50
            #puts u["message"]["text"]
            length = u["message"]["text"].split(' ').length
        else
            length = 1
        end
        message =""
        length.times do 
            message = message + "Hodor "
        end

        xyz= RestClient.get "https://api.telegram.org/#{ENV['TELEGRAM_API']}/sendMessage" ,{:params => {"chat_id"=> u["message"]["chat"]["id"], "text"=> message}}
        if u["update_id"].to_i>x.to_i
            File.open "offset","w" do |file|
                file.write u["update_id"]
            end
        end
    end
    sleep 1
end
