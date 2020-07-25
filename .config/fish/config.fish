alias rm="rm -i"

function sf 
  source ~/.config/fish/config.fish
  echo "config applied!"
end

# waifu2x
alias waifu2x '/Applications/waifu2x-mac-cli/waifu2x'

function getExtention
  echo (string replace -ra '(.*)\\.(.*)' '$2' $argv[1])
end

function getFilename
  echo (string replace -ra '(.*)\\.(.*)' '$1' $argv[1])
end

function getNoiseAmount
  set ext (getExtention $argv[1])
  if test "$ext" = jpg
    echo 1
  else if  test "$ext" = JPG
    echo 1
  else if test "$ext" = jpeg
    echo 1
  else 
    echo 0
  end
end 

function wa
  if test -n "$argv[2]"
    set noise $argv[2]
  else
    set noise (getNoiseAmount $argv[1])
  end

  set filename (getFilename $argv[1])
  set output "$filename"_noise"$noise"_scale2.png
  waifu2x -n $noise -s 2 -i $argv[1] -o $output
  echo "success!"
end

function wm
  for x in $argv
    wa $x
  end
end


# image album
function createItem
  echo '<div id='$argv[1]'><a href=#'$argv[1]'><img src=./'$argv[1]'></a><br><blockquote contenteditable=true></blockquote></div>'
end

function createStyle
  set width '50vw'
  echo '<style>* { box-sizing: border-box; } blockquote { padding: 0.5rem 0.8rem; margin: auto; max-width: '$width'; text-align: left; } div { text-align: center; } div + div { margin-top: 3vh; } img { max-width: '$width'; }</style>'
end

function createAlbum
  # vars
  set path $argv[1]
  set html $path/index.html
  set head '<html><head>'(createStyle)'</head><body>'
  set foot '</body></html>'
  set exts 'png$|jpg$|gif$|jpeg$'

  # main
  echo $head > $html

  ls -1 $path | grep -E $exts | sort -n | while read line
    createItem $line >> $html
  end
  
  echo $foot >> $html

  # end
  open $html
end
