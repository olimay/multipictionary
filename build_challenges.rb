#!/usr/bin/ruby

puts "butts"

$BASIC_MULT = 2
$EXTRA_MULT = 1
$TARGET_WORDS = 6
$TEMP_FILENAME = 'build_challenges.tmp'
$ALL_WORDS_FILE = 'all_words.txt'
$QR_PATH = './qr'
$QR_SIZE = 6
$ANSWER_KEY = "answers.html"
$ANSWERS_PATH = "./answers"
$ANSWER_BASE_URL = "http://share.pkheavy.com/gggeess"

def extract_challenge_info(challenge_filename)
  all_challenges = []
  challenge_data = File.open(challenge_filename).read
  challenge_data.each_line do |line|
    name, basiccount, extracount = line.split(',')
    basicpoints = $BASIC_MULT * basiccount.to_i
    extrapoints = $EXTRA_MULT * extracount.to_i
    totalpoints = basicpoints + extrapoints
    wordlist = name.split(' ')
    challenge_info = { 
      'name' => name,
      'basicpoints' => basicpoints,
      'extrapoints' => extrapoints,
      'totalpoints' => totalpoints,
      'wordlist' => wordlist
    }
    all_challenges << challenge_info
  end
  return all_challenges
end

def final_wordlist(challenge_info)
  name = challenge_info['name']
  basewords = name.split(' ')
  getcount = 6 - basewords.length
  tempfile = File.open($TEMP_FILENAME,'w')
  name.split(' ').each do |word|
    tempfile.write(word)
    tempfile.write("\n")
  end
  tempfile.close()
  # debug_log = ("cat #{$TEMP_FILENAME}")
  grepcmd = "grep -v -x -f #{$TEMP_FILENAME} #{$ALL_WORDS_FILE}" 
  extrawords = `#{grepcmd}`.split("\n").shuffle
  wordlist = basewords.concat(extrawords[0...getcount]).shuffle
end

def word_qrurl(word)
  loc = `find . -name '#{word}.word.#{$QR_SIZE}.png' -print`
  if (loc == "")
    return nil
  end
  return loc
end

def hash_qrurl(word)
  loc = `find . -name '#{word}.hash.#{$QR_SIZE}.png' -print`
  if (loc == "")
    return nil
  end
  return loc
end

def qr_url(word)
  url = word_qrurl(word)
  if (url == nil)
    url = hash_qrurl(word)
  end
  return url
end

def wordmod(word)
  modfilename = "#{$ALL_WORDS_FILE}".split(".").first.concat(".mod")
  return `egrep '#{word}$' #{modfilename} | cut -d ' ' -f 1`.chomp().to_i
end

def remainder_for_phrase(challenge_info)
  sum = 0
  challenge_info['name'].split(' ').each do |word|
    sum = sum + wordmod(word)
  end
  points = challenge_info['totalpoints'].to_i
  puts "sum #{sum}"
  puts "pts #{points}"
  remainder = sum % points 
  puts remainder
  return remainder
end

def filename(challenge_info)
  return challenge_info['name'].gsub(' ','_').concat(".html")
end

def raw_html(challenge_info)
  cssinfo = "<link rel=\"stylesheet\" type=\"text/css\" href=\"main.css\" />"
  header = "<html>\n<head>\n#{cssinfo}</head>\n<body>\n"

  content = <<HTMLCONTENT1
  <h1>(#{challenge_info['totalpoints']})</h1>
  <table>
HTMLCONTENT1
  content << "  <tr id=\"row1\">\n"
  for i in 0..2
    imgurl = qr_url(challenge_info['wordlist'][i])
    content << "    <td><img alt=\"qr code #{i}\" src=\"#{imgurl}\" /></td>\n"
  end
  content << "   </tr>\n   <tr id=\"row2\">\n"
  for i in 3..5
    imgurl = qr_url(challenge_info['wordlist'][i])
    content << "    <td><img alt=\"qr code #{i}\" src=\"#{imgurl}\" /></td>\n"
  end
  content << "   </tr>\n  </table>"
  content << "<h3>( ___ + ___ +  ___ + ___ + ___ + ___ ) / #{challenge_info['totalpoints']}</h3>\n"
  remainder = remainder_for_phrase(challenge_info)
  puts "remainder: #{remainder}"
  content << "<h3>remainder : #{remainder}</h3>"
  content << "<h3>#{phraseid(challenge_info)}"
  footer = "\n</body>\n</html>"
  html = "#{header}#{content}#{footer}"
  return html
end

def sha1(phrase)
  return `echo "#{phrase}" | shasum | cut -d ' ' -f 1`.chomp()
end

def phraseid(phrase)
  puts "getting id for #{phrase['name']}"
  return sha1(phrase['name']) 
end


def answerfilename(phrase)
  myid = phraseid(phrase)
  x = "/"+"#{myid}"+".txt"
  puts "fn #{x}"
  return x
end

def answerurl(phrase)
  u = $ANSWER_BASE_URL + (answerfilename(phrase))
  puts "u #{u}"
  return u
end

# debug_log = ("touch #{$ANSWER_KEY}.tmp")
# debug_log = ("rm #{$ANSWER_KEY}.tmp")

all_challenges = extract_challenge_info("challenge_phrases.txt")
puts "%d phrases" % all_challenges.length

all_challenges.each do |challenge|
  challenge['wordlist'] = final_wordlist(challenge)
  challenge['phraseid'] = phraseid(challenge)
  puts challenge['wordlist']
  puts challenge['phraseid']

  debug_log = `echo "#{challenge['phraseid']}|#{challenge['name']}" >> #{$ANSWER_KEY}.tmp`
  debug_log = `echo "#{sha1(sha1(challenge['phraseid']))}|wrong" >> #{$ANSWER_KEY}.tmp`  
  debug_log = `echo "#{sha1(challenge['phraseid'])}|wrong" >> #{$ANSWER_KEY}.tmp`  

  answerfile = File.open("#{$ANSWERS_PATH}/#{challenge['phraseid']}.txt",'w')
  puts answerfile
  message = challenge['name'].upcase
  puts "...to write: #{message}"
  answerfile.write(message)
  answerfile.close()
  
  puts "#{challenge['name']} p#{challenge['totalpoints']} r#{remainder_for_phrase(challenge)} #{filename(challenge)}"

  qr_filename = challenge['name'].gsub(' ','_')
  puts qr_filename
  qrfile = "#{$QR_PATH}/#{qr_filename}.answer.png" 
  puts qrfile
  encodestring = "#{answerurl(challenge)}"
  puts "es #{encodestring}"
  debug_log = `echo "#{encodestring}" | qrencode -s 3 --foreground=770077 -o #{qrfile}`
  puts "#{challenge['phraseid']}"

  htmlfile = File.open(filename(challenge),'w')
  htmlfile.write(raw_html(challenge))
  htmlfile.close()
end

encodestring = "#{$ANSWER_BASE_URL}/hahayousuck_hahayousuck.html"
puts encodestring
debug_log = `echo "#{encodestring}" | qrencode -s 3 --foreground=770077 -o #{$QR_PATH}/wrong.answer.png`
puts "wrong status #{debug_log}"

puts "building answer key..."

header = "<html>\n<head></head>\n<body>\n"

row_array = []

shafile = File.open("#{$ANSWER_KEY}.tmp")
shafile.read.each_line do |line|
  puts line 
  hash = `echo "#{line}" | cut -d '|' -f 1`.chomp()
  puts hash
  puts `echo "#{line}" | cut -d '|' -f 2`
  qr = "#{$QR_PATH}/".concat(`echo "#{line}" | cut -d '|' -f 2`.chomp().gsub(' ','_')).concat(".answer.png")
  puts qr
  row_array << "<tr><td>#{hash}</td><td><img src=\"#{qr}\" /></td></tr>\n"
end

debug_log = `echo "That is not dead which can eternal lie, / And with strange aeons even death may die." | qrencode -s 3 --foreground=770077 -o #{$QR_PATH}/keytitle.answer.png`


rows = row_array.sort.join("\n")

content = <<HTMLCONTENT1
<h1>KEY</h1>
<h1><img src="#{$QR_PATH}/keytitle.answer.png" /></h1>
<table>
#{rows}
</table>
HTMLCONTENT1
footer = "\n</body>\n</html>"
html = "#{header}#{content}#{footer}"

answerkeyfile = File.open($ANSWER_KEY,'w')
answerkeyfile.write(html)
answerkeyfile.close()

puts "done"
