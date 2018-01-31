require "ssdeep"

hash1 = Ssdeep.from_file("file1.txt")
hash2 = Ssdeep.from_file("file2.txt")

value = Ssdeep.compare(hash1, hash2)

puts value




