require 'rest_client'
while 1
    offset = ""
    File.open "offset","r" do |a|
        offset = offset+ a.read
    end
    response = RestClient.get "https://api.telegram.org/#{ENV['TELEGRAM_API']}/getUpdates", {:params => {"offset" => offset.to_i+1}}
    updates = JSON.parse(response)["result"]
    updates.each do |update|
        if update["message"]["text"] 
            if update["message"]["text"].length < 50
                #puts u["message"]["text"]
                length = update["message"]["text"].split(' ').length
            else 
                length = 1
            end
        else
            length = 1
        end

        message =""
        length.times do 
            message = message + "Hodor "
        end
        xyz= RestClient.get "https://api.telegram.org/#{ENV['TELEGRAM_API']}/sendMessage" ,{:params => {"chat_id"=> update["message"]["chat"]["id"], "text"=> message}}
        if update["update_id"].to_i>offset.to_i
            File.open "offset","w" do |file|
                file.write update["update_id"]
            end
        end
    end
    sleep 1
end
