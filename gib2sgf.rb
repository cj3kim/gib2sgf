
Alphabet = ('a'..'z').to_a

Okiisi=[nil,nil,
          '[dp][pd]',\
          '[dp][pd][pp]',\
          '[dp][dd][pd][pp]',\
          '[dp][dd][pd][pp][jj]',\
          '[dp][dd][pd][pp][dj][pj]',\
          '[dp][dd][pd][pp][dj][pj][jj]',\
          '[dp][dd][pd][pp][dj][pj][jd][jp]',\
          '[dp][dd][pd][pp][dj][pj][jd][jp][jj]',\
          ]
PropHash = { 'GAMENAME'      => 'GN',\
             'GAMEDATE'      => 'DT',\
             'GAMEPLACE'     => 'PC',\
             'GAMERESULT'    => 'RE',\
             'GAMEBLACKNAME' => 'PB',\
             'GAMEWHITENAME' => 'PW'
           }

n=0
sgf="(;FF[3]GM[1]SZ[19]\n"
sgfHA=''
while gets
   s=$_
   if s[/^STO/]

      sgf << sgfHA  if n == 0 && sgfHA != ''
      sgf << "\n"   if n % 10 == 0 && n!=0
      a = s.split(' ')
      c = 'B'
      c = 'W' if a[3]!='1'
      x = a[4].to_i
      y = a[5].to_i
      puts "a #{a}"
      puts "c #{c}"
      puts "x #{x}"
      puts "y #{y}"



      sgf_part = ";#{c}[#{Alphabet[x]+Alphabet[y]}]"
      sgf += sgf_part

      n+=1
   elsif s =~ /\\\[([^\=]*)\=([^\=\\]*)\\\]/
      if $1=='GAMECONDITION'
         if $2=~ /^(\d)/
            ha=$1.to_i
            if Okiisi[ha]
               sgfHA << 'HA['+$1+']'
               sgfHA << 'AB'+Okiisi[ha]+"\n"
            end
         end
      end
      if PropHash[$1]
         propName=PropHash[$1]
         propValue=$2
         rank=''
         if propName=='PB'||propName=='PW'
            if propValue.sub!(/([^\(]*)\(([^\)]*)\)$/){$1}
               rank='BR['
               rank='WR[' if propName=='PW'
               rank+=$2+']'
            end
         end
         sgf+=propName+'['+propValue+']'
         sgf+=rank unless rank.empty?
         sgf+="\n"
      end
   end
end
sgf+=")\n"
print sgf
exit
