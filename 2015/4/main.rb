require 'digest'

secret = "ckczppom"
i = 0
while true
    md5 = Digest::MD5.hexdigest "#{secret}#{i}"
    if md5[0..4] == '00000'
        puts "1: #{i}"
        break
    end
    i += 1
end

i = 0
while true
    md5 = Digest::MD5.hexdigest "#{secret}#{i}"
    if md5[0..5] == '000000'
        puts "2: #{i}"
        break
    end
    i += 1
end