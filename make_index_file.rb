require 'csv'

def to_n_gram(str, n)
    return str.each_char.each_cons(n).map{|chars| chars.join}
end

input_file = open(ARGV[0])
index_file = ARGV[1]
index_hash = {}

# 住所データを読み込んでindexファイル用のデータを作成する
CSV.foreach(input_file) do |row|
    zipcode = row[2].to_i
    # TODO: 市区町村以降が"以下に掲載がない場合"の場合にはrow[8]をaddressに含めない
    address = row[6] + row[7] + row[8]
    wards_of_two_character = to_n_gram(address, 2)
    
    wards_of_two_character.each do |ward|
        if (index_hash.has_key?(ward))
            index_hash[ward].push(zipcode)
        else
            index_hash[ward] = [zipcode]
        end
    end 
end
# indexファイルを書き込む
CSV.open(index_file, "w") do |test|
    index_hash.each do |ward, zipcodes|
        test <<  [ward, zipcodes]
    end
end
