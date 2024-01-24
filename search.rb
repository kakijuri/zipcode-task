require 'csv'

def to_n_gram(str, n)
    return str.each_char.each_cons(n).map{|chars| chars.join}
end

index_file = open(ARGV[0])
target_file = open(ARGV[1])
search_ward = ARGV[2]
index_hash = {}
target_zipcodes = []

# indexファイルを読み込む
CSV.foreach(index_file) do |row|
    str_zipcodes = row[1].delete("[" "]")
    zipcodes = str_zipcodes.split(", ")
    index_hash[row[0]] = zipcodes
end

search_wards_of_two_character = to_n_gram(search_ward, 2)

# indexファイルに記録されている検索ワードから検索対象となる郵便番号を取得する
search_wards_of_two_character.each do |ward|
    if (index_hash.has_key?(ward))
        target_zipcodes.concat(index_hash[ward])
    end
end

target_zipcodes_uniq = []
target_zipcodes_uniq = target_zipcodes.uniq
# 上記郵便番号でマザーデータに検索をかける
# TODO: 検索性能再検討
# TODO: 郵便番号が同じレコードがあればレコードを結合して出力したい
CSV.foreach(target_file) do |row|
    zipcode = row[2]
    if (target_zipcodes_uniq.include?(zipcode))
        puts "#{row[2]}, #{row[6]}, #{row[7]}, #{row[8]}"
    end
end